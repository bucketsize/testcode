package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

public class DiGTopoSort {
    DiGraph graph;
    boolean marked[];

    Queue<Integer> pre;
    Queue<Integer> post;
    Stack<Integer> rpost;

    public DiGTopoSort(DiGraph g){
        graph = g;
        marked = new boolean[graph.V()];
        
        pre = new Queue<>();
        post = new Queue<>();
        rpost = new Stack<>(graph.V());
        
        dfs(0);
    }
    private void dfs(int v){
        marked[v] =  true;
        pre.enque(v);
        for(int w: graph.adj(v)){
            if (!marked[w]){
                dfs(w);
            }
        }
        post.enque(v);
        rpost.push(v);
    }
    public Iterable<Integer> pre(){return pre;}
    public Iterable<Integer> post(){return post;}
    public Iterable<Integer> rpost(){return rpost;}
    public static void main(String[] args) throws FileNotFoundException {
        DiGraph graph = new DiGraph(new FileInputStream("/home/jb/tmp/alg-data/tinyDG.txt"));
        DiGTopoSort dgts = new DiGTopoSort(graph);

        System.out.printf("pre: %s\n", dgts.pre());
        System.out.printf("post: %s\n", dgts.post());
        System.out.printf("rpost: %s\n", dgts.rpost());
    }
}
