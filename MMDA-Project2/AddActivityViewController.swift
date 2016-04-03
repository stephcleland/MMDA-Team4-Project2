//
//  AddActivityViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var motionsTrackLabel: UILabel!
    var activityName: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enterNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var enterNameField: UITextField!
    var tableData: [String] = ["Arm", "Leg", "Head", "Toes", "Nose"]
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func enter1Pressed(sender: AnyObject) {
        enterNameField.resignFirstResponder()
        activityName = enterNameField.text
        print(activityName)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count;

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("KJADHJKA")
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
    
        cell.textLabel!.text = self.tableData[indexPath.row]
        print(cell.textLabel!.text)
        
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
        for val in vals! {
            print(cells[val.row].textLabel!.text!)
            newActivity.addMotion(cells[val.row].textLabel!.text!)
        }
        activities.append(newActivity)
        print(activities)
        
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
