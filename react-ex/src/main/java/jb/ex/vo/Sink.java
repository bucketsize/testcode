package jb.ex.vo;

import java.io.Serializable;

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
	}
	public int getSink() {
		return sink;
	}
	public void setSink(int sink) {
		this.sink = sink;
	}
	public int getCounter() {
		return counter;
	}
	public void setCounter(int counter) {
		this.counter = counter;
	}
	public int getUpdateInterval() {
		return updateInterval;
	}
	
	private int updateInterval = 10;
    private int sink = 0;
    private int counter = 0;
}
