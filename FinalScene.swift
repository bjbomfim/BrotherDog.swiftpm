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
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let music: SKAudioNode = SKAudioNode(fileNamed: "MauiInicio")
        self.addChild(music)
        self.addChild(backGround)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let scene = GameScene()
        scene.size = CGSize(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene,transition:SKTransition.moveIn(with:.right,duration:1))
    }
}
