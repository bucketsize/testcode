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
				sink = accumAndResetCount();
				count = sink.getCounter();
				return;
			}
		}while(!sink.compareAndSetCounter(count, count + 1));
//		System.out.println("c1 count: "+count);
	}

	private Sink accumAndResetCount() {
		
		TimeUtils.sleep(AppConfig.PROC_LATNCY); // simulate network call
		
		// first atomic-reset count
		new SinkReset(sink).run();  // 1  as this means 1 req pass thru this path
//		System.out.println("c2 count: "+count);
		
		return sink;
//		System.out.println("c1 accum: "+(accum+count));
	}
	
	private static class SinkReset implements Runnable {
		
		Sink sink;
		
		public SinkReset(Sink sink){
			this.sink = sink;
		}
		
		public void run() {
			int count = sink.setCounter(1);
			
			// then CAS-update accum
			int accum=0;
			do{
				accum = sink.getAccum();
			}while(!sink.compareAndSetAccum(accum, accum + count));
		}
	}
}