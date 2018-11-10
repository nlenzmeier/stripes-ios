//
//  String+CountCellDigits.swift
//  STRIPES
//
//  Created by Nicolle on 11/9/18.
//  Copyright © 2018 Nicolle Lenzmeier. All rights reserved.
//

import Foundation

extension String {
    // count the digit in ourself
    func digitCount() -> Int {
        let digits: Set<Character> = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
        
        // best method
        return reduce(into: 0) { $0 += digits.contains($1) ? 1 : 0 }
        
        // a way to eliminate the for loop in our program:
        /*
         let counter = cellPhoneNumber.reduce(into: 0) { (result, character) in
         if digits.contains(character) {
         result += 1
         }
         }
         */
        /* what the above code does:
         reduce - handles for loop for us
         (into: 0) - starts counter at value 0
         result - the accumulator (what's being incremented and setting counter), we can't do "counter += 1" b/c it's a let, not a var
         character -  current character being examined in the sequence
         at the end, result is assigned to counter once the full sequence has been reduced/evaluated
         */
        
        
        /* Old method below:
         var counter = 0                 // counts valid characters in the cell phone number string
         for num in cellPhoneNumber {
         // print("Letter: \(num)")
         
         if digits.contains(num) {
         counter += 1
         }
         }
         */
    }
}
