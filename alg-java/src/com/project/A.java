package com.project;

public class A{
    public static void main(String[] args) {
        Bag<Integer> b = new Bag<>(5);
        b.add(1);
        Queue<Integer> q = new Queue<>();
        q.enque(2);

        System.out.println("A2");
        System.out.println("A3");
    }
}
