//
//  ByDateViewController.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on: 5/6/16
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.
//
// Line chart and bar graph from: https://github.com/kevinzhow/PNChart-Swift
// EPCalendar from: https://github.com/ipraba/EPCalendarPicker


import UIKit



class ByDateViewController: UIViewController, EPCalendarPickerDelegate, PNChartDelegate{
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logo: UIButton!
    @IBOutlet weak var viewCalButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textViewDetail: UILabel!
    @IBOutlet weak var Cues: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var assistLabel: UILabel!
    @IBOutlet weak var cuesLabel: UILabel!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var Assist: UILabel!
    var dateString: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up UI
        backButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        viewCalButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 21.0)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 19.0)
        textViewDetail.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        cuesLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        assistLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        durationLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        Cues.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        Assist.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        Duration.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        averageLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        chartLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        logo.setBackgroundImage(UIImage(named:"logo1.png")!, forState: .Normal)
        logo.setTitle("", forState: .Normal)
        chartLabel.textAlignment = .Center
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        let date = NSDate()
        dateString = formatter.stringFromDate(date)
        textViewDetail.text = "Showing data for " + dateString

        displayData()
        
    }
    
    // show the calendar to allow the user to pick a specific date
    @IBAction func viewCal(sender: AnyObject) {
        super.viewDidAppear(true)
        let calendarPicker = EPCalendarPicker(startYear: 2015, endYear: 2017, multiSelection: false, selectedDates: nil)
        calendarPicker.calendarDelegate = self
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // display the data for the specific date selected
    func displayData() {
        
        var count:Float = 0.0
        var cues:Float = 0.0
        var assist:Float = 0.0
        var duration:Float = 0.0
        var numCompletions:Float = 0.0
        for i in 0 ..< serverData.count {
            
            let temp = serverData[i]["time"] as? NSString
            if (temp != nil) {
                let time = temp!.doubleValue / 1000
                let timeDate = NSDate(timeIntervalSince1970: time)
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                let date = formatter.stringFromDate(timeDate)
                if (date == dateString) {
                    count += 1
                    var temp = (serverData[i]["cues"] as? NSString)!.floatValue
                    cues = cues + temp
                    temp = (serverData[i]["assist"] as? NSString)!.floatValue
                    assist = assist + (temp)
                    temp = (serverData[i]["count"] as? NSString)!.floatValue
                    numCompletions = numCompletions + (temp)
                    temp = (serverData[i]["duration"] as? NSString)!.floatValue
                    duration = duration + (temp)
                    
                }

            }
            
        }
        
        if (count != 0) {
            cues = cues / count
            assist = assist / count
            numCompletions = numCompletions / count
        }
        
        Cues.text = String(cues*100) + "%"
        Assist.text = String(assist*100) + "%"
        Duration.text = String(Int(duration)) + " min"
        
        drawBarChart()
        
        
    }
    
    
    // draw the bar chart to display the data associated with the date
    func drawBarChart () {
            let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 300, 320.0, 30))
            
            ChartLabel.textColor = PNGreenColor
            ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
            ChartLabel.textAlignment = NSTextAlignment.Center
        
             ChartLabel.text = "Bar Chart"
             
             let barChart = PNBarChart(frame: CGRectMake(0, 310.0, 320, 150.0))
             barChart.backgroundColor = UIColor.clearColor()
             
             barChart.animationType = .Waterfall
        
        
            var date = ""
            var xlab:[String] = []
            for i in 0 ..< serverData.count {
                let activity = serverData[i]["activity"] as? NSString as! String
                let temp = serverData[i]["time"] as? NSString
                if (temp != nil) {
                    let time = temp!.doubleValue / 1000
                    let timeDate = NSDate(timeIntervalSince1970: time)
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "MM-dd-yyyy"
                    date = formatter.stringFromDate(timeDate)
                    if (!xlab.contains(activity) && activity != "" && date == dateString) {
                        xlab.append(activity)
                    }
                }
            }
        
            var yvals = [CGFloat](count: xlab.count, repeatedValue: CGFloat(0))
            for i in 0 ..< serverData.count {
                let activity = serverData[i]["activity"] as? NSString as! String
                if (activity != "") {
                    let index = xlab.indexOf(activity)
                    let temp = (serverData[i]["count"] as? NSString)
                    if (temp != nil && date == dateString) {
                        yvals[index!] += CGFloat(temp!.floatValue)
                    }
                }
            }
            
            for i in 0 ..< xlab.count {
                xlab[i] = xlab[i] + " (" + String(yvals[i]) + ")"
            }
        
            barChart.labelMarginTop = 5.0

        if (xlab.count > 0) {

                barChart.xLabels = xlab
                if (yvals.minElement() == 0 && yvals.maxElement() == 0) {
                    yvals = [CGFloat](count: yvals.count, repeatedValue: CGFloat(1))
                }
                barChart.yValues = yvals
                barChart.strokeChart()
                 
                barChart.delegate = self
                barChart.tag = 17
                view.viewWithTag(17)?.removeFromSuperview()
                view.addSubview(barChart)
        }
        
        
            
    }
    
    // draw the line graph to display the data associated with the date
    func drawLineGraph() {
        
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 115, 320.0, 30))
        
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        ChartLabel.text = "Line Chart"
        
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 150.0, 320, 200.0))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
        lineChart.showCoordinateAxis = true
        lineChart.delegate = self
        
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
    
    
    // functions required for the functionality of the calendar picker
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError) {
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        dateString = formatter.stringFromDate(date)
        textViewDetail.text = "Showing data for " + dateString
        displayData()

        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate]) {
        textViewDetail.text = "Showing data for: \n\(dates)"
    }
    
    // functions that determine what to do if a bar or a point in the graph/chart is selected
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {

    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
    }
    
    func userClickedOnBarChartIndex(barIndex: Int)
    {
    }
    

}
