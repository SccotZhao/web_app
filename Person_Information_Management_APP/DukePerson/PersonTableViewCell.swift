//
//  PersonTableViewCell.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/14/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    
    @IBOutlet weak var personLabel: UILabel!
    
    
    //Mark : DataModel
    
    var person : DukePerson?{
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        personImageView?.image = UIImage(named : (person?.avatar)!)
        personLabel?.text = person?.description
    }
    
}
