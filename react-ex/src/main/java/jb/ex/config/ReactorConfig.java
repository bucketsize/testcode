package jb.ex.config;

import static reactor.event.selector.Selectors.$;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import jb.ex.react.SignalConsumer;
import jb.ex.react.vo.Sink;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.Profile;

import reactor.core.Environment;
import reactor.core.Reactor;
import reactor.core.spec.Reactors;
import reactor.event.dispatch.ThreadPoolExecutorDispatcher;
import reactor.spring.context.config.EnableReactor;

@Configuration
@EnableReactor
@Profile("react")
@Import({BootConfig.class})
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
		ExecutorService executorService = Executors.newFixedThreadPool(NE_THREADS);
		ThreadPoolExecutorDispatcher tpd = new ThreadPoolExecutorDispatcher(ND_THREADS, 10000, executorService);
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
		reactor.on($(PROC_EVENT), receiver);
	}
	
	//
	public static final int NUM_SIGNALS = 1000;
	public static final int UPD_INTERVL = 100;
	public static final int PROC_LATNCY = 100;
	
	public static final int NE_THREADS = 10;
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
    //

}
