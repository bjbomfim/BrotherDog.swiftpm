//
//  FinalScene.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 22/04/22.
//

import Foundation
import SpriteKit

class FinalScene: SKScene{
    
    var backGround: SKSpriteNode = SKSpriteNode(imageNamed: "Final")
    
    var textures = ["china", "china2", "china3"].map{
        SKTexture(imageNamed: "Dog\($0)")
    }
    
    var harpa: SKSpriteNode = {
        var textures = ["china", "china2", "china3"].map{
            SKTexture(imageNamed: "\($0)")
        }
        var node = SKSpriteNode(texture: textures[0])
        node.position = CGPoint(x: 0, y: 0)
        return node
    }()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let music: SKAudioNode = SKAudioNode(fileNamed: "MauiInicio")
        self.addChild(music)
        self.addChild(backGround)
        self.addChild(harpa)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var textures = ["china", "china2", "china3"].map{
            SKTexture(imageNamed: "\($0)")
        }
        var textures2 = ["china3", "china2", "china"].map{
            SKTexture(imageNamed: "\($0)")
        }
        
        harpa.run(SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.1), SKAction.animate(with: textures2, timePerFrame: 0.1) ] ))
//        let scene = GameScene()
//        scene.size = CGSize(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
//        scene.scaleMode = .aspectFill
//        self.view?.presentScene(scene,transition:SKTransition.moveIn(with:.right,duration:1))
    }
}
