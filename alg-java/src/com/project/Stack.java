package com.project;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class Stack<T> implements Iterable<T> {
    private T[] A;
    private int N;
    public Stack(int t){
        A = (T[]) new Object[t];
    }
    public void push(T item){
        if (N > A.length-1)
            throw new IndexOutOfBoundsException();
        A[N++] = item;
    }
    public T pop(){
        if (N<1)
            throw new NoSuchElementException();
        return A[--N];
    }
    public int size(){
        return N;
    }
    public Iterator<T> iterator(){
        return new StackIterator();
    }
    private class StackIterator implements Iterator<T>{
        private int cursor;
        public boolean hasNext(){
            if (cursor > Stack.this.N-1)
                return false;
            return true;
        }
        public T next(){
            return Stack.this.A[cursor++];
        }
    }
    public static void main(String[] args){
        Stack<Integer> bag = new Stack<Integer>(5);
        bag.push(22);
        bag.push(3);
        bag.push(9);
        bag.push(13);
        bag.push(100);

        for(Integer i: bag){
            System.out.printf("item = %s\n", i);
        }

        try{ 
            bag.push(10);     
        }catch(Exception ex){
            System.out.printf("exception: %s\n", ex.getMessage());
        }

        for (int i=0; i<5; ++i) {
            System.out.printf("item = %s\n", bag.pop());
        }
        
        try{ 
            bag.pop();     
        }catch(Exception ex){
            System.out.printf("exception: %s\n", ex.getMessage());
        }


    }
}
