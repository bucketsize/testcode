package jb.ex.react;

import jb.ex.config.ReactorConfig;
import jb.ex.react.vo.Sink;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Profile;

import reactor.core.Reactor;

@Configuration
@Import(value={ReactorConfig.class})
@Profile("react")
public class ReactDemo {
	private static final Logger LOG = LoggerFactory.getLogger(ReactDemo.class);
	
    @Autowired
    private Reactor reactor;

    @Autowired
    private SignalProducer publisher;
    
    @Autowired
    private Sink sink;

    public void run(String... args) throws Exception {
    	//publisher.produceSignals(Constants.NUM_SIGNALS);
    	publisher.sendEvents(ReactorConfig.NUM_SIGNALS);
    	LOG.info("finally={}", sink);
    }
    
    public static void main( String[] args ) throws Exception{
    	LOG.info("starting ReactDemo ...");
    	AnnotationConfigApplicationContext ctx = new AnnotationConfigApplicationContext();
		ctx.register(ReactDemo.class);
		try{
			ctx.refresh();
		}catch(Exception e){
			ctx.close();
		}
		
		new ReactDemo().run(args);
    }
}
