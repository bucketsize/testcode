package jb.ex.web.vo;

public class Greeting {
	public Greeting(long l, String message) {
		super();
		this.count = l;
		this.setMessage(message);
	}
	private long count;
	private String message;
	
	public long getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}

}
