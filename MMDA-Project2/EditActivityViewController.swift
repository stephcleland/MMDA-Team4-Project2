//
//  EditActivityViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

class EditActivityViewController: UIViewController {

    @IBOutlet weak var goal1: UITextView!
    @IBOutlet weak var goal2: UITextView!
    @IBOutlet weak var goal3: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var activityLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        goal1.editable = false
        goal2.editable = false
        goal3.editable = false


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
