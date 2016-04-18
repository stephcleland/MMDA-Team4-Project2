//
//  ByDateViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

// EPCalendar from: https://github.com/ipraba/EPCalendarPicker

class ByDateViewController: UIViewController, EPCalendarPickerDelegate, PNChartDelegate{

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewCalButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textViewDetail: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        drawBarChart()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func viewCal(sender: AnyObject) {
        super.viewDidAppear(true)
        let calendarPicker = EPCalendarPicker(startYear: 2015, endYear: 2017, multiSelection: false, selectedDates: nil)
        calendarPicker.calendarDelegate = self
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError) {
        textViewDetail.text = "User cancelled selection"
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        //formatter.dateStyle = NSDateFormatterStyle.LongStyle
        //formatter.timeStyle = .NoStyle
        let dateString = formatter.stringFromDate(date)
        textViewDetail.text = "Showing data for " + dateString
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate]) {
        textViewDetail.text = "Showing data for: \n\(dates)"
    }
    
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
