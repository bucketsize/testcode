package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DepthFirstSearch {
    private Graph graph;
    private int origin;
    private boolean[] marked;
    private int[] edgeTo;
    public DepthFirstSearch(Graph g, int o){
        graph = g;
        origin = origin;   
        marked = new boolean[g.V()];
        edgeTo = new int[g.V()];
        search(g, origin);
    }
    private void search(Graph g, int r){
        marked[r] = true;
        for(int v: g.adj(r)){
            if (!marked[v]){
                edgeTo[v] = r;
                search(g, v);
            }
        }
    }
    public boolean hasPathTo(int v){
        return marked[v];    
    }
    public Iterable<Integer> pathTo(int v){
        Stack<Integer> st = new Stack<Integer>(graph.V());
        for(int i=v; i!=origin; i=edgeTo[i])
            st.push(i);
        st.push(origin);
        return st;
    }
    public static void main(String[] args) throws FileNotFoundException {
        Graph g = new Graph(new FileInputStream("/home/jb/tmp/alg-data/tinyCG.txt"));
        DepthFirstSearch dfs = new DepthFirstSearch(g, 0);
        System.out.printf("pathTo(3): %s\n", dfs.pathTo(3));
    }
}
