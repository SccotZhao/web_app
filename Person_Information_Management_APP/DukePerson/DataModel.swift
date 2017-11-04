//
//  DataModel.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/14/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import Foundation
import UIKit


enum Gender : String {
    case Male = "Male"
    case Female = "Female"
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
    var degree = "NO"
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
}

protocol BlueDevil {
    var hobbies : [String] { get }
    var role : DukeRole { get }
}


//Here define the enum for the languages that are probably useful
enum ProgrammingLanguage : String{
    case Cplusplus  = "C++"
    case Java = "Java"
    case C = "C"
    case Swift = "Swift"
    case Python = "Python"
    case Scala = "Scala"
    case SQL = "SQL"
    case MATLAB = "MATLAB"
}

struct InfoKey{
    static let firstNameK = "firstName"
    static let lastNameK = "lastName"
    static let hobbyK = "hobby"
    static let roleK = "role"
    static let languageK = "language"
    static let avatarK = "avatar"
    static let degreeK = "degree"
    static let fromK = "from"
    static let genderK = "gender"
}

class DukePerson : Person, NSCoding, CustomStringConvertible, BlueDevil{
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("personInfoFile")
    
    

    
    
    //this the bobbies of the DukePerson
    var hobbyArray : [String]
    //the role of the DukePerson at Duke
    var roleAtDuke : DukeRole
    
    //the programming language should be an implicit unwrapped optional
    //of Strings
    var language: String!
    
    //the degree of the person is Optional
    //var degree : String!
    
    var avatar : String!
    
    //initial boobyarray with the implicit initializer of the superclass
    init(hobbyArray : [String], role : DukeRole) {
        self.hobbyArray = hobbyArray
        self.roleAtDuke = role
        super.init()
    }
    
    
    
    init(firstName : String, lastName : String, whereFrom :String, gender : Gender, hobbyArray : [String], role : DukeRole, avatar : String, degree : String, language : String) {
        self.hobbyArray = hobbyArray
        self.roleAtDuke = role
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.whereFrom = whereFrom
        self.gender = gender
        self.avatar = avatar
        self.degree = degree
        self.language = language
        
    }

    var description: String{
        //information is used to describe the person
        //used for printint
        var information : String = self.firstName + " " + self.lastName + " is from " + self.whereFrom
        information += " and is a "
        //append the role to the person
        information += self.roleAtDuke.rawValue
        information += ". He is proficient in "
        
        //append the programmingl anguage to the DukePerson
        information += appendLanguage()
        
        information += ". When not in class, " + self.firstName + " enjoys "
        //using the method of the class to append hobbies
        information += appendHobby()
        
        return information
    }
    
    //append the language to the person
    func appendLanguage() ->String{
        var information = ""
        if language != nil {
                information += language
        }
        return information
    }
    
    //append hobbies to the string information
    func appendHobby() -> String{
        var information : String = ""
        var index = 0
        let len = self.hobbyArray.count
        while index < len{
            switch index {
            case len - 1:
                information += hobbyArray[index] + "."
            case len - 2:
                information += hobbyArray[index] + "  and "
            default:
                information += hobbyArray[index] + " , "
            }
            
            index += 1
        }
        return information
    }
    
    var hobbies: [String]{
        return self.hobbyArray
    }
    
    var role: DukeRole{
        return roleAtDuke
    }
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: InfoKey.firstNameK)
        aCoder.encode(lastName, forKey: InfoKey.lastNameK)
        aCoder.encode(language, forKey: InfoKey.lastNameK)
        aCoder.encode(degree, forKey: InfoKey.degreeK)
        aCoder.encode(role, forKey: InfoKey.roleK)
        aCoder.encode(whereFrom, forKey: InfoKey.fromK)
        aCoder.encode(avatar, forKey: InfoKey.avatarK)
        aCoder.encode(gender, forKey: InfoKey.genderK)
        aCoder.encode(hobbies, forKey: InfoKey.hobbyK)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let firstName = aDecoder.decodeObject(forKey: InfoKey.firstNameK) as! String
        
        let lastName = aDecoder.decodeObject(forKey: InfoKey.lastNameK) as! String
        
        let whereFrom = aDecoder.decodeObject(forKey: InfoKey.fromK) as! String
        
        let genderS = aDecoder.decodeObject(forKey: InfoKey.genderK) as! String
        var gender : Gender
        if genderS == "Male"{
            gender = .Male
        }else{
            gender = .Female
        }
        
        let hobby = aDecoder.decodeObject(forKey: InfoKey.hobbyK) as! String
        var hobbies : [String] = []
        hobbies.append(hobby)
        
        let roleS = aDecoder.decodeObject(forKey: InfoKey.roleK) as! String
        
        var role : DukeRole
        if roleS == "Professor"{
            role = .Professor
        }else if roleS == "TA"{
            role = .TA
        }else{
            role = .Student
        }
        
        var avatar = "0.jpg"
        
        let degree = aDecoder.decodeObject(forKey: InfoKey.degreeK) as! String
        let language = aDecoder.decodeObject(forKey: InfoKey.languageK) as! String

        
        self.init(firstName: firstName, lastName: lastName, whereFrom: whereFrom, gender: gender, hobbyArray: hobbies, role: role, avatar: avatar, degree: degree, language: language)
    }
    

}
