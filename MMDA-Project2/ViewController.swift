//
//  ViewController.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on:
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.
//
// Heroku Server written by: Alex Goldschmidt
//
// Line chart and bar graph from: https://github.com/kevinzhow/PNChart-Swift


import UIKit

var activities = [Activity]()
var currentlySelectedActivity = ""

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

        
        // Get data from the server
        let url = NSURL(string: "https://guarded-hamlet-96865.herokuapp.com/home")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
        }
        
        task.resume();
        

        drawChart();
        

    }

 
    // draws a line/bar chart with the data pulled from the server
    func drawChart() {
        
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 115, 320.0, 30))
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        
        // Bar Chart
        /*
         ChartLabel.text = "Bar Chart"
         
         let barChart = PNBarChart(frame: CGRectMake(0, 150.0, 320.0, 200.0))
         barChart.backgroundColor = UIColor.clearColor()
         
         barChart.animationType = .Waterfall
         
         
         barChart.labelMarginTop = 5.0
         barChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
         barChart.yValues = [1,24,12,18,30,10,21]
         barChart.strokeChart()
         
         barChart.delegate = self
         
         view.addSubview(ChartLabel)
         view.addSubview(barChart)
         
         title = "Bar Chart"
         */
        
        // Line Chart
        ChartLabel.text = "Line Chart"
        
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(10, 150.0, 300, 200.0))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
        lineChart.showCoordinateAxis = true
        lineChart.delegate = self
        
        // Line Chart Nr.1
        var data01Array: [CGFloat] = [60.1, 160.1, 126.4, 262.2, 186.2, 127.2, 176.2]
        let data01:PNLineChartData = PNLineChartData()
        data01.color = PNGreenColor
        data01.itemCount = data01Array.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            let yValue:CGFloat = data01Array[index]
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        
        view.addSubview(lineChart)
        view.addSubview(ChartLabel)
        title = "Line Chart"
        
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

