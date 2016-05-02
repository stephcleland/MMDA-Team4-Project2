//
//  AddActivityViewController.swift
//  MMDA-Project2
//
//
//  Written by Stephanie Cleland & Nate Winters on 4/3/16.
//  Modified on: 5/2/16
//  Copyright © 2016 Stephanie Cleland & Nate Winters. All rights reserved.


import UIKit

class AddActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var motionsTrackLabel: UILabel!
    var activityName: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enterNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterNameField: UITextField!
    var tableData: [String] = ["Shoulder Flexion", "Shoulder Horizontal Adduction", "Elbow Supination", "Elbow Pronation"]
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20.0)
        motionsTrackLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        enterNameField.font = UIFont(name: "ArialRoundedMTBold", size: 16.0)
        enterNameLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17.0)
        doneButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 16.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func enter1Pressed(sender: AnyObject) {
        enterNameField.resignFirstResponder()
        activityName = enterNameField.text
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
    
        cell.textLabel!.text = self.tableData[indexPath.row]
        cell.textLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 16.0)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        
    
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        let newActivity = Activity()
        newActivity.changeName(enterNameField.text!)
        let cells = self.tableView.visibleCells
        let vals = self.tableView.indexPathsForSelectedRows
        if ((vals) != nil) {
            for val in vals! {
                newActivity.addMotion(cells[val.row].textLabel!.text!)
            }
        }
        if (enterNameField.text! != "") {
            activities.append(newActivity)
        }
        
    }
    

}
