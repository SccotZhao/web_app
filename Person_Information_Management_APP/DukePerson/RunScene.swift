//
//  RunScene.swift
//  DukePerson
//
//  Created by Zhiyong Zhao on 10/15/17.
//  Copyright © 2017 Zhiyong Zhao. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class RunScene: SKScene {
    var runFrames : [SKTexture]?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = UIColor.white
        
        var frames : [SKTexture] = []
        
        let runAtlas = SKTextureAtlas(named : "Run")
        for index in 1...6{
            let textureName = "run_\(index)"
            let texture = runAtlas.textureNamed(textureName)
            frames.append(texture)
        }
        
        self.runFrames = frames
    }
    
    
    func runZhiyong(){
        let texture = self.runFrames![0]
        let jog = SKSpriteNode(texture : texture)
        
        jog.size = CGSize(width : 140, height : 140)
        
        
        let randomNumber = GKRandomDistribution(lowestValue: 50, highestValue: Int(self.frame.size.height))
        let yPosition = CGFloat(randomNumber.nextInt())
        
        let rightToLeft = arc4random() % 2 == 0
        let xPosition = rightToLeft ? self.frame.size.width + jog.size.width / 2 : -jog.size.width/2
        
        jog.position = CGPoint(x : xPosition, y : yPosition)
        
        if rightToLeft{
            jog.xScale = -1
        }
        
        self.addChild(jog)
        jog.run(SKAction.repeatForever(SKAction.animate(with: self.runFrames!, timePerFrame: 0.05, resize: false, restore: true)))
        
        var rangeToCover = self.frame.size.width + jog.size.width
        
        if rightToLeft{
            rangeToCover *= -1
        }
        
        let time = TimeInterval(abs(rangeToCover / 140))
        
        let moveAction = SKAction.moveBy(x: rangeToCover, y: 0, duration: time)
        
        let removeAction = SKAction.run{
            jog.removeAllActions()
            jog.removeFromParent()
        }
        
        let allAction = SKAction.sequence([moveAction, removeAction])
        
        jog.run(allAction)
    }
    
}
