package jb.ex.react;

import java.util.concurrent.CountDownLatch;

import jb.ex.TimeUtils;
import jb.ex.config.AppConfig;
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
		System.out.println("count: "+count);
	}

	private void accumAndResetCount() {
		
		// first atomic-reset count
		int count = sink.setCounter(0);
		
		// excess updates past gate
		int excess = count - sink.getUpdateInterval();
				
		TimeUtils.sleep(AppConfig.PROC_LATENCY); // simulate network call
		
		// then CAS-update accum
		int accum=0;
		do{
			accum = sink.getAccum();
		}while(!sink.compareAndSetAccum(accum, accum + sink.getUpdateInterval() + excess));
		
		System.out.println("accum: "+accum);
	}
}