package jb.ex.config;

import static reactor.event.selector.Selectors.$;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import jb.ex.react.SignalConsumer;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import reactor.core.Environment;
import reactor.core.Reactor;
import reactor.core.spec.Reactors;
import reactor.event.dispatch.ThreadPoolExecutorDispatcher;
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

    
//	@Bean
//	public AsyncTaskExecutor singleThreadAsyncTaskExecutor(Environment env) {
//    	System.out.println("configuring singleThreadAsyncTaskExecutor");
//    	RingBufferAsyncTaskExecutor tasx = new RingBufferAsyncTaskExecutor(env);
//    	tasx.setName("ringBufferExecutor");
//    	tasx.setBacklog(2048);
//        tasx.setProducerType(ProducerType.SINGLE);
//        tasx.setWaitStrategy(new YieldingWaitStrategy());
//        return tasx;
//    }
//	
//	@Bean
//	public AsyncTaskExecutor workQueueAsyncTaskExecutor(Environment env) {
//    	System.out.println("configuring workQueueAsyncTaskExecutor");
//    	WorkQueueAsyncTaskExecutor tasx = new WorkQueueAsyncTaskExecutor(env);
//    	tasx.setName("workQueueExecutor");
//    	tasx.setBacklog(2048);
//        tasx.setThreads(8);
//        tasx.setProducerType(ProducerType.SINGLE);
//        tasx.setWaitStrategy(new YieldingWaitStrategy());
//        return tasx;
//    }
	
	
//	@Bean
//	public WorkQueueDispatcher workQueueDispatcher(){
//		return new WorkQueueDispatcher("workQueueDispatcher", 8, 2048, null);
//	}
	
//	@Bean
//	ThreadPoolTaskExecutor threadPoolTaskExecutor(){
//		ThreadPoolTaskExecutor tpx = new ThreadPoolTaskExecutor();
//		tpx.setMaxPoolSize(8);
//		tpx.setQueueCapacity(2048);
//		
//		return tpx;
//	}
	
	
	@Bean
	public ThreadPoolExecutorDispatcher threadPoolExecutorDispatcher(){
		ExecutorService executorService = Executors.newFixedThreadPool(16);
		ThreadPoolExecutorDispatcher tpd = new ThreadPoolExecutorDispatcher(8, 10000, executorService);
		return tpd;
	}
	
    @Bean
    Reactor createReactor(Environment env) {
    	Reactor reactor = Reactors.reactor()
                .env(env)
                .dispatcher(threadPoolExecutorDispatcher())
                .get();
        
    	    	
        configureReactor(reactor);
        
        return reactor;
    }

	private void configureReactor(Reactor reactor) {
		reactor.on($(AppConfig.PROC_EVENT), receiver);
	}

}
