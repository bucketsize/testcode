package com.project;

public class Combination {
    public static void main(String[] args) {
        new Combination().generate("ABC");
    }
    public void generate(String str){
        generate("", str, 0);
    }
    private void generate(String left, String right, int len){
        if ( right.length() == 0 ){
            System.out.println(left);
        }else{
            for (int i=0; i<right.length(); i++) {
                String l = left + right.substring(i, i+1);
                String r = right.substring(0, i) + right.substring(i+1);
                generate(l, r, 0);
            }
        }
    }
}
