//
//  feedbackViewController.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/6/16.
//  Modified on: 4/16/16
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.


import UIKit

var assistancePercent: Float!
var cuesPercent: Float!

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

        // setting up the UI
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
        assistancePercent = 0.5
        cuesPercent = 0.5
        
        
    }
    
    // when user is done giving qualitative feedback, post all data to
    // the server
    @IBAction func donePressed(sender: AnyObject) {
        postToServer()
    }
    
    // post the quantitative and qualitative data to the server, to be used later for graphs and data display
    func postToServer() {
        
        // need to post: activity name, date of activity, activity count, max degree, activity duration, amount of cues needed, amount of assistance needed
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/testpost")!)
        request.HTTPMethod = "POST"
        startTime = "1462204800000"
        let postString = "duration="+String(duration)+"&count="+String(activity_count)+"&activity="+currentlySelectedActivity+"&maxdegree="+String(max_degree)+"&cues="+String(cuesPercent)+"&assist="+String(assistancePercent)+"&time="+startTime
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            _ = NSString(data: data!, encoding: NSUTF8StringEncoding)
        }
        task.resume()
        
    }
    
    // function that forces the user to pick one of 5 values with a certain display on the assistance slider
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
        assistancePercent = next / 100
        assistanceDescriber.text = text
    }
    
    // function that forces the user to pick one of 4 values with a certain display on the cues slider
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
        cuesPercent = next / 100
        cuesDescriber.text = text

    }
    

    // functions to move the comments field above the keyboard when pulled up
    func textViewDidBeginEditing(textView: UITextView) {
        self.animateTextView(true)
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
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

