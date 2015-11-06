package jb.ex.strm.topol;

import java.util.Random;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;

import org.apache.storm.guava.util.concurrent.FutureCallback;
import org.apache.storm.guava.util.concurrent.Futures;
import org.apache.storm.guava.util.concurrent.ListenableFuture;
import org.apache.storm.guava.util.concurrent.ListeningExecutorService;
import org.apache.storm.guava.util.concurrent.MoreExecutors;

import backtype.storm.Config;
import backtype.storm.LocalCluster;
import backtype.storm.LocalDRPC;
import backtype.storm.drpc.DRPCSpout;
import backtype.storm.drpc.ReturnResults;
import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;
import backtype.storm.utils.Utils;


public class GenDRPCTopology {

	LocalDRPC drpc;
	LocalCluster cluster;
	
	public LocalDRPC getLocalDRPC(){
		return drpc;
	}

	public static class ExclamationBolt extends BaseBasicBolt {

		public void declareOutputFields(OutputFieldsDeclarer declarer) {
			declarer.declare(new Fields("result", "return-info"));
		}

		public void execute(Tuple tuple, BasicOutputCollector collector) {
			String arg = tuple.getString(0);
			Object retInfo = tuple.getValue(1);
			collector.emit(new Values(arg + "!!!", retInfo));
		}

	}

	public static class QuestionBolt extends BaseBasicBolt {

		public void declareOutputFields(OutputFieldsDeclarer declarer) {
			declarer.declare(new Fields("result", "return-info"));
		}

		public void execute(Tuple tuple, BasicOutputCollector collector) {
			String arg = tuple.getString(0);
			Object retInfo = tuple.getValue(1);
			
			Utils.sleep(1000);
			
			collector.emit(new Values(arg + "???", retInfo));
		}

	}


	public static class ValidationBolt extends BaseBasicBolt {

		private static final Random r = new Random(182739821L);
		
		public void declareOutputFields(final OutputFieldsDeclarer outputFieldsDeclarer) {
		    outputFieldsDeclarer.declareStream("squestion", new Fields("field1", "return-info"));
		    outputFieldsDeclarer.declareStream("sexclaim",  new Fields("field1", "return-info"));
		}
		
		public void execute(Tuple tuple, BasicOutputCollector collector) {
			String arg = tuple.getString(0);
			Object retInfo = tuple.getValue(1);
			
			
			int dp = r.nextInt(100);
			
			if(dp > 30){
				collector.emit("squestion", new Values(arg+"_"+dp, retInfo));
			}else{
				collector.emit("sexclaim", new Values(arg+"_"+dp, retInfo));
			}
			
		}
		
		

	}

	public static void main(String[] args) {
		GenDRPCTopology gt = new GenDRPCTopology();
		gt.startup();
	}

	public void startup(){
		TopologyBuilder builder = new TopologyBuilder();
		drpc = new LocalDRPC();

		DRPCSpout spout = new DRPCSpout("exclamation", drpc);
		builder.setSpout("drpc", spout);
		builder.setBolt("validate", new ValidationBolt(), 3)
			.shuffleGrouping("drpc");
		builder.setBolt("exclaim", new ExclamationBolt(), 3)
			.shuffleGrouping("validate", "sexclaim");
		builder.setBolt("question", new QuestionBolt(), 3)
			.shuffleGrouping("validate", "squestion");
		builder.setBolt("return", new ReturnResults(), 3)
			.shuffleGrouping("exclaim")
			.shuffleGrouping("question");

		cluster = new LocalCluster();
		Config conf = new Config();
		cluster.submitTopology("exclaim", conf, builder.createTopology());

		System.out.println(drpc.execute("exclamation", "drpc service initialized"));
		
		
		
		ListeningExecutorService service = MoreExecutors.listeningDecorator(Executors.newFixedThreadPool(10));
		ListenableFuture<String> explosion = service.submit(new Callable<String>() {
		  public String call() {
			  System.out.println("call ...");
			  Utils.sleep(1000);
		    return "done";
		  }
		});
		
		Futures.addCallback(explosion, new FutureCallback<String>() {
		  // we want this handler to run immediately after we push the big red button!
		  public void onSuccess(String explosion) {
			  System.out.println("success");
		  }
		  public void onFailure(Throwable thrown) {
			  System.out.println("");
		  }
		});
		
//		System.out.println("=================== starting test ================");
//		for(int i=0;i<100;i++){
//			// FIXME: sync op, make it async
//			System.out.println(drpc.execute("exclamation", "foo_"+i));
//		}
		
	}

	public void shutdown(){
		drpc.shutdown();
		cluster.shutdown();
	}
}