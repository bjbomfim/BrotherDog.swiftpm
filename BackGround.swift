//
//  BackGround.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 19/04/22.
//

import Foundation
import SpriteKit

class BackGround: SKSpriteNode{
    var texturesBackground:[SKTexture]
    
    init(size: CGSize) {

        self.texturesBackground = ["Normal", "Escurecendo", "Escurecendo2", "Chovendo"].map{
            SKTexture(imageNamed: "back\($0)")
        }
        
        super.init(texture: self.texturesBackground[0], color: .clear, size: texturesBackground[0].size())
        self.name = "back"
        self.zPosition = -2
        self.size = CGSize(width: (texturesBackground[0].size().width / Tamanho.W * size.width), height: (texturesBackground[0].size().width / Tamanho.W * size.width) * (texturesBackground[0].size().height/texturesBackground[0].size().width))
    }
    
    func starRaning(backCeu: Borders, backGrama: Borders){
        let textures:[SKTexture] = Array(self.texturesBackground[1...3])
        let action = SKAction.animate(with: textures, timePerFrame: 1)
        backCeu.raining()
        backGrama.raining()
        self.run(action)
    }
    
    func endRaining(backCeu: Borders, backGrama: Borders){
        let textures:[SKTexture] = [self.texturesBackground[2],self.texturesBackground[1],self.texturesBackground[0]]
        let action = SKAction.animate(with: textures, timePerFrame: 1)
        backCeu.stopRaining()
        backGrama.stopRaining()
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
