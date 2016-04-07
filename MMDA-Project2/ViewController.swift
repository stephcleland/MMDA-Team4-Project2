//
//  ViewController.swift
//  MMDA-Project2
//
//  Created by Stephanie Cleland on 4/3/16.
//  Copyright © 2016 Stephanie Cleland. All rights reserved.
//

import UIKit

var activities = [Activity]()
var currentlySelectedActivity = ""

class ViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var byDateButton: UIButton!
    @IBOutlet weak var byActivityButton: UIButton!
    @IBOutlet weak var beginSessionButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.text = "Alexa"
        nameLabel.textAlignment = .Center
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

