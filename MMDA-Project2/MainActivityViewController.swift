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
    var startTime: String!
    var endTime: String!
    var activityData: [[Float]]!
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
        
        
        postToServer()
        
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
            
            // calculate duration
            
            // post all stuff to server to pull down to make graphs
            
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
            var data:String = self.responseString as String
            _ = data.removeAtIndex(data.startIndex)
            _ = data.removeAtIndex(data.startIndex.advancedBy(data.characters.count - 1))
            data = data.stringByReplacingOccurrencesOfString("],[", withString: "]k[")
            var new_data = data.componentsSeparatedByString("k")
            self.activityData = []
            let tempsize = new_data.count
            
            // parsing the returned string into an array of array that has the yaw, pitch, and roll
            for i in 0 ..< tempsize {
                let data_part = new_data[i]
                var new_data_part = data_part.componentsSeparatedByString(",")
                var new_float_part:[Float] = []
                
                for j in 0 ..< new_data_part.count {
                    new_data_part[j] = new_data_part[j].stringByReplacingOccurrencesOfString("\"", withString: "")
                    new_data_part[j] = new_data_part[j].stringByReplacingOccurrencesOfString("[", withString: "")
                    new_data_part[j] = new_data_part[j].stringByReplacingOccurrencesOfString("]", withString: "")
                    new_float_part.append(Float(new_data_part[j])!)
                }
                self.activityData.append(new_float_part)
            }
            self.didGetServerData = true
            self.processData(200, yaw_pitch_roll_selector: 1)
        }
        
        task.resume();
    }
    
    // motion detection - calculate the number of times the activity was completed and the maximum degree
    // of movement acheived
    func processData(degree_threshold:Float, yaw_pitch_roll_selector:Int) {

        var max_degree:Float = 0
        var activity_count = 0
        var cross = false
        for i in 0 ..< self.activityData.count {
            if (self.activityData[i].count == 3) {
                if (self.activityData[i][yaw_pitch_roll_selector] - self.activityData[0][yaw_pitch_roll_selector] > max_degree) {
                    max_degree = self.activityData[i][yaw_pitch_roll_selector] - self.activityData[0][yaw_pitch_roll_selector]
                }
            }
            if (self.activityData[i].count == 3 && self.activityData[i][yaw_pitch_roll_selector] > degree_threshold) {
                cross = true
            }
            if (self.activityData[i].count == 3 && cross == true && self.activityData[i][yaw_pitch_roll_selector] < degree_threshold) {
                cross = false
                activity_count += 1
            }
        }
        print(activity_count)
        print(max_degree)
    }
    
    // post the quantitative and qualitative data to the server, to be used later for graphs and data display
    func postToServer() {
        
        // need to post: activity name, date of activity, activity count, max degree, activity duration,
        //               amount of cues needed, amount of assistance needed
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/testpost")!)
        request.HTTPMethod = "POST"
        let postString = "id=13&name=Jack"
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
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    // get the current date and time to calculate the duration of the activity and what data to
    // pull from the server
    func getDateTime() -> String {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
        
        /* 
 let date = NSDate()
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
    



}
