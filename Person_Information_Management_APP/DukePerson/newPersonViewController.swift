//
//  newPersonViewController.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/22/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import UIKit

class newPersonViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameFiled: UITextField!
    
    
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var genderField: UITextField!
    
    @IBOutlet weak var roleField: UITextField!
    
    @IBOutlet weak var fromField: UITextField!
    
    @IBOutlet weak var degreeField: UITextField!
    
    
    @IBOutlet weak var hobby: UITextField!
    
    
    @IBOutlet weak var languageField: UITextField!
    
    var person : DukePerson = DukePerson(firstName : "", lastName : "", whereFrom : "", gender : .Male, hobbyArray : [""], role : .Professor, avatar : "0.jpg", degree : "BS", language : "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as! UIBarButtonItem) != self.saveButton{
            return
        }
        
        if (self.firstNameFiled.text != nil){
            self.person.firstName = self.firstNameFiled.text!
        }
        if self.lastNameField.text != nil{
            self.person.lastName = self.lastNameField.text!
        }
        
        if self.fromField.text != nil{
            self.person.whereFrom = self.fromField.text!
        }
        
        if self.degreeField.text != nil{
            self.person.degree = self.degreeField.text!
        }
        
        if self.genderField.text != nil{
            if self.genderField.text! == "Male"{
                self.person.gender = .Male
            }else{
                self.person.gender = .Female
            }
        }
        
        if self.languageField.text != nil{
            self.person.language.append(self.languageField.text!)
        }
        
        if self.hobby.text != nil{
            self.person.hobbyArray.append(self.hobby.text!)
        }
    }
}
