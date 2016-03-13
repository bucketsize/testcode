package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class DiGCyc {
    DiGraph graph;
    boolean[] marked;
    int[] edgeTo;
    boolean[] onStack;
    Stack<Integer> cycle;
    public DiGCyc(DiGraph g){
        graph = g;
        marked = new boolean[g.V()];
        edgeTo = new int[g.V()];
        onStack = new boolean[g.V()];
        for (int i=0; i<g.V(); ++i) {
            dfs(i);
        }
    }
    private void dfs(int v){
        marked[v]=true;
        onStack[v]=true;
        for(int w: graph.adj(v)){
            if (!marked[w]) {
                edgeTo[w] = v;
                dfs(w);
            }else {
                if (onStack[w]){
                    cycle = new Stack<>(graph.V());
                    for(int i=v; i!=w; i=edgeTo[i]){
                        cycle.push(i);
                    }
                    cycle.push(w);
                    cycle.push(v);
                }
            }
        }
        onStack[v]=false;
    }
    public boolean hasCycle(){return cycle!=null;}
    public Iterable<Integer> cycle(){return cycle;}
    public static void main(String[] args) throws FileNotFoundException {
        DiGraph graph = new DiGraph(new FileInputStream("/home/jb/tmp/alg-data/tinyDG.txt"));
        DiGCyc dig = new DiGCyc(graph); 
        System.out.printf("Cycle: %s\n", dig.cycle());
    }
}
