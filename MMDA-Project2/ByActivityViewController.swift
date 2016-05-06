//
//  ByActivityViewController.swift
//  MMDA-Project2
//
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on: 5/6/16
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.
//
// Line chart and bar graph from: https://github.com/kevinzhow/PNChart-Swift

import UIKit

class ByActivityViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, PNChartDelegate {

    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var viewBy: UILabel!
    @IBOutlet weak var chartLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var Duration: UILabel!
    @IBOutlet weak var Assist: UILabel!
    @IBOutlet weak var Cues: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var assistLabel: UILabel!
    @IBOutlet weak var cuesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var myPicker: UIPickerView!
    var pickerData:[String] = []
    var currActivity = "Bowling"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // setting up UI
        backButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        viewBy.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 19.0)
        cuesLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        assistLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        durationLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        Cues.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        Assist.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        Duration.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        averageLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        chartLabel.font = UIFont(name: "ArialRoundedMTBold", size: 15.0)
        chartLabel.textAlignment = .Center

        
        myPicker.delegate = self
        myPicker.dataSource = self
        for activity in activities {
            pickerData.append(activity.name)
        }
        
        currActivity = pickerData[0]
        viewBy.text = "Data for " + currActivity + ":"
        displayData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func displayData() {
        
        var count:Float = 0.0
        var cues:Float = 0.0
        var assist:Float = 0.0
        var duration:Float = 0.0
        var numCompletions:Float = 0.0
        for i in 0 ..< serverData.count {
            let activity = serverData[i]["activity"] as? NSString as! String
            if (activity == currActivity) {
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
        
        if (count != 0) {
            cues = cues / count
            assist = assist / count
            numCompletions = numCompletions / count
            duration = duration / count
        }
        
        Cues.text = String(cues*100) + "%"
        Assist.text = String(assist*100) + "%"
        Duration.text = String(Int(duration)) + " min"
        
        drawLineGraph()
        
        
    }
    
    // draw the line graph to display the data associated with the activity
    func drawLineGraph() {
        
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 115, 320.0, 30))
        
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        ChartLabel.text = "Line Chart"
        
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 312.0, 310, 150.0))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        
        var xlab:[String] = []
        for i in 0 ..< serverData.count {
            // XLABEL FOR DATES
            let temp = serverData[i]["time"] as? NSString
            if (temp != nil) {
                let time = temp!.doubleValue / 1000
                let timeDate = NSDate(timeIntervalSince1970: time)
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                let dateString = formatter.stringFromDate(timeDate)
                let temp = serverData[i]["activity"] as? NSString
                let activity = temp as! String
                if (!xlab.contains(dateString) && activity == currActivity) {
                    xlab.append(dateString)
                }
            }
        }

        var yDurations = [CGFloat](count: xlab.count, repeatedValue: CGFloat(0))

        for i in 0 ..< serverData.count {
            //Activity
            let act = serverData[i]["activity"] as? NSString
            let activity = act as! String
            //Dates
            var dateString:String = ""
            var temp = serverData[i]["time"] as? NSString
            if (temp != nil) {
                let time = temp!.doubleValue / 1000
                let timeDate = NSDate(timeIntervalSince1970: time)
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                dateString = formatter.stringFromDate(timeDate)
            }
            temp = serverData[i]["duration"] as? NSString
            if (temp != nil && dateString != "") {
                let duration = temp!.intValue
                let temp2 = xlab.indexOf(dateString)
                if (temp2 != nil && activity == currActivity) {
                    let index = temp2!
                    yDurations[index] = yDurations[index] + CGFloat(duration)
                }
            }
        }

        lineChart.xLabels = xlab
        lineChart.showCoordinateAxis = true
        lineChart.delegate = self
        var data01Array: [CGFloat] = yDurations
        let data01:PNLineChartData = PNLineChartData()
        data01.color = PNGreenColor
        data01.itemCount = data01Array.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            let yValue:CGFloat = data01Array[index]
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        lineChart.chartData = [data01]//, data02, data03]
        lineChart.strokeChart()
        lineChart.tag = 13
        view.viewWithTag(13)?.removeFromSuperview()
        view.addSubview(lineChart)

    }

    
    
    // all the picker view functions are for the formatting and functionality of the activity
    // picker view
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currActivity = pickerData[row]
        viewBy.text = "Data for " + currActivity + ":"
        
        // display the data for the newly selected activity
        displayData()

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
        return 35.0
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
