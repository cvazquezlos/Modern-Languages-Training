module Recursion where

-- This file contains exercises about recursion and lambda expressions.
-- Primitive recursion = Recursividad no final.
-- Tail recursion = Recursividad final.

-- A. Given a list, delete from it those numbers that are multiple of one given.
ej2A:: [Int]->Int->[Int]
ej2A x n = [y|y<-x, y`mod`n/=0]

ej2A':: [Int]->Int->[Int] -- Recursión no final
ej2A' [] _ = []
ej2A' (x:xs) n = if (x`mod`n/=0) then f++[x]
				 else f
		    where
		       f = ej2A' xs n
				 		
ej2A'':: [Int]->Int->[Int] -- Recursividad final
ej2A'' x n = ej2A''Aux x n []

ej2A''Aux:: [Int]->Int->[Int]->[Int]
ej2A''Aux [] _ acum = acum
ej2A''Aux (x:xs) n acum = if (x`mod`n/=0) then ej2A''Aux xs n (acum++[x])
										  else ej2A''Aux xs n acum

-- B. Write doble function just with lambda expressions.
ejB:: Int -> Int
ejB = (\ x -> x + x)

-- C. Given a list, return the multiplication of its numbers.
ejC:: [Int] -> Int -- Primitive recursion.
ejC [] = 0
ejC (x:xs) = (ejB x) + (ejC xs)

ejC':: [Int] -> Int -- Tail recursion.
ejC' x = ejC'Aux x 0

ejC'Aux:: [Int] -> Int -> Int
ejC'Aux [] acum = acum
ejC'Aux (x:xs) acum = acum + (ejB x) + (ejC'Aux xs acum)

ejC'':: [Int] -> Int -- Superior order functions.
ejC'' x = foldr (+) 0 (map (\m -> m* 2) x)

-- D. Given a list, return the average of its even numbers.
ejD:: [Int] -> Int -- Superior order functions.
ejD x = foldl (+) 0 (map (\m -> m * m) ([y | y <- x, even y]))

ejD':: [Int] -> Int -- List comprehension.
ejD' x = foldr (+) 0 [y * y | y <- x, y `mod` 2 == 0]

-- E. Given a list, return a 2-tuple which contains the element and its position in the list.
ej2E:: [Int]->[(Int,Int)]
ej2E x = ej2EAux x [1..(length x)] []

ej2EAux:: [Int]->[Int]->[(Int,Int)]->[(Int,Int)]
ej2EAux [] _ acum = acum
ej2EAux (x:xs) (u:us) acum = if (contains acum x) then ej2EAux xs us acum
					          else ej2EAux xs us (acum++[(x,u)])

contains:: [(Int,Int)]->Int->Bool
contains [] _ = False
contains ((x, _):xs) n = if (x==n) then True
				   else contains xs n

-- F. Given a list, return the number of 0 inside of it.
ej2F:: [Int]->Int
ej2F [] = 0
ej2F [0,_] = 1
ej2F (x:y:xs) = if ((x==0)&&(y/=0)) then (1+f) else (0+f) 
		   where
		      f = ej2F (y:xs)

-- G. Given a list, return two lists: the first with the repeated numbers, the last one with the others.
ejG:: [Int] -> ([Int], [Int])
ejG x = ejGAux x [] []

ejGAux:: [Int] -> [Int] -> [Int] -> ([Int], [Int])
ejGAux [] acum1 acum2 = (acum1, acum2)
ejGAux (x:xs) acum1 acum2 = if repeated acum1 x then (
			        ejGAux xs acum1 acum2
			    ) else (
			        if repeated xs x then (
			           ejGAux xs (acum1 ++ [x]) acum2
			        ) else ejGAux xs acum1 (acum2 ++ [x])
		            )

repeated:: [Int] -> Int -> Bool
repeated [] _ = False
repeated (x:xs) n = if x == n then True else repeated xs n

-- H. Given a list, return the n higher numbers.
ejH:: [Int] -> Int -> [Int]
ejH x n = ejHAux x n []

ejHAux:: [Int] -> Int -> [Int] -> [Int]
ejHAux [] _ acum = acum
ejHAux _ 0 acum = acum
ejHAux x n acum = ejHAux (delete m x) (n - 1) (acum ++ [m])
		      where
		         m = maximum x
				
delete:: Int -> [Int] -> [Int]
delete _ [] = []
delete n (x:xs) = if n == x then xs else x:(delete n xs)    

-- I. Given two lists, return if the first is contained in the second.
ejI:: [Int] -> [Int] -> Bool
ejI x y = ejIAux x y x

ejIAux:: [Int] -> [Int] -> [Int] -> Bool
ejIAux [] _ _ = True
ejIAux _ [] _ = False
ejIAux (x:xs) (y:ys) acum = if x == y then ejIAux xs ys acum 
					else ejIAux acum ys acum

-- J. Given a list, sort using insertion.
ejJ:: [Int] -> [Int]
ejJ [x] = [x]
ejJ (x:xs) = sort x (ejJ xs)

sort:: Int -> [Int] -> [Int]
sort x [] = [x]
sort x (y:ys) = if x < y then x:y:ys else y:(sort x ys)

-- K. Given two lists, return a list of tuples which contains the first element of the first list and the two first elements of the second list.
ejK:: [a] -> [b] -> [(a, b, b)]
ejK [] _ = []
ejK _ [] = []
ejK _ [x] = []
ejK (x:xs) (u:v:us) = (x, u, v):(ejK xs us)

-- L. Given an element and a list, insert the element in the list by the end.
ejL:: a -> [a] -> [a]
ejL n x = x ++ [n]

-- M. Given a function and two lists, merge them.
ejM:: (a -> a -> a) -> [a] -> [a] -> [a]
ejM f [] _ = []
ejM f _ [] = []
ejM f (x:xs) (y:ys) = (f x y):(ejM f xs ys)

-- N. Given a list, return its reverse list.
ejN:: [Int] -> [Int] -- Tail recursion.
ejN x = ejNAux x []

ejNAux:: [Int] -> [Int] -> [Int]
ejNAux [] acum = acum
ejNAux (x:xs) acum = (ejNAux xs acum) ++ acum ++ [x]

ejN':: [Int] -> [Int] -- Primitive recursion.
ejN' [] = []
ejN' (x:xs) = (ejN' xs) ++ [x]

ejN'':: [Int] -> [Int]
ejN'' x = foldr (\n acum -> acum ++ [n]) [] x

-- O. Given a list of lists, return its reverse.
ejO:: [[Int]] -> [[Int]]
ejO = foldr (\n acum -> acum ++ [foldr (\m acum1 -> acum1 ++ [m]) [] n]) []

-- P. Given a function, return it change the order of the elements.
ejP:: (a -> b -> c) -> (b -> a -> c)
ejP f x y = f y x

-- Q. Given a list and a function, return the result list of applying that function.
ejQ:: (a -> a) -> [a] -> [a]
ejQ f [] = []
ejQ f (x:xs) = (f x):(ejQ f xs)
