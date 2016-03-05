import java.util.Arrays;

public class QuickSort {
  public static <T extends Comparable> void sort(T[] array){
    //System.out.println(Arrays.toString(array));
    sort(array, 0, array.length-1);
  }
  public static <T extends Comparable> void sort(T[] array, int l, int h){
    if (l >= h) return;
    int p = partition(array, l, h);
    sort(array, l, p);
    sort(array, p+1, h);
  }
  private static <T extends Comparable> int partition(T[] array, int l, int h){
    int pi = Util.random(l, h);
    T p = array[pi];
    //System.out.println(""+pi+", "+p.toString());
    int i=l-1;
    int j=h+1;
    while(true){
      while(p.compareTo(array[++i]) > 0){
        if (i == h) break;
      }
      while(p.compareTo(array[--j]) < 0){
        if (j == l) break;
      }
      Util.swap(array, i, j);
      if (i >= j) break;
    }
    Util.swap(array, i, j);
    //System.out.println(Arrays.toString(array));
    
    return j;
  }

  public static void main(String[] argv){
    //Integer[] arr1 = {4,18,2,41,1,8,5,15,77,23,56,92,21};
    Integer[] arr1 = Util.randoms(1000000);
    
    Util.time(x -> {
      QuickSort.sort(arr1); 
      return null;
    });

    System.out.printf("sorted = %s\n", Util.isSorted(arr1));
  }
}


