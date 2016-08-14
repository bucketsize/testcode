import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Scanner;


class MiceMaze {

	private static class Gr{
		int N,E,T;
		int[][] adj;
		boolean[] visited;
		int[] dist;
		public Gr(int n, int e, int t){
			N=n;E=e;T=t;
			adj=new int[N][N];
			visited=new boolean[N];
			dist=new int[N];
			for (int i = 0; i < N; i++) {
				dist[i]=9999;
				visited[i]=false;
			}
		}
		public void addEdge(int u, int v, int w){
			adj[u][v]=w;
		}

	}
	private static class Q{
		int[] arr;
		int h, t;
		public Q(int sz){
			arr=new int[sz];
		}
		public void enq(int u){
			arr[t++]=u;
		}
		public int deq(){
			return arr[h++];
		}
		public int size(){
			return t-h;
		}
	}
	public static void main(String[] s) throws FileNotFoundException {
		System.setIn(new FileInputStream("input.txt"));
		Scanner sc = new Scanner(System.in);

		int N = sc.nextInt(); 

		while(N!=0){
			Gr gr=new Gr(N, sc.nextInt()-1, sc.nextInt()); //N,Exit,Time

			int M = sc.nextInt();
			for(int i=0;i<M;i++){
				gr.addEdge(sc.nextInt()-1, sc.nextInt()-1, sc.nextInt());
			}


			try{
				System.out.println(getMiceOut(gr));
			}catch(Exception e){
			}

			try{
				N = sc.nextInt();
			}catch(Exception e){
				N=0;
			}
		}
		sc.close();
	}
	private static int getMiceOut(Gr gr) {
		int m=gr.N;

		Q q = new Q(gr.N);
		q.enq(gr.E);
		gr.visited[gr.E]=true;
		gr.dist[gr.E]=0;

		while(q.size()>0){
			int u = q.deq();
			int[] va = gr.adj[u];
			for (int v = 0; v < va.length; v++) {
				if (gr.adj[u][v] > 0 && !gr.visited[v]){
					q.enq(v);
					gr.visited[v]=true;
					if (gr.dist[v] > gr.dist[u] + gr.adj[u][v] && gr.dist[u]!=9999){
						gr.dist[v] = gr.dist[u] + gr.adj[u][v];
					}
					if (gr.dist[v] > gr.T){
						--m;
					}
				}
			}
		}

		return m;
	}

	private static int getMiceOut2(Gr gr) {
		gr.dist[gr.E]=0;

		for(int i=0;i<gr.N;++i){
			int u = getNearest(gr);
			gr.visited[u]=true;
			for (int v = 0; v < gr.N; v++) {
				if (!gr.visited[v] &&
						gr.adj[u][v]!=0 && 
						gr.dist[u]!=9999 && 
						gr.dist[v] > gr.dist[u] + gr.adj[u][v]){
					gr.dist[v] = gr.dist[u] + gr.adj[u][v];
				}
			}
		}
		int m=0;
		for (int i = 0; i < gr.N; i++) {
			if (gr.dist[i] <= gr.T){
				m++;
			}
		}
		return m;
	}
	private static int getNearest(Gr gr) {
		int min=9999, mini=-1;
		for (int i = 0; i < gr.N; i++) {
			if (!gr.visited[i] && gr.dist[i] < min){
				min = gr.dist[i];
				mini = i;
			}
		}
		return mini;
	}
}
