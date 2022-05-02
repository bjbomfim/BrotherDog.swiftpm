//
//  File.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 07/04/22.
//

import Foundation
import SpriteKit
import SwiftUI


class Dog:SKSpriteNode, Actable{
    
    let texturesDog:[SKTexture]
    var taskDogIsConclued:Bool = false
    
    var lastPetPosition:[CGPoint] = []
    var swipe = 0
    
    init(size: CGSize) {
        
        self.texturesDog = ["OlhoFechado", "Normal", "Animado1", "Animado2", "Triste", "OlhandoLado", "Espantado"].map{
            SKTexture(imageNamed: "Dog\($0)")
        }
        
        super.init(texture: self.texturesDog[1], color: .clear, size: self.texturesDog[1].size())
        
        
        self.name = "Dog"
        self.animateCloseEyes()
        self.size = CGSize(width: (texturesDog[1].size().width / Tamanho.W * size.width), height: (texturesDog[1].size().width / Tamanho.W * size.width) * (texturesDog[1].size().height/texturesDog[1].size().width))
    }
    
    func act(_ location: CGPoint) {
        if self.swipe > 3 && !self.taskDogIsConclued{
            self.taskDogIsConclued = true
            self.run(SKAction.playSoundFileNamed("Latido", waitForCompletion: true))
        }
        else if self.lastPetPosition.count == 2 && !self.taskDogIsConclued{
            if ((self.lastPetPosition[0].x < self.lastPetPosition[1].x) && (self.lastPetPosition[1].x > location.x)) || ((self.lastPetPosition[0].y < self.lastPetPosition[1].y) && (self.lastPetPosition[1].y > location.y)) || ((self.lastPetPosition[0].x > self.lastPetPosition[1].x) && (self.lastPetPosition[1].x < location.x)) || ((self.lastPetPosition[0].y > self.lastPetPosition[1].y) && (self.lastPetPosition[1].y < location.y)){
                self.swipe += 1
                self.lastPetPosition.remove(at: 0)
                self.lastPetPosition.append(location)
            }
        }
        else if self.lastPetPosition.count < 2 && !self.taskDogIsConclued{
            self.lastPetPosition.append(location)
        }
    }
    
    func animateDog(node: SKNode?){
        if let node = node as? Task {
            if node.name != "coco"{
                happyDog()
            }
            else if node.name == "coco"{
                sadDog()
            }
        }
        else if let _ = node as? Dog{
            happyDog()
        }
    }
    
    private func happyDog(){
        let textures:[SKTexture] = Array(self.texturesDog[2...3])
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.2), SKAction.wait(forDuration: 0.1)])))
    }
    
    func sadDog(){
        let textures:[SKTexture] = [self.texturesDog[4]]
        self.run(SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.2), SKAction.wait(forDuration: 0.1)]))
    }
    
    func animateCloseEyes(){
        let textures:[SKTexture] = Array(self.texturesDog[0...1])
        let action = SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.4), SKAction.wait(forDuration: 8)])
        self.run(SKAction.repeatForever(action))
    }
    
    func swipedDog(_ movedTouch: CGPoint){
        if self.lastPetPosition.isEmpty{
            self.lastPetPosition.append(movedTouch)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
