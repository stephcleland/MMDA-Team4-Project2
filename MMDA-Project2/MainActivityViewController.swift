//
//  MainActivityViewController.swift
//  MMDA-Project2
//
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on:
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.


import UIKit

class MainActivityViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    var runningActivity = false
    var pickerData = ["Bowling", "Teeth", "Hair"]
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var startStopView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myPicker.delegate = self
        myPicker.dataSource = self
        startStopButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
        addButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 40.0)
        editButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 18.0)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 24.0)
        backButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 14.0)
        titleLabel.textAlignment = .Center
        startStopView.backgroundColor = UIColor(hue: 0.25, saturation: 0.22, brightness: 0.93, alpha: 1.0)
        for activity in activities {
            pickerData.append(activity.name)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return pickerData[row]
    }
    
    // record the timestamp when start and stop pressed
    // when stop pressed, pull that specific time slice from the server to process
    @IBAction func startStopPressed(sender: AnyObject) {
        runningActivity = !runningActivity
        if (runningActivity) {
            // starting activity monitoring
            startStopView.backgroundColor = UIColor(hue: 0.025, saturation: 0.22, brightness: 0.92, alpha: 1.0)
            startStopButton.setTitle("Stop Activity", forState: .Normal)
        } else {
            // stopping activity monitoring
            let feedbackVC = (self.storyboard?.instantiateViewControllerWithIdentifier("feedbackViewController") )! as UIViewController
            //self.navigationController?.pushViewController(feedbackVC, animated: true)
            //let feedbackVC = feedbackViewController()
            presentViewController(feedbackVC, animated: true, completion: nil)
            startStopButton.setTitle("Start Activity", forState: .Normal)
            startStopView.backgroundColor = UIColor(hue: 0.25, saturation: 0.22, brightness: 0.93, alpha: 1.0)
        }
    }
    // this is where you do stuff with what is picked
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentlySelectedActivity = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "ArialRoundedMTBold", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    /* better memory management version */
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(pickerData.count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 0.7)
        }
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "ArialRoundedMTBold", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
        
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 55.0
    }



}
