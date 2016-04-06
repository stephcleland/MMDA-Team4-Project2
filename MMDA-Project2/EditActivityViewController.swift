//
//  EditActivityViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

class EditActivityViewController: UIViewController {
    
    var currActivity:Activity!
    @IBOutlet weak var goal1: UITextView!
    @IBOutlet weak var goal2: UITextView!
    @IBOutlet weak var goal3: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var movementList: UITextView!
    @IBOutlet weak var activityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        goal1.editable = false
        goal2.editable = false
        goal3.editable = false
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
               print(motion)
               movementList.text = movementList.text + motion + "\n"
            }
        }
        
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
 /*
    @IBAction func enterPressed(sender: AnyObject) {
        goalsTxtField.resignFirstResponder()
        goalsLabel.text = goalsTxtField.text
        print(goalsLabel.text)
        
    }
 */
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
