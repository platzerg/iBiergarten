//
//  IBeaconViewController.swift
//  iBiergarten
//
//  Created by platzerworld on 23.02.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit

class IBeaconViewController: UIViewController {

    
    @IBOutlet weak var ibeaconLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pressed2(sender: UIButton) {
         println("pressed2")
        self.ibeaconLabel?.text = "pressed2"
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
