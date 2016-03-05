import java.security.SecureRandom;
import java.util.Random;
import java.util.function.Function;

public class Util{
  //static long _RANDOM_SEED_ = 112358111932L;
  static Random rng = new Random(); // weak && fast
  //static SecureRandom rng = new SecureRandom(); // strong && slow
  public static int random(int ul){
    return rng.nextInt(ul);
  }
  public static int random(int l, int u){
    if (u < l) throw new IllegalArgumentException("not first < second");
    else
      if (u == l) return l;
      else
        return (l + random(u-l));
  }
  public static Integer[] randoms(int n){
    Random rand = new Random();
    Integer[] a = new Integer[n];
    for(int i=0; i<n; ++i)
      a[i] = rand.nextInt();
    return a;
  }
  public static <T extends Comparable> void swap(T[] array, int i, int j){
    T t = array[i];
    array[i]=array[j];
    array[j]=t;
  }

  public static <T extends Comparable> boolean isSorted(T[] array){
    for(int i=1; i<array.length-1; ++i){
      if (array[i].compareTo(array[i-1]) < 0){
        return false;
      }
    }
    return true;
  }

  public static <V> void time(Function<String, V> fn){
    long t1 = System.currentTimeMillis();
    fn.apply("");
    long t2 = System.currentTimeMillis();
    System.out.printf("time = %s ms\n", (t2-t1));
  }
}
