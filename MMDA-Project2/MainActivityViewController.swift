//
//  MainActivityViewController.swift
//  MMDA-Project2
//
//
//  Written by Stephanie Cleland, Nate Winters, & Steven Santos on 4/3/16.
//  Modified on: 5/2/16
//  Copyright © 2016 Stephanie Cleland, Nate Winters & Steven Santos. All rights reserved.
//  Heroku Server written by: Alex Goldschmidt


import UIKit

var activity_count: Int!
var max_degree: Float!
var duration: Int!
var startTime: String!

class MainActivityViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    var runningActivity = false
    
    // figure out valid activities for our different motions
    var pickerData = ["Bowling", "Teeth", "Hair"]
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
            
            // Get data from the server
            getServerData()
        }
    }
    
    
    // get gyro data from the server once the activity is complete
    func getServerData() {
        
        // only want to pull data from a very specific time slice from start time to end time
        let url = NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/gyro")
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
            self.processData(200, yaw_pitch_roll_selector: 1)
        }
        
        task.resume();
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
        /*
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
        */

        let date = NSDate()
        let time = Int(date.timeIntervalSince1970 * 1000)
        return String(time)
        /*
 let calendar = NSCalendar.currentCalendar()
 let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
 let hour = components.hour
 let minutes = components.minute
 let month = components.month
 let year = components.year
 let day = components.day
         */
 
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
