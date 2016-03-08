package com.project;

public class BST<T extends Comparable<T>, U> {
    private class Node{
        T key;
        U value;
        Node left;
        Node right;
        public Node(T key, U value){
            this.key = key;
            this.value = value;
        }
    }
    private Node root;
    public U get(T key){
        return get(root, key);
    }
    public U get(Node root, T key){
        if (root == null){
            return null;
        }
        if (key.compareTo(root.key) < 0){
            return get(root.left, key);
        }
        if (key.compareTo(root.key) > 0){
            return get(root.right, key);
        }
        return root.value;
    }
    public void put(T key, U value){
        put(root, key, value);
    }
    public void put(Node root, T key, U value){
        if (root == null){
            root = new Node(key, value);
        }
        if (key.compareTo(root.key) < 0){
           if (root.left == null) {
               root.left = new Node(key, value);
           } else {
               put(root.left, key, value); 
           } 
        }
        if (key.compareTo(root.key) > 0){
           if (root.right == null) {
               root.right = new Node(key, value);
           } else {
               put(root.right, key, value); 
           } 
        }
        root.value = value;
    }
    
    public static void main(String[] args) {
        BST<Integer, String> bst = new BST<>();
        bst.put(1, "one");
        bst.put(12, "twelve");
        bst.put(5, "five");

        System.out.printf("get[%s] = %s\n", 1, bst.get(12));
        System.out.printf("get[%s] = %s\n", 22, bst.get(22));
    }

}
