package com.project;

import java.util.Iterator;
import java.util.NoSuchElementException;

public class Queue<T> implements Iterable<T> {
    public class Node{
        Node next;
        T value;
        public Node(T value){
            this.value=value;
        }
    }
    Node head, tail;
    int N;
    public void queue(T item){
        if (tail == null) {
            tail = new Node(item);
            head = tail;  
        }else{
            tail.next = new Node(item);
            tail = tail.next;
        }
        ++N;
    }
    public T deque(){
        if (head == null){
            throw new NoSuchElementException();
        }else{
            Node node = head;
            if (head == tail){
                head = null;
                tail = null;
            }else{
                head = head.next;
            }
            --N;
            return node.value;
        }
    }
    public int size(){
        return N;
    }
    public Iterator<T> iterator(){
        return new QueueIterator();
    }
    private class QueueIterator implements Iterator<T> {
        Node cursor;
        public QueueIterator(){
            cursor = head;
        }
        public boolean hasNext(){
            return cursor != null;
        }
        public T next(){
            T item = cursor.value;
            cursor = cursor.next;   
            return item;
        }
    }

 
    public static void main(String[] args) {
        Queue<Integer> queue = new Queue<Integer>();
        queue.queue(5);
        queue.queue(2);
        queue.queue(33);
        queue.queue(12);
        queue.queue(15);

        for (int i=0; i<5; ++i) {
            System.out.printf("dequed = %s\n", queue.deque());
        }

        try {
            queue.deque();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
}

