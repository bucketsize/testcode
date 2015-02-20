package jb.ex.react;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;

import jb.ex.Constants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import reactor.core.Reactor;
import reactor.event.Event;

@Service
public class SignalProducer {

    @Autowired
    Reactor reactor;

    @Autowired
    CountDownLatch latch;

    public void produceSignals(int number) throws InterruptedException {
        long start = System.currentTimeMillis();

        AtomicInteger counter = new AtomicInteger(1);

        System.out.println("firing requests n="+number);
        for (int i=0; i < number; i++) {
            reactor.notify(Constants.EventHandle.PROC_EVENT, Event.wrap(counter.getAndIncrement()));
        }
        {
        	long elapsed0 = System.currentTimeMillis()-start;
        	System.out.println("dispatch time: " + elapsed0 + "ms");
        	System.out.println("dispatch Throughput: "+number / (elapsed0 / 1000.0f));
        }
        
        latch.await();
        {
        	long elapsed1 = System.currentTimeMillis()-start;
        	System.out.println("proc time: " + elapsed1 + "ms");
        	System.out.println("proc Throughput: "+number / (elapsed1 / 1000.0f));
        }
    }

    public void sendMessages(int number) throws InterruptedException {
        long start = System.currentTimeMillis();

        AtomicInteger counter = new AtomicInteger(1);

        System.out.println("firing requests n="+number);
        for (int i=0; i < number; i++) {
            reactor.notify(Constants.EventHandle.PROC_EVENT, Event.wrap(counter.getAndIncrement()));
        }
        {
        	long elapsed0 = System.currentTimeMillis()-start;
        	System.out.println("dispatch time: " + elapsed0 + "ms");
        	System.out.println("dispatch Throughput: "+number / (elapsed0 / 1000.0f));
        }
        
        latch.await();
        {
        	long elapsed1 = System.currentTimeMillis()-start;
        	System.out.println("proc time: " + elapsed1 + "ms");
        	System.out.println("proc Throughput: "+number / (elapsed1 / 1000.0f));
        }
    }
}