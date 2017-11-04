//
//  personDetailTableViewController.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/15/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import UIKit

import MobileCoreServices

class personDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var language: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var hobby: UITextField!
    @IBOutlet weak var degree: UITextField!
    @IBOutlet weak var from: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var pictureButton: UIButton!
    
    @IBOutlet weak var flipButton: UIButton!
    var person : DukePerson?
    
    //MARK : imagePicker delegate calls
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let im = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismiss(animated: true) {
            let type = info[UIImagePickerControllerMediaType] as? String
            if type != nil {
                switch type! {
                case kUTTypeImage as NSString as String:
                    if im != nil {
                        self.imageView.image = im
                        self.imageView.contentMode = .scaleAspectFit
                    }
                default:break
                }
            }
        }
    }
    
    //take picture
    @objc func takePicture(_ sender: Any) {
        let cam = UIImagePickerControllerSourceType.camera
        let ok = UIImagePickerController.isSourceTypeAvailable(cam)
        if (!ok) {
            print("no camera")
            return
        }
        let desiredType = kUTTypeImage as NSString as String
        let arr = UIImagePickerController.availableMediaTypes(for: cam)
        print(arr!)
        if arr?.index(of: desiredType) == nil {
            print("no capture")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.mediaTypes = [desiredType]
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Person"
        
        imageView.image = UIImage(named : (person?.avatar)!)
        
        firstName.text = person?.firstName
        firstName.delegate = self
        
        lastName.text = person?.lastName
        lastName.delegate = self
        
        language.text = person?.language.description
        language.delegate = self
        
        hobby.text = person?.hobbies.description
        hobby.delegate = self
        
        degree.text = person?.degree
        degree.delegate = self
        
        from.text = person?.whereFrom
        from.delegate = self
        
        role.text = person?.role.rawValue
        role.delegate = self
        
        gender.text = person?.gender.rawValue
        gender.delegate = self
        
        pictureButton.addTarget(self, action: #selector(personDetailTableViewController.takePicture(_:)), for: .touchUpInside)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK : - UITableVIewDelegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 && indexPath.row == 0{
            return nil
        } else {
            return indexPath
        }
    }
 

}


// used to remove the keyboard when hit return on the keyboard
extension personDetailTableViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
}

extension personDetailTableViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        gender.resignFirstResponder()
        role.resignFirstResponder()
        role.resignFirstResponder()
        from.resignFirstResponder()
        degree.resignFirstResponder()
        hobby.resignFirstResponder()
        language.resignFirstResponder()
    }
}
