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
import java.util.spi.CalendarDataProvider;


public class Graph{
    private int v;
    private int e;
    private Map<Integer, List<Integer>> vmap;

    public Graph(InputStream ins) throws FileNotFoundException {
        Scanner in = new Scanner(ins);

        vmap = new HashMap<Integer, List<Integer>>();   

        v = in.nextInt();
        for(int i=0; i<v; i++){
            addV(i);
        }
        
        e = in.nextInt();
        for(int i=0; i<v; i++){
            addE(in.nextInt(), in.nextInt());
        }

    }

    public int V(){ return v; }
    
    public int E(){ return e; }
    
    public void addV(int i){
        vmap.put(i, new ArrayList<Integer>());    
    }

    public void addE(int x, int y){
        adj(x).add(y);
        adj(y).add(x);
    }

    public List<Integer> adj(int i){
        return vmap.get(i);
    }
    
    public String toString(){
    	String s="";
    	for(int i=0; i<v; i++){
    		s = s + i+ " : "+Arrays.toString(adj(i).toArray()) + "\n";
    	}
    	return s;
    }

    public static void main(String[] args) throws FileNotFoundException{
    	Graph graph = new Graph(new FileInputStream("in.txt"));
    	System.out.println(graph);
    }
}
