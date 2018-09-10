//
//  ScoringClass.swift
//  Hyroscop
//
//  Created by Mikhail Lutskiy on 01.09.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

class ScoringClass {
    
    static let shared = ScoringClass()
    
    var index = 0
    
    fileprivate static let maxItterations = 10
    
    var arrayForX = [Double]()
    
    var arrayStat = [Bool]()
    
    func makeAnalyse () -> Bool {
        if arrayForX.count > 0 {
            var first = arrayForX.first ?? 0.0
            for x in arrayForX {
                if sqrt((first - x)*(first - x)) < 2 {
                    arrayStat.append(true)
                } else {
//                    arrayStat.append(false)
                }
                
            }
            if arrayStat.count < 5 {
                print("яма")
                return true
            } else {
                print("ямы нет")
                return false
            }
        }
        return false
    }
    
    func addDotToArray (dot: Double) -> Bool {
        if arrayForX.count < 11 {
            arrayForX.append(dot)
            return false
        } else {
            let variable = makeAnalyse()
            arrayForX = [Double]()
            arrayStat = [Bool]()
            return variable
        }
    }
    
}
