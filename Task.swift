//
//  Task.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 14/04/22.
//

import Foundation
import SpriteKit

protocol Actable {
    func act(_ location: CGPoint)
}

class Task:SKSpriteNode, Actable {
    let taskEnum:TasksNames
    var taskIsConclude:Bool = false
    var ItsRaning = false
    var textureUmbruelaOpen:SKTexture? = nil
    var sizeFrame:CGSize
    
    init(name: TasksNames, _ textureumbruelaOpen: SKTexture?, sizeFrame: CGSize) {
        
        self.taskEnum = name
        let strName = name.rawValue
        let texture = SKTexture(imageNamed: strName)
        let size = texture.size()
        self.sizeFrame = sizeFrame
        super.init(texture: texture, color: .clear, size: size)
        self.name = strName
        if let textureUmbruelaOpen = textureumbruelaOpen {
            self.textureUmbruelaOpen = textureUmbruelaOpen
        }
        self.size = CGSize(width: (texture.size().width / Tamanho.W * self.sizeFrame.width), height: (texture.size().width / Tamanho.W * self.sizeFrame.width) * (texture.size().height/texture.size().width))
    }
    
    private func checkTaskComplete(_ location: CGPoint) {
        let nodes = parent?.nodes(at: location)
        var lastNode:SKNode?
        for node in nodes ?? []  {
            if let lastNode = lastNode {
                if node.intersects(lastNode) {
                    guard let node1 = (node as? Task) ?? (node as? Dog) else{return}
                    guard let node2 = (lastNode as? Task) ?? (lastNode as? Dog) else{return}
                    switch(node1.name!, node2.name!) {
                    case("Lixeira", "coco"):
                        self.taskIsConclude = true
                    case("Dog", "Bolinha"):
                        self.taskIsConclude = true
                    case("Dog", "Petisco"):
                        self.taskIsConclude = true
                    case("Dog", "GuardaChuvaFechado"):
                        self.taskIsConclude = true
                        self.guardaChuvaAbre()
                    default:
                        return
                    }
                }
            }
            lastNode = node
        }
        
    }
    
    func backPosition(positioX x: CGFloat, y: CGFloat){
        self.run(SKAction.move(to: CGPoint(x: x, y: y), duration: 0.5))
    }
    
    func move(_ location: CGPoint){
        if self.name != "Lixeira"{
            self.position = location
            checkTaskComplete(location)
        }
    }
    
    func act(_ location: CGPoint){
        if self.name == "GuardaChuvaFechado" && ItsRaning{
            move(location)
        }
        else if self.name != "GuardaChuvaFechado"{move(location)}
    }
    
    func guardaChuvaAbre(){
        if self.name == "GuardaChuvaFechado" && taskIsConclude{
            let textures:[SKTexture] = [textureUmbruelaOpen!]
            self.run(SKAction.sequence([SKAction.animate(with: textures, timePerFrame: 0.2), SKAction.wait(forDuration: 0.1)]))
            self.size = CGSize(width: (textureUmbruelaOpen!.size().width / Tamanho.W * self.sizeFrame.width), height: (textureUmbruelaOpen!.size().width / Tamanho.W * self.sizeFrame.width) * (textureUmbruelaOpen!.size().height/textureUmbruelaOpen!.size().width))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
