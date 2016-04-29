//
//  Activity.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on:
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.


import Foundation

class Activity {
    var name: String
    var goals = ["", "", ""]
    var motions = [String]()
    
    init() {
        name = ""
        for i in 0...goals.count - 1 {
            goals[i] = "Enter a goal!"
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