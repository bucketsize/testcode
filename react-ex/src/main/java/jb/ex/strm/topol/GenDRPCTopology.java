package jb.ex.strm.topol;

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
import backtype.storm.topology.TopologyBuilder;
import backtype.storm.utils.Utils;

public class GenDRPCTopology {

	LocalDRPC drpc;
	LocalCluster cluster;
	
	public LocalDRPC getLocalDRPC(){
		return drpc;
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
		builder.setBolt("validate", 	new Bolts.ValidationBolt(), 3)
			.shuffleGrouping("drpc");
		builder.setBolt("exclaim", 		new Bolts.ExclamationBolt(), 3)
			.shuffleGrouping("validate", "sexclaim");
		builder.setBolt("question", 	new Bolts.QuestionBolt(), 3)
			.shuffleGrouping("validate", "squestion");
		builder.setBolt("return", 		new ReturnResults(), 3)
			.shuffleGrouping("exclaim")
			.shuffleGrouping("question");

		cluster = new LocalCluster();
		Config conf = new Config();
		cluster.submitTopology("exclaim", conf, builder.createTopology());

		System.out.println(drpc.execute("exclamation", "drpc service initialized"));
		
//		System.out.println("=================== starting test ================");
//		for(int i=0;i<100;i++){
//			// sync op, make it async
//			System.out.println(drpc.execute("exclamation", "foo_"+i));
//		}
		
		System.out.println("=================== starting test ================");

		// async version
		for(int in=0;in<100;in++){
			final int i = in;
			ListeningExecutorService service = MoreExecutors.listeningDecorator(Executors.newFixedThreadPool(10));
			ListenableFuture<String> explosion = service.submit(new Callable<String>() {
				public String call() {
					System.out.println("call ... "+i);
					return drpc.execute("exclamation", "foo_"+i);
				}
			});

			Futures.addCallback(explosion, new FutureCallback<String>() {
				// we want this handler to run immediately after we push the big red button!
				public void onSuccess(String result) {
					System.out.println(">> "+result);
				}
				public void onFailure(Throwable thrown) {
					System.out.println("");
				}
			});
		}
		System.out.println("=================== sent requests ================");
		

		
		Utils.sleep(1000*60);
		System.out.println("=================== completed test ================");
		shutdown();
		
	}

	public void shutdown(){
		drpc.shutdown();
		cluster.shutdown();
	}
}