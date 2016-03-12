package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class GCons {
    Graph graph;
    boolean[] marked;
    int[] id;
    int count;
    public GCons(Graph g){
        graph = g;
        marked = new boolean[g.V()];
        id = new int[g.V()];
        for (int v=0; v<g.V(); ++v) {
            if (!marked[v]){
                dfs(v);
                count++;
            }
        }
    }
    private void dfs(int v){
        marked[v] = true;
        id[v] = count;
        for(int w: graph.adj(v)){
            if (!marked[w]){
                dfs(w);
            }
        }
    }
    public int count() {
        return count;
    }
    public int id(int v) {
        return id[v];
    }
    public static void main(String[] args) throws FileNotFoundException {
        Graph graph = new Graph(new FileInputStream("/home/jb/tmp/alg-data/tinyG.txt"));
        GCons cond = new GCons(graph);
        System.out.printf("no. of components: %s\n", cond.count());

        Bag<Integer>[] C = new Bag[graph.V()];
        for (int i=0; i<cond.count(); i++) {
            C[i] = new Bag<Integer>(graph.V());
            for (int j=0; j<graph.V(); j++) {
                if (cond.id(j) == i)
                    C[i].add(j);
            }
            System.out.printf("%s: %s\n", i, C[i]);
        }
    }
} 
