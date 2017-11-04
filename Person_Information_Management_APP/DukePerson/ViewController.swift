//
//  ViewController.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/14/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: SKView!
    
    var runImage : UIImageView!
    
    
    var scene : RunScene?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scene = RunScene(size : CGSize(width : self.sceneView.frame.size.width, height : self.sceneView.frame.size.height))
        
        self.sceneView.presentScene(scene)
    }
    
    
    @IBAction func runNow(_ sender: Any) {
        
        if let scene = self.scene{
            scene.runZhiyong()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

