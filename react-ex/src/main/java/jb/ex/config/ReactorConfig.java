package jb.ex.config;

import static reactor.event.selector.Selectors.$;
import jb.ex.Constants;
import jb.ex.react.SignalConsumer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import reactor.core.Environment;
import reactor.core.Reactor;
import reactor.core.spec.Reactors;
import reactor.event.dispatch.Dispatcher;
import reactor.spring.context.config.EnableReactor;

@Configuration
@EnableReactor
@EnableAutoConfiguration
@ComponentScan(basePackages={"jb.ex"})
public class ReactorConfig {

	@Autowired
    private SignalConsumer receiver;

	
    @Bean
    Environment env() {
        return new Environment();
    }

    @Bean
    Reactor createReactor(Environment env) {
    	Reactor reactor = Reactors.reactor()
                .env(env)
                .dispatcher(Environment.RING_BUFFER)
                .get();
        
        
    	
        configureReactor(reactor);
        
        return reactor;
    }

	private void configureReactor(Reactor reactor) {
		reactor.on($(Constants.EventHandle.PROC_EVENT), receiver);
	}

}
