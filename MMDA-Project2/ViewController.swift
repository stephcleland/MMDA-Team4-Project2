//
//  ViewController.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on: 5/2/16
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.
//
// Heroku Server written by: Alex Goldschmidt
//
// Line chart and bar graph from: https://github.com/kevinzhow/PNChart-Swift


import UIKit

var activities = [Activity]()
var currentlySelectedActivity = ""
var serverData: NSArray!
var addedInitialActivities = false

class ViewController: UIViewController, PNChartDelegate {
    @IBOutlet weak var sessionsLabel: UILabel!
    @IBOutlet weak var Sessions: UILabel!

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var Days: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var byDateButton: UIButton!
    @IBOutlet weak var byActivityButton: UIButton!
    @IBOutlet weak var beginSessionButton: UIButton!
    var pickerData = ["Bowling", "Slapsies Defense", "Slapsies Offense", "Making Bubbles"]
    var yawPitchRoll = [1, 0, 2, 2]
    var degreeThresholds: [Float] = [200.0, 200.0, 200.0, 200.0]
    var motions = ["Shoulder Flexion", "Shoulder Horizontal Adduction", "Elbow Supination", "Elbow Pronation"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up the UI
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = "Alexa"
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30.0)
        byDateButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 14.0)
        byActivityButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 14.0)
        beginSessionButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 22.0)
        Sessions.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        sessionsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        Days.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        daysLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        
        // adding the pre-programmed activities to monitor
        if (!addedInitialActivities) {
            let newActivity = Activity()
            newActivity.changeName("Bowling")
            newActivity.addMotion("Shoulder Flexion")
            activities.append(newActivity)
            
            let newActivity2 = Activity()
            newActivity2.changeName("Slapsies Defense")
            newActivity2.addMotion("Elbow Supination")
            activities.append(newActivity2)
            
            let newActivity3 = Activity()
            newActivity3.changeName("Slapsies Offense")
            newActivity3.addMotion("Elbow Pronation")
            activities.append(newActivity3)
            
            let newActivity4 = Activity()
            newActivity4.changeName("Making Bubbles")
            newActivity4.addMotion("Shoulder Horizontal Adduction")
            activities.append(newActivity4)
            addedInitialActivities = true
        }
        
        getServerData()

    }
    
    // get data from the server to display in the graphs
    func getServerData() {
        
        let url = NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/testget")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            serverData = self.convertStringToDictionary(responseString!)
            dispatch_async(dispatch_get_main_queue()) {
                self.displayData()
                self.drawChart()
            }
        }
        
        task.resume();
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
 
    // get the qualitative data to display on the home screen
    func displayData() {
        var days:[String] = []
        for i in 0 ..< serverData.count {
            let temp = serverData[i]["time"] as? NSString
                if (temp != nil) {
                    let time = temp!.doubleValue / 1000
                    let timeDate = NSDate(timeIntervalSince1970: time)
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    let date = formatter.stringFromDate(timeDate)
                    if (!days.contains(date)) {
                        days.append(date)
                    }
            }
        }

        Sessions.text = String(serverData.count)
        Days.text = String(days.count)

        
    }
    
    // draws a bar chart with the number of times each activity was completed
    func drawChart() {
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 115, 320.0, 30))
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        
         ChartLabel.text = "Activity Completions"
         
         let barChart = PNBarChart(frame: CGRectMake(0, 150.0, 320.0, 200.0))
         barChart.backgroundColor = UIColor.clearColor()
         
         barChart.animationType = .Waterfall
         
         barChart.labelMarginTop = 5.0
        
         var xlab:[String] = []
         for i in 0 ..< serverData.count {
            let activity = serverData[i]["activity"] as? NSString as! String
            if (!xlab.contains(activity) && activity != "") {
                xlab.append(activity)
            }
         }
        var yvals = [Int](count: xlab.count, repeatedValue: 0)
        for i in 0 ..< serverData.count {
            let activity = serverData[i]["activity"] as? NSString as! String
            if (activity != "") {
                let index = xlab.indexOf(activity)
                yvals[index!] += 1
            }
        }
        
        for i in 0 ..< xlab.count {
            xlab[i] = xlab[i] + " (" + String(yvals[i]) + ")"
        }
         barChart.xLabels = xlab
         barChart.yValues = yvals
         barChart.strokeChart()
         barChart.delegate = self
         
         view.addSubview(ChartLabel)
         view.addSubview(barChart)
         
         title = "Bar Chart"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // function if the user clicks on a point on the line graph
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {

    }
    
    // function if the user clicks on a line segment on the line graph
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
    }
    
    // function if the user clicks on a bar in the bar graph
    func userClickedOnBarChartIndex(barIndex: Int)
    {
    }

}

