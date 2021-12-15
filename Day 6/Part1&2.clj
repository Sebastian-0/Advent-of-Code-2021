
;;
;; Input
;;
;; (def initial [3, 4, 3, 1, 2])
(def initial 
    [1, 3, 4, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 4, 2, 4, 1, 1, 1, 1, 1, 5, 4, 1, 1, 2, 1, 1, 1,
     1, 4, 1, 1, 1, 4, 4, 1, 1, 1, 1, 1, 1, 1, 2, 4, 1, 3, 1, 1, 2, 1, 2, 1, 1, 4, 1, 1, 1, 4,
     3, 1, 3, 1, 5, 1, 1, 3, 4, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 2, 5, 5,
     3, 2, 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 5, 1, 1, 1, 1, 5, 1, 1, 1,
     1, 1, 4, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 2, 4, 1, 5, 5, 1, 1, 5,
     3, 4, 4, 4, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 5, 3, 1, 4, 1, 1, 2, 2, 1,
     2, 2, 5, 1, 1, 1, 2, 1, 1, 1, 1, 3, 4, 5, 1, 2, 1, 1, 1, 1, 1, 5, 2, 1, 1, 1, 1, 1, 1, 5,
     1, 1, 1, 1, 1, 1, 1, 5, 1, 4, 1, 5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1,
     5, 4, 5, 1, 1, 1, 1, 1, 1, 1, 5, 1, 1, 3, 1, 1, 1, 3, 1, 4, 2, 1, 5, 1, 3, 5, 5, 2, 1, 3,
     1, 1, 1, 1, 1, 3, 1, 3, 1, 1, 2, 4, 3, 1, 4, 2, 2, 1, 1, 1, 1, 1, 1, 1, 5, 2, 1, 1, 1, 2])

;;
;; Part 1
;;
(defn decrease [numbers]
    (map dec numbers))

(defn expand [numbers] 
    (reduce into []
            (for [n numbers] 
                (if (< n 0)
                    [6 8]
                    [n]))))

(defn step [numbers] 
    (expand (decrease numbers)))
   
(defn steps [numbers cnt]
    (if (= cnt 0)
        numbers
        (recur (step numbers) (dec cnt))))

(println "After 80 days:" (count (steps initial 80)))

;;
;; Part 2
;;

;; Define power function that we will use later
(defn pow [a b] (int (java.lang.Math/pow a b)))

;; This denotes a single step for each number, i.e. which numbers get generated over a single iteration
;; The 1st row says 0 -> 6 8, 2nd says 1 -> 0, etc...
(def table [[0 0 0 0 0 0 1 0 1]
            [1 0 0 0 0 0 0 0 0]
            [0 1 0 0 0 0 0 0 0]
            [0 0 1 0 0 0 0 0 0]
            [0 0 0 1 0 0 0 0 0]
            [0 0 0 0 1 0 0 0 0]
            [0 0 0 0 0 1 0 0 0]
            [0 0 0 0 0 0 1 0 0]
            [0 0 0 0 0 0 0 1 0]])

;; This will square the steps taken so far, so 1 step -> 2, 2 -> 4, etc...
(defn square [table]
    (vec (for [row table]
        (vec (for [[c col] (map-indexed list row)]
            (reduce + 0
                (for [i (range (count row))]
                    (* (get row i) (get (get table i) c)))))))))

;; Find the first 9 squares
(def squares (vec (take 9 (iterate square table))))

;; Print all matrices
(doseq [[iter square] (map-indexed list squares)]
    (do (println "")
        (printf "Iteration %d, %d days%n" iter (pow 2 iter))
        (doseq [row square]
            (println row))))

;; Compute result, for each start number sum the amount of fishes it generates in 256 days
(defn sum [initial]
    (let [square (get squares 8)]
        (reduce + 
            (for [n initial]
                (reduce + (get square n))))))

(println "")
(println "After 256 days:" (sum initial))


;; Run with:
;; docker run --rm -i -v "$(pwd)":/aoc -w /aoc clojure clj Part1&2.clj

;; repl:
;; docker run --rm -i -v "$(pwd)":/aoc -w /aoc clojure clj -r