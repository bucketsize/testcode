package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
public class Bipartite {
    Graph graph;
    boolean[] marked;
    boolean[] colour;
    boolean bip;
    public Bipartite(Graph g){
        graph = g;
        marked = new boolean[g.V()];
        colour = new boolean[g.V()];
        colour[0] = true;
        bip = true;
        dfs(0);
    }
    private void dfs(int v){
        marked[v] = true;
        for(int w: graph.adj(v)){
            if (!marked[w]){
                colour[w] = !colour[v];
                dfs(w);
            }else{
                if (colour[w] == colour[v])
                    bip = false;
            }
        }
    }
    public boolean bipartite() {
        return bip;
    }
    public static void main(String[] args) throws FileNotFoundException {
        Graph graph = new Graph(new FileInputStream("/home/jb/tmp/alg-data/tinyCG.txt"));
        Bipartite bpd = new Bipartite(graph);
        System.out.printf("Bipartite?: %s\n", bpd.bipartite());
    }
}
