package jb.ex.utils;

import jb.ex.react.SignalProducer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class TimeUtils {
	private static final Logger LOG = LoggerFactory.getLogger(TimeUtils.class);

	public static void sleep(long millis){
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	public static void outTP(int number, long startMillis){
    	long elapsed = System.currentTimeMillis()-startMillis;
    	LOG.info("run Time={}", elapsed);
    	LOG.info("run Throughput={}", number / (elapsed / 1000.0f));
    }
}
