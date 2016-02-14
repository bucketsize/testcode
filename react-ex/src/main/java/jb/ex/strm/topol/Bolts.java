package jb.ex.strm.topol;

import java.util.Random;

import backtype.storm.topology.BasicOutputCollector;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseBasicBolt;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Tuple;
import backtype.storm.tuple.Values;
import backtype.storm.utils.Utils;

public class Bolts {

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
	
}
