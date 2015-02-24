package jb.ex.config;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CountDownLatch;

import jb.ex.vo.Sink;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


@Configuration
public class AppConfig {
	
	public static final int NUM_SIGNALS = 10000;
	public static final int UPD_INTERVL = 10;
	public static final int PROC_LATNCY = 100;
	
	public static final int NE_THREADS = 64;
	public static final int ND_THREADS = 2;
	
	public static final String PROC_EVENT = "__req_processing_event__";
	
    @Bean(name="pLatch")
    public CountDownLatch pLatch() {
        return new CountDownLatch(NUM_SIGNALS);
    }

    @Bean(name="resetLatches")
    public ConcurrentMap<String, CountDownLatch> resetLatches() {
        return new ConcurrentHashMap<String, CountDownLatch>();
    }
    
    @Bean 
    public Sink sink(){
    	return new Sink(UPD_INTERVL);
    }
}
