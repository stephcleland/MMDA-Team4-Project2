//
//  EditActivityViewController.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on:
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.


import UIKit

class EditActivityViewController: UIViewController {
    
    @IBOutlet weak var goalsLabel: UILabel!
    var currActivity:Activity!
    @IBOutlet weak var two: UILabel!
    @IBOutlet weak var one: UILabel!
    @IBOutlet weak var goal1: UITextView!
    @IBOutlet weak var goal2: UITextView!
    @IBOutlet weak var movementsLabel: UILabel!
    @IBOutlet weak var three: UILabel!
    @IBOutlet weak var goal3: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var movementList: UITextView!
    @IBOutlet weak var activityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityLabel.textAlignment = .Center
        goal1.editable = false
        goal2.editable = false
        goal3.editable = false
        
        activityLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
        doneButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 16.0)
        editButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        movementList.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        goal1.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        goal2.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        goal3.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        one.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        two.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        three.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        movementsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        goalsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        
        
        
        movementList.editable = false
        movementList.text = ""
        
        activityLabel.text = currentlySelectedActivity
        currActivity = Activity()
        var foundActivity = false
        for activity in activities {
            if (activity.name == currentlySelectedActivity) {
                currActivity = activity
                foundActivity = true
            }
        }
        if (foundActivity) {
            //let index = activities.indexOf(currentlySelectedActivity)
            goal1.text = currActivity.goals[0]
            goal2.text = currActivity.goals[1]
            goal3.text = currActivity.goals[2]
            for motion in currActivity.motions {
               movementList.text = movementList.text + motion + "\n"
            }
        }
        
}

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
    }
    
    @IBAction func editPressed(sender: AnyObject) {
        goal1.editable = !goal1.editable
        goal2.editable = !goal2.editable
        goal3.editable = !goal3.editable

        if (goal1.editable) {
            editButton.setTitle("Save", forState: .Normal)
        } else {
            currActivity.changeGoals(0, goal: goal1.text)
            currActivity.changeGoals(1, goal: goal2.text)
            currActivity.changeGoals(2, goal: goal3.text)
            editButton.setTitle("Edit", forState: .Normal)
        }
    }

}
