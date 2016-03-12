package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class DiDFS {
    DiGraph graph;
    boolean[] marked;
    public DiDFS(DiGraph g, int s){
        graph = g;
        marked = new boolean[g.V()];
        dfs(s);
    }
    private void dfs(int v){
        marked[v] = true;
        for(int w: graph.adj(v)){
            if (!marked[w]){
                dfs(w);
            }
        }
    }
    public boolean hasPathTo(int v){ 
        return marked[v];
    }
    public static void main(String[] args) throws FileNotFoundException {
        DiGraph graph = new DiGraph(new FileInputStream("/home/jb/tmp/alg-data/tinyDG.txt"));
        DiDFS ddfs = new DiDFS(graph, 2);
        System.out.printf("reachable(2->7): %s\n", ddfs.hasPathTo(7));
    }
}
