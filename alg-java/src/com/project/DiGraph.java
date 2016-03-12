package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Scanner;

public class DiGraph {
    int nv;
    int ne;
    Bag<Integer>[] adj;
    public DiGraph(InputStream in){
        Scanner sc = new Scanner(in);
        nv = sc.nextInt();
        adj = new Bag[nv];
        for (int i=0; i<nv; ++i) {
            adj[i] = new Bag<Integer>(nv);
        }

        ne = sc.nextInt();
        for (int i=0; i<ne; ++i) {
            int v = sc.nextInt();
            int w = sc.nextInt();
            addEdge(v, w);
        }
    }
    public void addEdge(int v, int w){
       adj[v].add(w); 
    }
    public Iterable<Integer> adj(int v) {
        return adj[v];
    }
    public int E() {
        return ne;
    }
    public int V() {
        return nv;
    }
    public String toString(){
        String s="";
        for (int i=0; i<nv; ++i) {
            s+=i+": "+adj[i]+"\n";
        }
        return s;
    }
    public static void main(String[] args) throws FileNotFoundException {
        DiGraph graph = new DiGraph(new FileInputStream("/home/jb/tmp/alg-data/tinyDG.txt"));
        System.out.printf("Digrapg: \n%s\n", graph);
    }
}
