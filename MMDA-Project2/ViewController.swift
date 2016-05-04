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

class ViewController: UIViewController, PNChartDelegate {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var byDateButton: UIButton!
    @IBOutlet weak var byActivityButton: UIButton!
    @IBOutlet weak var beginSessionButton: UIButton!

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

        getServerData()
        //self.drawChart()

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
 
    // draws a line/bar chart with the data pulled from the server
    func drawChart() {
        print("in here")
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 115, 320.0, 30))
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        
        // Bar Chart
        
         ChartLabel.text = "Activity Completions"
         
         let barChart = PNBarChart(frame: CGRectMake(0, 150.0, 320.0, 200.0))
         barChart.backgroundColor = UIColor.clearColor()
         
         barChart.animationType = .Waterfall
         
         
         barChart.labelMarginTop = 5.0
        
         var xlab:[String] = []
         for i in 0 ..< serverData.count {
            let activity = serverData[i]["activity"] as? NSString as! String
            if (!xlab.contains(activity)) {
                xlab.append(activity)
            }
         }
        var yvals = [Int](count: xlab.count, repeatedValue: 0)
        for i in 0 ..< serverData.count {
            let activity = serverData[i]["activity"] as? NSString as! String
            let index = xlab.indexOf(activity)
            yvals[index!] += 1
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
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    // function if the user clicks on a line segment on the line graph
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    // function if the user clicks on a bar in the bar graph
    func userClickedOnBarChartIndex(barIndex: Int)
    {
        print("Click  on bar \(barIndex)")
    }

}

