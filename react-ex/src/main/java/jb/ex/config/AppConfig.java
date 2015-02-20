package jb.ex.config;

import java.util.concurrent.CountDownLatch;

import jb.ex.Constants;
import jb.ex.vo.Sink;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {

    @Bean
    public CountDownLatch latch() {
        return new CountDownLatch(Constants.NUM_SIGNALS);
    }

    @Bean 
    public Sink sink(){
    	return new Sink(10);
    }
}
