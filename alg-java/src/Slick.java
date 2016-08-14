import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;

class Slick {
	private static class Matrix{
		public int r, c;
		public int[][] arr;
		public boolean[][] visited;
		public int[] res;
		public int slicks;
		public Matrix(int i, int j){
			r=i;c=j;
			arr=new int[r][c];
			visited=new boolean[r][c];
			res=new int[r*c];
		}
		public String toString(){
			String s="";
			for(int r=0;r<this.r;++r){
				for(int c=0;c<this.c;++c){
					s+=arr[r][c]+" ";
				}
				s+="\n";
			}
			return s;
		}
	}
	private static class E{
		public int[] i = new int[2];

	}
	private static class Q{
		private E[] arr;
		private int h,t;
		public Q(int sz){
			arr = new E[sz];
		}
		public void enq(int i, int j){
			if (t>=arr.length)
				throw new RuntimeException("queue full");
			arr[t]=new E();
			arr[t].i[0]=i;
			arr[t].i[1]=j;
			++t;
		}
		public int[] deq(){
			E e = arr[h];
			if (h<t)
				++h;
			return e.i;
		}
		public int size(){
			return t-h;
		}
	}

	public static void main(String[] argv) throws FileNotFoundException{
		System.setIn(new FileInputStream("input.txt"));
		Scanner sc = new Scanner(System.in);

		int i, j;
		i = sc.nextInt(); j = sc.nextInt();

		while(i!=0 && j!=0){
			Matrix m = new Matrix(i, j);
			for(int r=0;r<i;++r){
				for(int c=0;c<j;++c){
					//System.out.println(""+r+", "+c);
					m.arr[r][c] = sc.nextInt();
				}
			}
			//System.out.println(m);
			countSlicks(m);
			System.out.println(m.slicks);
			int[][] slicks = new int[m.slicks][2];
			int slc=0;
			for(int si=0;si<m.res.length;++si){
				if (m.res[si]!=0){
					//System.out.println(m.res[si]);
					boolean f=false;
					for(int sj=0;sj<m.slicks;++sj){
						if (slicks[sj][0] == m.res[si]){
							slicks[sj][1]++;
							f=true;
						}
					}
					if (!f){
						slicks[slc][0]=m.res[si];
						slicks[slc++][1]++;
					}
				}
			}
			for(int l=0;l<slc;++l){
				for(int k=l;k<slc;++k){
					if (slicks[l][0] > slicks[k][0]){
						swap(slicks, l, k);
					}
				}
			}
			for(int sj=0;sj<slc;++sj){
				System.out.println(""+slicks[sj][0]+" "+slicks[sj][1]);
			}
			i = sc.nextInt(); j = sc.nextInt();
		}
	}

	private static void swap(int[][] slicks, int l, int k) {
		int i0 = slicks[l][0];
		int i1 = slicks[l][1];
		slicks[l][0] = slicks[k][0];
		slicks[l][1] = slicks[k][1];
		slicks[k][0] = i0;
		slicks[k][1] = i1;
	}

	private static void countSlicks(Matrix m) {
		int nss=0;
		int sz=0;
		for(int r=0;r<m.r;++r){
			for(int c=0;c<m.c;++c){
				if (!m.visited[r][c] && m.arr[r][c]!=0){
					//System.out.println("s: "+r+", "+c);
					Q queu = new Q(m.r * m.c);
					m.res[nss] = 0;
					queu.enq(r, c);
					m.visited[r][c]=true;
					while(queu.size() > 0){
						++m.res[nss];
						int[] e = queu.deq();
						enqAdj(e, m, queu);
					}
					++nss;
				}
			}
		}
		m.slicks = nss;
	}

	private static void enqAdj(int[] e, Matrix m, Q q) {
		int rx, cx;
		rx = e[0]-1; cx = e[1];
		if (isBounded(rx, cx, m) && !m.visited[rx][cx]){
			q.enq(rx, cx);
			m.visited[rx][cx]=true;
		}
		rx = e[0]; cx = e[1]-1;
		if (isBounded(rx, cx, m) && !m.visited[rx][cx]){
			q.enq(rx, cx);
			m.visited[rx][cx]=true;
		}
		rx = e[0]+1; cx = e[1];
		if (isBounded(rx, cx, m) && !m.visited[rx][cx]){
			q.enq(rx, cx);
			m.visited[rx][cx]=true;
		}
		rx = e[0]; cx = e[1]+1;
		if (isBounded(rx, cx, m) && !m.visited[rx][cx]){
			q.enq(rx, cx);
			m.visited[rx][cx]=true;
		}
	}

	private static boolean isBounded(int rx, int cx, Matrix m) {
		return (rx >= 0 && rx < m.r) && (cx >= 0 && cx < m.c) && (m.arr[rx][cx] == 1);
	}
}
