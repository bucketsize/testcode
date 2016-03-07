package com.project;

import java.util.Iterator;

public class Bag<T> implements Iterable<T> {
    private T[] A;
    private int N;
    public Bag(int t){
        A = (T[]) new Object[t];
    }
    public void add(T item){
        if (N > A.length-1)
            throw new IndexOutOfBoundsException();
        A[N++] = item;
    }
    public int size(){
        return N;
    }
    public Iterator<T> iterator(){
        return new BagIterator();
    }
    private class BagIterator implements Iterator<T>{
        private int cursor;
        public boolean hasNext(){
            if (cursor > Bag.this.N-1)
                return false;
            return true;
        }
        public T next(){
            return Bag.this.A[cursor++];
        }
    }
    public static void main(String[] args){
        Bag<Integer> bag = new Bag<Integer>(10);
        bag.add(22);
        bag.add(3);
        bag.add(9);
        bag.add(13);
        bag.add(100);

        for(Integer i: bag){
            System.out.printf("item = %s\n", i);
        }
    }
}
