package jb.ex;

import jb.ex.config.AppConfig;
import jb.ex.config.ReactorConfig;
import jb.ex.react.SignalProducer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

import reactor.core.Reactor;

@Configuration
@EnableAutoConfiguration
@Import(value={AppConfig.class, ReactorConfig.class})
public class ReactDemo implements CommandLineRunner {
	
    @Autowired
    private Reactor reactor;

    @Autowired
    private SignalProducer publisher;

    public void run(String... args) throws Exception {
    	System.out.println("starting producer");
    	publisher.produceSignals(Constants.NUM_SIGNALS);
    	System.out.println("done ... waiting");
    }
    
    public static void main( String[] args ){
    	System.out.println("Starting...");
    	SpringApplication.run(ReactorConfig.class, args);
    }
}
