package jb.ex.react;

import java.util.concurrent.CountDownLatch;

import jb.ex.TimeUtils;
import jb.ex.vo.Sink;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import reactor.event.Event;
import reactor.function.Consumer;

@Service
public class SignalConsumer implements Consumer<Event<Integer>> {

	@Autowired
    CountDownLatch latch;
    
	@Autowired 
	Sink sink;

    public void accept(Event<Integer> ev) {
   		processEvent();
        latch.countDown();
    }

	private void processEvent() {
		int count=0;
		do{
			count=sink.getCounter();
			if (count >= sink.getUpdateInterval()){
				accumAndResetCount();
				return;
			}
		}while(!sink.compareAndSetCounter(count, count + 1));
		System.out.println("counter: "+count);
	}

	private void accumAndResetCount() {
		TimeUtils.sleep(100); // simulate network call
		
		// using CAS for sync
		
		// first update count
		int count=0;
		
		do{
			count = sink.getCounter();
		}while(!sink.compareAndSetCounter(count, 0));
		
		// then update accum
		int accum=0;
		do{
			accum = sink.getAccum();
		}while(!sink.compareAndSetAccum(accum, accum + count));
		
		System.out.println("accum: "+accum);
	}
}