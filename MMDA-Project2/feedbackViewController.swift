//
//  feedbackViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/6/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

class feedbackViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cuesSlider: UISlider!
    @IBOutlet weak var assistanceSlider: UISlider!
    @IBOutlet weak var commentsField: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cuesQ: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var cuesDescriber: UILabel!
    @IBOutlet weak var assistanceQ: UILabel!
    var assistanceDescribers = ["100% - Total Assistance", "75% - Maximum Assistance", "50% - Moderate Assistance", "25% - Minimum Assistance", "0% - Standby Assistance"]
    var cuesDescribers = ["100% - Constant Cues", "75% - Maximum Cues", "50% - Moderate Cues", "25% - Minimum Cues", "10% - Occassional Cues", "0% - No Cues"]
    var animateTextView = false


    @IBOutlet weak var assistanceDescriber: UILabel!
    override func viewDidLoad() {

        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 19.0)
        commentsField.font = UIFont(name: "ArialRoundedMTBold", size: 14.0)
        doneButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        cuesQ.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        commentsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        cuesDescriber.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        assistanceQ.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        assistanceDescriber.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        
        titleLabel.text = "Feedback for " + currentlySelectedActivity
        titleLabel.textAlignment = .Center
        cuesSlider.continuous = false
        assistanceSlider.continuous = false
        assistanceDescriber.text = assistanceDescribers[2]
        cuesDescriber.text = cuesDescribers[2]
        commentsField.text = "Any other comments on today's activity?"
        self.commentsField.delegate = self
        
        
    }
      @IBAction func assistanceSliderChanged(sender: UISlider) {
        let prev = sender.value * 100
        var next:Float = 50
        var text:String = ""
        if (prev > 87.5) {
            next = 100
            text = assistanceDescribers[0]
        }
        else if (prev > 62.5) {
            next = 75
            text = assistanceDescribers[1]
        }
        else if (prev > 37.5) {
            next = 50
            text = assistanceDescribers[2]
        }
        else if (prev > 12.5) {
            next = 25
            text = assistanceDescribers[3]
        }
        else {
            next = 0
            text = assistanceDescribers[4]
        }
        sender.value = next / 100
        assistanceDescriber.text = text
    }
    @IBAction func cuesSliderChanged(sender: UISlider) {
        let prev = sender.value * 100
        var next:Float = 50
        var text:String = ""
        if (prev > 87.5) {
            next = 100
            text = cuesDescribers[0]
        }
        else if (prev > 62.5) {
            next = 75
            text = cuesDescribers[1]
        }
        else if (prev > 37.5) {
            next = 50
            text = cuesDescribers[2]
        }
        else if (prev > 17.5) {
            next = 25
            text = cuesDescribers[3]
        }
        else if (prev > 5){
            next = 10
            text = cuesDescribers[4]
        }
        else {
            next = 0
            text = cuesDescribers[5]
        }
        sender.value = next / 100
        cuesDescriber.text = text

    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        print("we out here")
        self.animateTextView(true)
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        print("hello")
        self.animateTextView(false)
    }
    
    func animateTextView(up: Bool) {
        let movementDistance:Int = 224
        let movementDuration:Float = 0.35
        let movement = (up ? -movementDistance : movementDistance)
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(NSTimeInterval(movementDuration))
        self.view.frame = CGRectOffset(self.view.frame, 0, CGFloat(movement))
        UIView.commitAnimations()
        
    }
    
}

