package jb.ex.react;

import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock.ReadLock;
import java.util.concurrent.locks.ReentrantReadWriteLock.WriteLock;

import javax.annotation.Resource;

import jb.ex.config.ReactorConfig;
import jb.ex.react.vo.Sink;
import jb.ex.utils.TimeUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

import reactor.event.Event;
import reactor.function.Consumer;

@Service
@Profile("react")
public class SignalConsumer implements Consumer<Event<Integer>> {
	private static final Logger LOG = LoggerFactory.getLogger(SignalConsumer.class);
	
	@Resource(name="pLatch")
    CountDownLatch latch;
	
	@Resource(name="resetLatches")
	ConcurrentMap<String, CountDownLatch> resetLatches;
    
	@Autowired 
	Sink sink;

	ReadWriteLock lock = new ReentrantReadWriteLock();
	AtomicBoolean inReset = new AtomicBoolean(false);

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
		CountDownLatch resetLatch = getLatch("r1");

		if (!inReset.get()){
			inReset.set(true);
			new Thread(new SinkReset(sink, this)).start();  // 1  as this means 1 req pass thru this path
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
			
			TimeUtils.sleep(ReactorConfig.PROC_LATNCY); // simulate network call

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
		CountDownLatch latch  = resetLatches.get(jb.ex.utils.KeyUtils.getRLatch(id));
		LOG.debug("PURGE Latch={}", latch);
		resetLatches.remove(jb.ex.utils.KeyUtils.getRLatch(id));
		if (latch != null){
			latch.countDown();
			inReset.set(false);
		}
	}
	
	public CountDownLatch getLatch(String id){
		CountDownLatch latch = null;
		WriteLock wlock = (WriteLock) lock.writeLock();
		if (wlock.tryLock()){
			latch = new CountDownLatch(1);
			LOG.debug("GOT Latch new={}", latch);
			resetLatches.put(jb.ex.utils.KeyUtils.getRLatch(id), latch);
			wlock.unlock();
		}else{
			ReadLock rlock = (ReadLock) lock.readLock();
			rlock.lock();
			latch = resetLatches.get(jb.ex.utils.KeyUtils.getRLatch(id));
			rlock.unlock();
		}
		
		return latch;
	}
}