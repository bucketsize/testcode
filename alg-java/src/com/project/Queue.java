package com.project;

import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Spliterator;
import java.util.function.Consumer;

public class Queue<T> implements Iterable<T> {
    private class Node{
        Node next;
        T value;
        public Node(T value){
            this.value=value;
        }
    }
    private Node head, tail;
    private int N;
    public void enque(T item){
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
    public boolean empty(){
        return N==0;
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
		@Override
		public void remove() {
			// TODO Auto-generated method stub
			
		}
		@Override
		public void forEachRemaining(Consumer<? super T> action) {
			// TODO Auto-generated method stub
			
		}
    }
    public String toString() {
        StringBuilder sb =  new StringBuilder();
        sb
            .append("[");
        for (T v: this) {
            sb
                .append(v)
                .append(" ");
        }
        sb
            .append("]");

        return sb.toString();
    }
 
    public static void main(String[] args) {
        Queue<Integer> queue = new Queue<Integer>();
        queue.enque(5);
        queue.enque(2);
        queue.enque(33);
        queue.enque(12);
        queue.enque(15);

        System.out.printf("toString: %s\n", queue);
        for (int i=0; i<5; ++i) {
            System.out.printf("dequed = %s\n", queue.deque());
        }

        try {
            queue.deque();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
	@Override
	public void forEach(Consumer<? super T> action) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public Spliterator<T> spliterator() {
		// TODO Auto-generated method stub
		return null;
	}
}

