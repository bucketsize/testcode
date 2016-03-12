package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class GCyc {
    Graph graph;
    boolean[] marked;
    boolean cyc;
    public GCyc(Graph g){
        graph = g;
        marked = new boolean[g.V()];
        dfs(0, 0);
    }
    private void dfs(int v, int parent){
        marked[v] = true;
        for(int w: graph.adj(v)){
            if (!marked[w]){
                dfs(w, v);
            }else{
                if (w != parent){   // marked v apprearing is a cycle
                                    // unless it's the immideate parent
                    cyc = true;
                }
            }
        }
    }
    public boolean cyclic(){return cyc;}
    public static void main(String[] args) throws FileNotFoundException {
        Graph graph = new Graph(new FileInputStream("/home/jb/tmp/alg-data/tinyG.txt"));
        GCyc cyd = new GCyc(graph);
        System.out.printf("cyclic?: %s\n", cyd.cyclic());
    }
}
