package jb.ex.react;

import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CountDownLatch;

import javax.annotation.Resource;

import jb.ex.TimeUtils;
import jb.ex.config.AppConfig;
import jb.ex.vo.Sink;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import reactor.event.Event;
import reactor.function.Consumer;

@Service
public class SignalConsumer implements Consumer<Event<Integer>> {
	private static final Logger LOG = LoggerFactory.getLogger(SignalConsumer.class);
	
	@Resource(name="pLatch")
    CountDownLatch latch;
	
	@Resource(name="resetLatches")
	ConcurrentMap<String, CountDownLatch> resetLatches;
    
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
			while (count >= sink.getUpdateInterval()){
				sink = accumAndResetCount();
				count = sink.getCounter();
			}
		}while(!sink.compareAndSetCounter(count, count + 1));
//		LOG.debug("c1 count={}", count+1);
	}

	private Sink accumAndResetCount() {
		
		CountDownLatch resetLatch=null;
		synchronized(sink){
			resetLatch = getLatch("r1");
		
			// first atomic-reset count
			if (resetLatch.getCount() > 1){
				new Thread(new SinkReset(sink, this)).start();  // 1  as this means 1 req pass thru this path
				resetLatch.countDown();
			}    
		}
		
		try {
			resetLatch.await();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		
		return sink;
	}
	
	private static class SinkReset implements Runnable {
		
		Sink sink;
		SignalConsumer cs;
		
		public SinkReset(Sink sink, SignalConsumer cs){
			this.sink = sink;
			this.cs = cs;
		}
		
		public void run() {
			
			TimeUtils.sleep(AppConfig.PROC_LATNCY); // simulate network call

			int count = sink.setCounter(1);
			LOG.debug("reset count to 1 ... excess={} sum={}", count, sink.getAccum());
			
			// then CAS-update accum
			int accum=0;
			do{
				accum = sink.getAccum();
			}while(!sink.compareAndSetAccum(accum, accum + count));
			
			cs.purgeLatch("r1");
		}
	}
	
	public void purgeLatch(String id){
		CountDownLatch latch  = resetLatches.get(jb.ex.KeyUtils.getRLatch(id));
		LOG.debug("PURGE Latch={}", latch);
		resetLatches.remove(jb.ex.KeyUtils.getRLatch(id));
		if (latch != null){
			latch.countDown();
		}
	}
	public CountDownLatch getLatch(String id){
		CountDownLatch latch = resetLatches.get(jb.ex.KeyUtils.getRLatch(id));

		if (latch == null){
			latch = new CountDownLatch(2);
			LOG.debug("GOT Latch new={}", latch);
			resetLatches.put(jb.ex.KeyUtils.getRLatch(id), latch);
		}
		return latch;
	}
}