//
//  Person.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/14/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import Foundation
import UIKit

class PersonLine{
    var name : String
    var persons : [DukePerson]
    
    init(name : String, persons : [DukePerson]){
        self.name = name
        self.persons = persons
    }
    
    class func personLine() -> [PersonLine]{
        
        return [self.professors(), self.TAs(), self.teams()]
    }
    
    private class func professors() -> PersonLine{
         var professorArray = [DukePerson]()
        
        let ric = DukePerson(firstName: "Ric", lastName: "Telford", whereFrom: "Morrisville, NC",gender: Gender.Male, hobbyArray: ["Biking", "Hiking", "Golf"], role : .Professor, avatar : "ric.jpg", degree : "PhD", language : "Swift, C++")
        professorArray.append(ric);
        return PersonLine(name : "Professor", persons : professorArray)
    }
    
    private class func TAs() -> PersonLine{
        var TAArray = [DukePerson]()
        let gilbert = DukePerson(firstName: "Gilbert", lastName: "Brooks", whereFrom: "Shelby, NC",gender: Gender.Male, hobbyArray: ["working in User Experience", "Product Development"], role :.TA, avatar : "gilbert.jpg", degree : "BS", language : "Swift, Java")
        
        TAArray.append(gilbert)
        
        return PersonLine(name : "TA", persons : TAArray)
    }
    
    private class func teams() -> PersonLine{
        var teamArray = [DukePerson]()
        let zhiyong = DukePerson(firstName: "Zhiyong", lastName: "Zhao", whereFrom: "China",gender: .Male, hobbyArray: ["sing", "swimming", "jogging"], role : .Student, avatar : "me.jpg", degree : "PhD", language : "Java, C++, Python")
        
        let hesong  = DukePerson(firstName: "Hesong", lastName: "Huang", whereFrom: "China",gender: Gender.Male, hobbyArray: ["working in User Experience", "Product Development"], role :.Student, avatar : "hesong.jpg", degree : "MS", language :"Java, C++")
        
        let noah = DukePerson(firstName: "Noah", lastName: "Pritt", whereFrom: "Durham, NC",gender: Gender.Male, hobbyArray: ["working in User Experience", "Product Development"], role :.Student, avatar : "noah.png", degree : "BS", language :  "Java, C++, Swift")
        
        teamArray.append(zhiyong)
        teamArray.append(hesong)
        teamArray.append(noah)
        return PersonLine(name : "Suits", persons : teamArray)
    }
    
    static func savePersonInfo(_ dukePerson: [DukePerson]) -> Bool {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(dukePerson, toFile: DukePerson.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save info")
            return false
        } else {
            return true
        }
    }
    
    static func loadPersonInfo() -> [DukePerson]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: DukePerson.ArchiveURL.path) as? [DukePerson]
    }
    
}
