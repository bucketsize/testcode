package com.project;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Stack;

public class BFS {
	private int s;
	private Map<Integer, Boolean> marked;
	private Map<Integer, Integer> edgeTo;
	private int count;
	public BFS(Graph g, int s){
		marked = new HashMap<Integer, Boolean>();
		edgeTo = new HashMap<Integer, Integer>();
		this.s = s;
		bfs(g, s);
	}
	
	public int getCount(){ return count; }
	
	private void bfs(Graph g, int s){
		Queue<Integer> q = new LinkedList<Integer>();
		count++;
		marked.put(s, true);
		q.add(s);
		while(q.size()>0){
			int v = q.remove();
			for(int x: g.adj(v)){
				if (!isMarked(x)){
					count++;
					marked.put(v, true);
					q.add(x);
				}
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
