//
//  FlickrViewController.swift
//  iBiergarten
//
//  Created by platzerworld on 12.03.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit

class FlickrViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var interestButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var errorSearchButton: UIButton!
    
    @IBAction func loginButtonTabbed(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
