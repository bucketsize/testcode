package jb.ex.react.vo;

import java.io.Serializable;
import java.util.concurrent.atomic.AtomicInteger;

public class Sink implements Serializable {
	@Override
	public String toString() {
		return String.format("Sink [updateInterval=%s, sink=%s, counter=%s]",
				updateInterval, accum, counter);
	}

	/**
	 * 
	 */
	private static final long serialVersionUID = -7953574758777827393L;
	public Sink(int i) {
		updateInterval=i;
		counter=new AtomicInteger();
		accum=new AtomicInteger();
	}
	public int getAccum() {
		return accum.get();
		
	}
	
	public int setAccum(int update) {
		return accum.getAndSet(update);
		
	}
	
	public boolean compareAndSetAccum(int expect, int update) {
		return this.accum.compareAndSet(expect, update);
	}
	public int getCounter() {
		return counter.get();
	}
	public int setCounter(int update) {
		return counter.getAndSet(update);
		
	}
	public boolean compareAndSetCounter(int expect, int update) {
		return this.counter.compareAndSet(expect, update);
	}
	public int getUpdateInterval() {
		return updateInterval;
	}
	
	private int updateInterval = 10;
    private AtomicInteger accum;
    private AtomicInteger counter;
}
