package jb.ex.vo;

import java.io.Serializable;
import java.util.concurrent.atomic.AtomicInteger;

public class Sink implements Serializable {
	@Override
	public String toString() {
		return String.format("Sink [updateInterval=%s, sink=%s, counter=%s]",
				updateInterval, sink, counter);
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = -7953574758777827393L;
	public Sink(int i) {
		updateInterval=i;
		counter=new AtomicInteger();
		sink=new AtomicInteger();
	}
	public int getSink() {
		return sink.get();
	}
	public boolean compareAndSetSink(int expect, int update) {
		return this.sink.compareAndSet(expect, update);
	}
	public int getCounter() {
		return counter.get();
	}
	public void compareAndSetCounter(int expect, int update) {
		this.counter.compareAndSet(expect, update);
	}
	public int getUpdateInterval() {
		return updateInterval;
	}
	
	private int updateInterval = 10;
    private AtomicInteger sink;
    private AtomicInteger counter;
}
