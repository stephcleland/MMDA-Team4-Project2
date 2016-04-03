//
//  Activity.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import Foundation

class Activity {
    var name: String
    var goals = ["", "", ""]
    var motions = [String]()
    
    init() {
        name = "acitivitttty"
        for i in 0...goals.count - 1 {
            goals[i] = "blah"
        }
    }
    
    func addMotion(motion:String) {
        motions.append(motion)
    }
    
    func changeGoals(index:Int, goal:String) {
        goals[index] = goal
    }
    
    func changeName(newName:String) {
        name = newName
    }
    
    func removeMotion(index:Int) {
        motions.removeAtIndex(index)
    }

    
}