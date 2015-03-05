package jb.ex.react;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;

import jb.ex.TimeUtils;
import jb.ex.config.AppConfig;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import reactor.core.Reactor;
import reactor.event.Event;

@Service
public class SignalProducer {
	private static final Logger LOG = LoggerFactory.getLogger(SignalProducer.class);
	
    @Autowired
    Reactor reactor;

    @Resource(name="pLatch")
    CountDownLatch latch;

    public void produceSignals(int number) throws InterruptedException {
        long start = System.currentTimeMillis();

        AtomicInteger counter = new AtomicInteger(1);

        System.out.println("firing requests n="+number);
        for (int i=0; i < number; i++) {
            reactor.notify(AppConfig.PROC_EVENT, Event.wrap(counter.getAndIncrement()));
        }
        {
        	long elapsed0 = System.currentTimeMillis()-start;
        	LOG.debug("dispatch time={} ms", elapsed0);
        	LOG.debug("dispatch Throughput={}", number / (elapsed0 / 1000.0f));
        }
        
        latch.await();
        TimeUtils.outTP(number, start);
    }

    public void sendEvents(int number) throws InterruptedException {
        long start = System.currentTimeMillis();

        AtomicInteger counter = new AtomicInteger(1);

        LOG.debug("firing requests n={}", number);
        for (int i=0; i < number; i++) {
            reactor.notify(AppConfig.PROC_EVENT, Event.wrap(counter.getAndIncrement()));
        }
        TimeUtils.outTP(number, start);

        
        latch.await();
        TimeUtils.outTP(number, start);

    }
}