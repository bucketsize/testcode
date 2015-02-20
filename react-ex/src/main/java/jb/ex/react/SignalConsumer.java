package jb.ex.react;

import java.util.concurrent.CountDownLatch;

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
   		
   		processMessage();
   		
        latch.countDown();
    }

	private void processMessage() {
		try {
			Thread.sleep(AppConfig.PROC_LATENCY);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		synchronized (sink) {
			if (sink.getCounter() < sink.getUpdateInterval()){
				sink.setCounter(sink.getCounter() + 1);

			}else{

				sink.setSink(sink.getSink() + sink.getCounter());
				sink.setCounter(0);
			}
		}
	}

}