//
//  MainActivityViewController.swift
//  MMDA-Project2
//
//
//  Written by Stephanie Cleland, Nate Winters, & Steven Santos on 4/3/16.
//  Modified on: 5/6/16
//  Copyright © 2016 Stephanie Cleland, Nate Winters & Steven Santos. All rights reserved.
//  Heroku Server written by: Alex Goldschmidt


import UIKit

var activity_count: Int!
var max_degree: Float!
var duration: Int!
var startTime: String!

class MainActivityViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var logo: UIButton!
    var runningActivity = false
    
    // figure out valid activities for our different motions
    var pickerData:[String] = []
    var yawPitchRoll = [1, 0, 2, 2]
    var degreeThresholds: [Float] = [45.0, 45.0, 90.0, 90.0]
    var motions = ["Shoulder Flexion", "Shoulder Horizontal Adduction", "Elbow Supination", "Elbow Pronation"]
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var startStopView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myPicker: UIPickerView!
    var responseString: NSString!
    var endTime: String!
    var activityData: NSArray!
    var didGetServerData: Bool!

    
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
        logo.setBackgroundImage(UIImage(named:"logo1.png")!, forState: .Normal)
        logo.setTitle("", forState: .Normal)
        for activity in activities {
            pickerData.append(activity.name)
        }
        currentlySelectedActivity = pickerData[0]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // the button for stopping or starting the monitoring an activity
    @IBAction func startStopPressed(sender: AnyObject) {
        runningActivity = !runningActivity
        if (runningActivity) {
            // starting activity monitoring
            startStopView.backgroundColor = UIColor(hue: 0.025, saturation: 0.22, brightness: 0.92, alpha: 1.0)
            startStopButton.setTitle("Stop Activity", forState: .Normal)
            
            // to tell the arduino to change light color to yellow
            postToServer("1")
            
            // record time stamp
            startTime = getDateTime()
            
            
        } else {
            // stopping activity monitoring
            let feedbackVC = (self.storyboard?.instantiateViewControllerWithIdentifier("feedbackViewController") )! as UIViewController
            presentViewController(feedbackVC, animated: true, completion: nil)
            startStopButton.setTitle("Start Activity", forState: .Normal)
            startStopView.backgroundColor = UIColor(hue: 0.25, saturation: 0.22, brightness: 0.93, alpha: 1.0)
            
            // record time stamp
            endTime = getDateTime()
            
            // to tell the arduino to change light color to green then red
            postToServer("0")

            
            // Get data from the server
            //getServerData()
        }
    }
    
    
    // get gyro data from the server once the activity is complete
    func getServerData() {
        
        // only want to pull data from a very specific time slice from start time to end time
        let url = NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/gyro"+"?start_time="+(startTime)+"&end_time="+endTime)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        self.didGetServerData = false
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
            }
            
            self.responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            self.activityData = self.convertStringToDictionary(self.responseString)
            self.didGetServerData = true
            
            // send in the correct degree threshold depending on motion, and whether we're looking
            // at yaw, pitch, or roll
            var yprVal = self.yawPitchRoll[0]
            var degreeThreshold = self.degreeThresholds[0]
            for activity in activities {
                if (activity.name == currentlySelectedActivity) {
                    yprVal = self.yawPitchRoll[self.motions.indexOf(activity.motions[0])!]
                    degreeThreshold = self.degreeThresholds[self.motions.indexOf(activity.motions[0])!]
                }
                
            }
            
            
            self.processData(degreeThreshold, yaw_pitch_roll_selector: yprVal)
        }
        
        task.resume();
    }
    
    // post a 0 or 1 to the server to indicate how the lights should change
    func postToServer(activityState:String) {
        
        // need to post: activity name, date of activity, activity count, max degree, activity duration, amount of cues needed, amount of assistance needed
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/activitystatepost")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = activityState.dataUsingEncoding(NSUTF8StringEncoding)
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
    
    // motion detection - calculate the number of times the activity was completed and the maximum degree
    // of movement acheived
    func processData(degree_threshold:Float, yaw_pitch_roll_selector:Int) {
        max_degree = 0
        activity_count = 0
        var cross = false
        for i in 0 ..< self.activityData.count {
           // let time = self.activityData[i]["time"] as? NSNumber
            let data = self.activityData[i]["data"] as? NSArray
            let initData = self.activityData[0]["data"] as? NSArray
            if (data!.count == 3) {
                let curr_val = Float(data![yaw_pitch_roll_selector] as! String)!
                let init_val = Float(initData![yaw_pitch_roll_selector] as! String)!
                let curr_degree = curr_val - init_val
                if(curr_degree > max_degree) {
                    max_degree = curr_degree
                }
                if (curr_val > degree_threshold) {
                    cross = true
                }
                if (cross == true && curr_val < degree_threshold) {
                    cross = false
                    activity_count = activity_count + 1
                }
            }
            
        }
        duration = (self.activityData[activityData.count - 1]["time"] as? NSNumber as! Int) - (self.activityData[0]["time"] as? NSNumber as! Int)
        duration = (duration / 1000) / 60
    }
    
    // get the current date and time to calculate the duration of the activity and what data to
    // pull from the server
    func getDateTime() -> String {

        let date = NSDate()
        let time = Int(date.timeIntervalSince1970 * 1000)
        return String(time)

    }
    
    // convert time from milliseconds to NSDate
    func msToDate(milliseconds: Int) -> NSDate {
        let timeAsInt: Int = milliseconds
        
        let timeAsInterval: NSTimeInterval = Double(timeAsInt)/1000
        
        let theDate = NSDate(timeIntervalSince1970: timeAsInterval)
        
        return theDate
        
    }
    
    // all the picker view functions are for the formatting and functionality of the activity
    // picker view
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentlySelectedActivity = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "ArialRoundedMTBold", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
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
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    // convert what is returned from the server into an NSArray
    func convertStringToDictionary(text: NSString) -> NSArray? {
        let data = text.dataUsingEncoding(NSUTF8StringEncoding)
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                return json as! NSArray
         } catch {
                print("Something went wrong")
         }
         return nil
        
    }


}
