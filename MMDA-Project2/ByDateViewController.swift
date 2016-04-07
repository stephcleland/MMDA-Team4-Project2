//
//  ByDateViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

// EPCalendar from: https://github.com/ipraba/EPCalendarPicker

class ByDateViewController: UIViewController, EPCalendarPickerDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var viewCalButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textViewDetail: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
       
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
