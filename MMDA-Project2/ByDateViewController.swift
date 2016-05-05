//
//  ByDateViewController.swift
//  MMDA-Project2
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on: 5/4/16
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.
//
// Line chart and bar graph from: https://github.com/kevinzhow/PNChart-Swift
// EPCalendar from: https://github.com/ipraba/EPCalendarPicker


import UIKit


class ByDateViewController: UIViewController, EPCalendarPickerDelegate, PNChartDelegate{

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewCalButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textViewDetail: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        viewCalButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 21.0)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 19.0)
        textViewDetail.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        
        
        drawLineGraph()
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
    
    // draw the bar chart to display the data associated with the date
    func drawBarChart () {
            let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 300, 320.0, 30))
            
            ChartLabel.textColor = PNGreenColor
            ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
            ChartLabel.textAlignment = NSTextAlignment.Center
        
             ChartLabel.text = "Bar Chart"
             
             let barChart = PNBarChart(frame: CGRectMake(0, 335, 320.0, 200.0))
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
        textViewDetail.text = "User cancelled selection"
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.stringFromDate(date)
        textViewDetail.text = "Showing data for " + dateString
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate]) {
        textViewDetail.text = "Showing data for: \n\(dates)"
    }
    
    // functions that determine what to do if a bar or a point in the graph/chart is selected
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func userClickedOnBarChartIndex(barIndex: Int)
    {
        print("Click  on bar \(barIndex)")
    }
    

}
