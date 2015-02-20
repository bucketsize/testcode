package jb.ex.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.task.AsyncTaskExecutor;

import reactor.core.Environment;
import reactor.spring.core.task.RingBufferAsyncTaskExecutor;
import reactor.spring.core.task.WorkQueueAsyncTaskExecutor;

import com.lmax.disruptor.YieldingWaitStrategy;
import com.lmax.disruptor.dsl.ProducerType;

@Configuration
public class AsyncExecutorConfig {

	@Bean
	public AsyncTaskExecutor singleThreadAsyncTaskExecutor(Environment env) {
    	System.out.println("configuring singleThreadAsyncTaskExecutor");
    	RingBufferAsyncTaskExecutor tasx = new RingBufferAsyncTaskExecutor(env);
    	tasx.setName("ringBufferExecutor");
    	tasx.setBacklog(2048);
        tasx.setProducerType(ProducerType.SINGLE);
        tasx.setWaitStrategy(new YieldingWaitStrategy());
        return tasx;
    }
	
	@Bean
	public AsyncTaskExecutor workQueueAsyncTaskExecutor(Environment env) {
    	System.out.println("configuring workQueueAsyncTaskExecutor");
    	WorkQueueAsyncTaskExecutor tasx = new WorkQueueAsyncTaskExecutor(env);
    	tasx.setName("workQueueExecutor");
    	tasx.setBacklog(2048);
        tasx.setThreads(2);
        tasx.setProducerType(ProducerType.SINGLE);
        tasx.setWaitStrategy(new YieldingWaitStrategy());
        return tasx;
    }

}
