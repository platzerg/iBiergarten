//
//  BiergartenDetailViewController.swift
//  iBiergarten
//
//  Created by platzerworld on 28.05.15.
//  Copyright (c) 2015 platzerworld. All rights reserved.
//

import UIKit

protocol BiergartenDetailViewControllerDelegate: class {
    func storeBiergarten(controller: BiergartenDetailViewController, biergarten: BiergartenVO)
}

class BiergartenDetailViewController: UIViewController {
    var biergartenVO:BiergartenVO?

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtStrasse: UITextField!
    @IBOutlet weak var txtPlz: UITextField!
    @IBOutlet weak var txtOrt: UITextField!
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var txtEMail: UITextField!
    @IBOutlet weak var txtTelefon: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var switchFavorit: UISwitch!
    
    weak var delegate: BiergartenDetailViewControllerDelegate!
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        print("saveButtonPressed")
        delegate?.storeBiergarten(self, biergarten: biergartenVO!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtName.text = self.biergartenVO?.name
        self.txtStrasse.text = self.biergartenVO?.strasse
        self.txtPlz.text = self.biergartenVO?.plz
        self.txtOrt.text = self.biergartenVO?.ort
        self.txtUrl.text = self.biergartenVO?.url
        self.txtEMail.text = self.biergartenVO?.email
        self.txtTelefon.text = self.biergartenVO?.telefon
        self.txtDescription.text = self.biergartenVO?.desc
        
        if (self.biergartenVO?.favorit.boolValue != nil){
            self.switchFavorit.on = true
        }else{
            self.switchFavorit.on = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
