package jb.ex.config;

import java.util.concurrent.CountDownLatch;

import jb.ex.vo.Sink;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

	public static int NUM_SIGNALS = 10000;
	public static int UPD_INTERVL = 10;
	public static int PROC_LATENCY = 30;

	public static String PROC_EVENT = "__req_processing_event__";
	
    @Bean
    public CountDownLatch latch() {
        return new CountDownLatch(NUM_SIGNALS);
    }

    @Bean 
    public Sink sink(){
    	return new Sink(UPD_INTERVL);
    }
}
