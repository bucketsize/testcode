package jb.ex;


public class TimeUtils {

	public static void sleep(long millis){
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	
	public static void outTP(int number, long startMillis){
    	long elapsed = System.currentTimeMillis()-startMillis;
    	System.out.println("run Time: " + elapsed + "ms");
    	System.out.println("run Throughput: "+number / (elapsed / 1000.0f));
    }
}
