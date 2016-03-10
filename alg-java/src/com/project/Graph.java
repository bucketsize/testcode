package com.project;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;


public class Graph {
    private int nv;
    private int ne;
    private Bag[] adj;
    public Graph(InputStream in){
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

            System.out.printf("adding %s - %s\n", v, w );
            addEdge(v, w);   
        }
    }
    public void addEdge(int v, int w){
        adj[v].add(w);
        adj[w].add(v);
    }
    public Iterable<Integer> adj(int v){
        return adj[v];
    }
    public int V(){return nv;}
    public int E(){return ne;}
    public String toString(){
        String s="";
        for(int i=0; i<nv && adj[i] != null; ++i){
            s += "["+i+"] => "+adj[i]+"\n";
        }
        return s;
    }
    public static void main(String[] args) throws FileNotFoundException {
        Graph g = new Graph(new FileInputStream("/home/jb/tmp/alg-data/tinyCG.txt"));
        System.out.printf("Graph: %s\n", g);
    }
}
