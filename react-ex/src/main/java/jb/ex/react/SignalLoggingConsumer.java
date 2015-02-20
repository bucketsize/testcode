package jb.ex.react;

import java.util.concurrent.CountDownLatch;

import jb.ex.Constants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import reactor.event.Event;
import reactor.function.Consumer;

@Service
public class SignalLoggingConsumer implements Consumer<Event<Integer>> {

    @Autowired
    CountDownLatch latch;

    public void accept(Event<Integer> ev) {
    	try {
    		//System.out.println("c:"+i);
			Thread.sleep(Constants.PROC_LATENCY);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
        latch.countDown();
    }

}