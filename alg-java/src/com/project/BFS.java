package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class BFS {
    private Graph graph;
    private int origin;
    private boolean[] marked;
    private int[] edgeTo;
    public BFS(Graph g, int o){
        graph = g;
        origin = o;
        marked = new boolean[graph.V()];
        edgeTo = new int[graph.V()];
        search(g, o);
    }
    private void search(Graph g, int o){
        Queue<Integer> q = new Queue<>();
        marked[o] = true;
        q.enque(o);
        while(!q.empty()){
            int v = q.deque();
            for(int w: g.adj(v)){
                if (!marked[w]){
                    marked[w] = true;
                    edgeTo[w] = v;
                    q.enque(w);
                }
            }
        }
    }
    public boolean hasPathTo(int v){
        return marked[v];
    }
    public Iterable<Integer> pathTo(int v){
        Stack<Integer> st = new Stack<>(graph.V());
        for (int x=v; x!=origin; x=edgeTo[x])
            st.push(x);
        st.push(origin);
        return st;
    }
    public static void main(String[] args) throws FileNotFoundException {
        Graph graph = new Graph(new FileInputStream("/home/jb/tmp/alg-data/tinyCG.txt"));
        BFS bfs = new BFS(graph, 0);
        System.out.printf("0-pathTo[3]: %s", bfs.pathTo(3));
    }
}
