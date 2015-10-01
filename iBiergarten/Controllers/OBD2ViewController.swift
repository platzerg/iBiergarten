//
//  OBD2ViewController.swift
//  iBiergarten
//
//  Created by platzerworld on 23.02.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit

class OBD2ViewController: UIViewController {

    @IBOutlet weak var obd2Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func pressed1(sender: UIButton) {
        print("pressed1")
        self.obd2Label?.text = "pressed1"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
