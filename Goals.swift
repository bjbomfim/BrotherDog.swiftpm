//
//  File.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 14/04/22.
//

import Foundation
import SpriteKit

class Goals:SKSpriteNode {
    
    let texturePadlocksStar:[SKTexture]
    
    var currentNode:SKLabelNode = SKLabelNode()
    
    var text:String
    
    var frameParent: CGRect = CGRect.zero
    
    var IsShowingMessage = false
    
    let audioTouch = SKAction.playSoundFileNamed("Acerto", waitForCompletion: true)
    let audioErro = SKAction.playSoundFileNamed("Erro", waitForCompletion: true)
    
    var opened = false {
        didSet {
            if opened {
                animateChangeLockUnlock()
            }
        }
    }
    
    init(name: String, size: CGSize, text: String) {
        self.texturePadlocksStar = ["CadeadoFechado", "CadeadoAberto", "Estrela"].map{
            SKTexture(imageNamed: "\($0)")
        }
        self.text = text
        
        super.init(texture: texturePadlocksStar[0], color: .clear, size: texturePadlocksStar[0].size())
        self.name = name
        self.size = CGSize(width: (texturePadlocksStar[0].size().width / Tamanho.W * size.width), height: (texturePadlocksStar[0].size().width / Tamanho.W * size.width) * (texturePadlocksStar[0].size().height/texturePadlocksStar[0].size().width))
    }
    
    func animateChangeLockUnlock(){
        self.run(audioTouch)
        let textures:[SKTexture] = Array(self.texturePadlocksStar[1...2])
        let action = SKAction.animate(with: textures, timePerFrame: 1)
        self.run(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createMessage(){
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: text.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        
        attrString.addAttributes(
            [NSAttributedString.Key.foregroundColor : UIColor(red: 0.2917450368, green: 0.1159529462, blue: 0, alpha: 1),
             NSAttributedString.Key.font : UIFont(name: "Futura-Medium", size: 25)!
            ], range: range)
        
        currentNode = SKLabelNode(attributedText: attrString)
        
        currentNode.name = "phrase"
        currentNode.position = CGPoint(x: 0, y: self.frameParent.maxY/2)
        currentNode.numberOfLines = 8
        currentNode.lineBreakMode = .byTruncatingTail
        currentNode.preferredMaxLayoutWidth = self.frameParent.width/1.2
        currentNode.horizontalAlignmentMode = .center
        currentNode.verticalAlignmentMode = .center
        currentNode.alpha = 0
        
        let sequenceAction = SKAction.sequence([SKAction.wait(forDuration: 0.2),
                                                SKAction.fadeIn(withDuration: 0.2)])
        currentNode.run(sequenceAction)
        currentNode.zPosition = 2
    }
    
    private func dissapearMessage(){
        let action = SKAction.fadeOut(withDuration: 0.2)
        currentNode.run(action)
    }
    
    private func apearMessage(){
        let sequenceAction = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeIn(withDuration: 0.5)])
        currentNode.run(sequenceAction)
    }
    
    func apearDissapear(){
        if self.IsShowingMessage{
            self.IsShowingMessage = false
            self.dissapearMessage()
        }
        else if self.opened{
            self.apearMessage()
            self.IsShowingMessage = true
            self.run(audioTouch)
        }
        else{
            self.run(audioErro)
        }
    }
}
