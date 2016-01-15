package com.project;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;

public class DFS {
	private int s;
	private Map<Integer, Boolean> marked;
	private Map<Integer, Integer> edgeTo;
	private int count;
	public DFS(Graph g, int s){
		marked = new HashMap<Integer, Boolean>();
		edgeTo = new HashMap<Integer, Integer>();
		this.s = s;
		dfs(g, s);
	}
	
	public int getCount(){ return count; }
	
	private void dfs(Graph g, int s){
		count++;
		marked.put(s, true);
		for(int v: g.adj(s)){
			if (!isMarked(v)){
				edgeTo.put(v, s); // back-tracker
				dfs(g, v);
			}
		}
	}

	private boolean isMarked(int v) {
		return marked.get(v);
	}
	
	public boolean hasPathTo(int v){
		return isMarked(v);
	}
	
	public List<Integer> pathTo(int v){
		if (!hasPathTo(v)) {return null;}
		Stack<Integer> path = new Stack<Integer>();
		for(int i=v; i!=this.s; i=edgeTo.get(i)){
			path.push(i);
		}
		path.push(s);
		
		return path;
	}
	
}
