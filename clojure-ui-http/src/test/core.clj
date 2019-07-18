(ns test.core
  (:import (javax.swing JButton
                        JFrame
                        JPanel)
           (java.lang System)
           (java.awt.event ActionListener))
  (:gen-class)) ;java class gen

(defn start-app []
  (let [frame (new JFrame)
        panel (new JPanel)
        button (new JButton "Quit")]
    
    (doto button
      (. setBounds 50 60 80 30)
      (. addActionListener 
         (reify ActionListener 
           (actionPerformed [_ evt] 
                            (System/exit 0)))))
      
    (doto panel
      (. add button)
      (. setLayout nil))
  
    (doto frame
      (.. (getContentPane) (add panel))
      (. setTitle "my clj ui")
      (. setDefaultCloseOperation JFrame/EXIT_ON_CLOSE)
      (. setSize 300 200)
      (. setLocationRelativeTo nil)
      (. setVisible true))))

(defn -main [argv] ;java calling interface
  (start-app))

(start-app)