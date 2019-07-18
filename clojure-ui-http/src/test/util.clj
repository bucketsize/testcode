(ns test.util
  (:import (java.io File FileReader BufferedReader InputStreamReader OutputStreamWriter)
           (java.net URL)
           ))

(def max-read 100)

(defn readFile [name]
  (let [reader 
        (new BufferedReader
             (new FileReader (new File name)))]

    (loop [sum (new StringBuffer)]
      (let [ch (. reader read)]
        (if (= ch -1)
          (prn (. sum toString))
          (recur  (. sum (append (char ch)))))))))

(defn readFileSafe [name]
  (let [reader 
        (new BufferedReader
             (new FileReader (new File name)))]
    (loop [cnt 0 
           sum (new StringBuffer)]
      (let [ch (. reader read)]
        (if (or (= ch -1) (> cnt max-read))
          (prn (. sum toString))
          (recur (inc cnt) (. sum (append (char ch)))))))))

(defn httpGet [url charset]
  (let [conn (. (new URL url) openConnection)]
    (. conn (setRequestProperty "Accept-Charset" charset))
    (let [istream (. conn getInputStream) 
          reader (new BufferedReader 
                      (new InputStreamReader 
                           (. conn getInputStream))) 
          ]
      (loop [sum (new StringBuffer)]
        (let [ch (. reader read)]
          (if (= ch -1)
            (. sum toString)
            (recur (. sum (append (char ch))))
            )
          )
        )
      )
    )
  )


(defn httpPost [url charset postdata]
  (let [conn (. (new URL url) openConnection)]
    (. conn (setRequestProperty "Accept-Charset" charset))
    (. conn (setDoOutput true))
    (let [writer (new OutputStreamWriter
                      (. conn getOutputStream)
                      )]
      (. writer (write postdata))
      (. writer close)
      )
    (let [istream (. conn getInputStream) 
          reader (new BufferedReader 
                      (new InputStreamReader 
                           (. conn getInputStream))) 
          ]
      (loop [sum (new StringBuffer)]
        (let [ch (. reader read)]
          (if (= ch -1)
            (. sum toString)
            (recur (. sum (append (char ch))))
            )
          )
        )
      )
    )
  )

;(httpPost "http://localhost:4567/reverse" "utf-8" "data=wassup pancy ass butt muncher")
(httpGet "http://localhost:4567/reverse/sonomavicha" "utf-8")
;(readFile "src/test/core.clj")
