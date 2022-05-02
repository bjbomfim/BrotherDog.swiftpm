//
//  Borders.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 22/04/22.
//

import Foundation
import SpriteKit


class Borders: SKSpriteNode{
    
    var texturesBorders:[SKTexture]
    
    init(textures:[SKTexture]){
        
        self.texturesBorders = textures
        
        super.init(texture: self.texturesBorders[0], color: .clear, size: self.texturesBorders[0].size())
        self.zPosition = -2
    }
    
    func raining(){
        let textures:[SKTexture] = Array(self.texturesBorders[1...3])
        let action = SKAction.animate(with: textures, timePerFrame: 1)
        self.run(action)
    }
    
    func stopRaining(){
        let textures:[SKTexture] = [self.texturesBorders[2],self.texturesBorders[1],self.texturesBorders[0]]
        let action = SKAction.animate(with: textures, timePerFrame: 1)
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
