#!/usr/bin/env janet
# Autoversion
# https://github.com/fuxoft/autoversion.lua xxxxxxxxxxxxxxxxxx

(def my-version (first (peg/match ~(* (thru "'") (<- (to "'")))
                                 "[[*<= Version '3.1.1+D20230726T191115' =>*]]")))

(defn load [fname]
  (def fd (file/open fname :r))
  (assert fd (string "Unable to open file for reading: " fname))
  (def contents (file/read fd :all))
  (assert contents)
  (file/close fd)
  contents)

(defn save [fname text]
  (def fd (file/open fname :w))
  (assert fd (string "Unable to open file for writing: " fname))
  (file/write fd text)
  (file/close fd))

(def args (array/slice (dyn *args*) 1))
(var v-num 3)
(assert (pos? (length args)) "Missing filename")

(each arg (array/slice args 0 -2)
  (case arg
    "-v1" (set v-num 1)
    "-v2" (set v-num 2)
    "-v3" (set v-num 3)
    (errorf "Invalid option: %s" arg)))


(def prefix "[[*<= Version '")
(def suffix "' =>*]]")
(def filename (last args))
(def original-string (load filename))
(def mtch (peg/match
            ~{:num (capture :d+)
              :main (some (+ (* ,prefix (capture (* :num "." :num "." :num "+D" (repeat 8 :d) "T" (repeat 6 :d))) ,suffix (any 1)) 1))}
            original-string))

(assert (= (length (if mtch mtch [])) 4) "Version string not found in file.\nVersion string must be in the following format: [[*<= Version '1.22.333+D20231231T235959' =>*]]")

(def original-version (last mtch))
(def v-strings (array/slice mtch 0 3))
(def v-string (string/join v-strings "."))
(def vs (map parse v-strings))
(case v-num
  3 (put vs 2 (inc (vs 2)))
  2 (do
      (put vs 1 (inc (vs 1)))
      (put vs 2 0))
  1 (do
      (put vs 0 (inc (vs 0)))
      (put vs 1 0)
      (put vs 2 0)))
(def new-v-string (string/join (map string vs) "."))

(def date (os/date))
(def date-string
  (string/format
    "D%04d%02d%02dT%02d%02d%02d"
    (date :year) (inc (date :month)) (inc (date :month-day))
    (date :hours) (date :minutes) (date :seconds)))

(def new-version (string new-v-string "+" date-string))

(def
  new-string
  (string/replace
    (string prefix original-version suffix)
    (string prefix new-version suffix)
    original-string))

(assert (not= (string original-string) (string new-string)))

(save filename new-string)

(printf "Updated %s version: %s -> %s." filename original-version new-version)
