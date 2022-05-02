//
//  GameScene.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 07/04/22.
//

import Foundation
import SwiftUI
import SpriteKit


class GameScene: SKScene{
    var moveAmtY: CGFloat = 0
    var moveAmtX: CGFloat = 0
    var initialTouch: CGPoint = CGPoint.zero
    var counterDogSwipe:Int = 0
    var touchedNode:SKNode?
    
    lazy var backGround: BackGround = BackGround(size: self.frame.size)
    
    let music: SKAudioNode = SKAudioNode(fileNamed: "MauiLoopString")
    
    lazy var backBordersCeu: Borders = {
        var textureFundoCeu = ["Normal", "Escurecendo", "Escurecendo2", "Chovendo"].map{
            SKTexture(imageNamed: "fundoCeu\($0)")
        }
        let node:Borders = Borders(textures: textureFundoCeu)
        
        self.name = "ceuBorda"
        
        return node
    }()
    
    lazy var arbusto: SKSpriteNode = {
        var texture = SKTexture(imageNamed:"Arbusto")
        
        let node = SKSpriteNode(texture: texture)
        node.zPosition = 1
        node.size = CGSize(width: (texture.size().width / Tamanho.W * size.width), height: (texture.size().width / Tamanho.W * size.width) * (texture.size().height/texture.size().width))
        return node
    }()
    
    lazy var comedouro: SKSpriteNode = {
        var texture = SKTexture(imageNamed:"comedouro")
        
        let node = SKSpriteNode(texture: texture)
        node.zPosition = -1
        node.size = CGSize(width: (texture.size().width / Tamanho.W * size.width), height: (texture.size().width / Tamanho.W * size.width) * (texture.size().height/texture.size().width))
        return node
    }()
    
    lazy var backBordersGrama: Borders = {
        var textureFundoGrama = ["Normal", "Normal", "Escura", "Escura"].map{
            SKTexture(imageNamed: "fundoGrama\($0)")
        }
        let node:Borders = Borders(textures: textureFundoGrama)
        
        self.name = "gramaBorda"
        
        return node
    }()
    
    lazy var dog:Dog = Dog(size: self.frame.size)
    
    lazy var locationSprites: [String: CGPoint] = {
        return [TasksNames.coco.rawValue: CGPoint.zero,
                TasksNames.Bolinha.rawValue: CGPoint.zero,
                TasksNames.GuardaChuvaFechado.rawValue: CGPoint.zero,
                TasksNames.Petisco.rawValue: CGPoint.zero,
                TasksNames.Lixeira.rawValue: CGPoint.zero]
    }()
    
    lazy var tasks:[Task] = {
        [Task(name: .Lixeira, nil, sizeFrame: self.frame.size),
         Task(name: .GuardaChuvaFechado, SKTexture(imageNamed: "GuardaChuvaAberto"),sizeFrame: self.frame.size),
         Task(name: .Bolinha, nil, sizeFrame: self.frame.size),
         Task(name: .coco, nil, sizeFrame: self.frame.size),
         Task(name: .Petisco, nil, sizeFrame: self.frame.size)]
    }()
    
    lazy var goalsLockers:[String: Goals] = {
        var goals: [String: Goals] = [dog.name!: Goals(name: dog.name!, size: self.frame.size, text: "")]
        self.tasks.forEach{ task in
            if task.name != "Lixeira"{
                goals[task.name!] = Goals(name: task.name!, size: self.frame.size, text: "")
            }
        }
       return goals
    }()
    
    var nuvens:[SKSpriteNode] = {
        var nuvens = ["1", "2"].map{
            SKSpriteNode(imageNamed: "NuvemChuva\($0)")
        }
        return nuvens
    }()
    
    var cantRaining = 0
    
    let rain = SKEmitterNode(fileNamed: "Rain.sks")!
    
    override func didMove(to view: SKView) {
        self.addChild(music)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backGround.name = "fundo"
        self.addChild(backGround)
        self.addChild(backBordersCeu)
        self.addChild(backBordersGrama)
        self.positionBacks()
        self.addChild(dog)
        self.addChild(arbusto)
        self.addChild(comedouro)
        self.tasks.forEach({self.addChild($0)})
        self.goalsLockers.values.forEach({self.addChild($0)})
        self.positionsAndMessageAll()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if cantRaining == 7{
            self.final()
        }
        
        let location = touches.first!.location(in: self)
        let touched = self.atPoint(location)
        
        touchedNode = (touched as? Task) ?? (touched as? Dog) ?? (touched as? Goals)
        touchedNode?.run(SKAction.pulse)
        self.dog.removeAllActions()
        self.dog.animateDog(node: touchedNode)
        
        self.goalsLockers.values.forEach({ goal in
            if goal.IsShowingMessage && ((touchedNode as? Goals) == nil){
                goal.apearDissapear()
            }
        })
        
        if let _ = touchedNode as? Dog{
            dog.swipedDog(location)
        }
        else if let goal = touchedNode as? Goals{
            goal.apearDissapear()
            self.goalsLockers.values.forEach({ goalDissapear in
                if goalDissapear.IsShowingMessage && (goal != goalDissapear){
                    goalDissapear.apearDissapear()
                }
            })
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        (touchedNode as? Actable)?.act(location)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let lastTouched = touchedNode as? Dog{
            if lastTouched.taskDogIsConclued && !(goalsLockers[lastTouched.name!]?.opened ?? true) {
                self.taskComplete(name: lastTouched.name!)
                cantRaining += 1
            }
        }
        else if let lastTouched = touchedNode as? Task{
            if lastTouched.taskIsConclude {
                self.audios(taskEnum: lastTouched.taskEnum)
                self.taskComplete(name: lastTouched.name!)
                lastTouched.removeFromParent()
                cantRaining += 1
            }
            else {
                let position = locationSprites[lastTouched.name!]!
                lastTouched.backPosition(positioX: position.x, y: position.y)
            }
        }
        if cantRaining == 4{
            backGround.starRaning(backCeu: backBordersCeu, backGrama: backBordersGrama)
            self.backBordersGrama.raining()
            raining()
            cantRaining += 1
            tasks.forEach({task in
                if task.name == "GuardaChuvaFechado"{
                    task.ItsRaning = true
                    dog.removeAllActions()
                    dog.sadDog()
                }
            })
        }
        else if cantRaining == 6{
            rain.removeFromParent()
            nuvens.forEach({ nuvem in
                nuvem.removeFromParent()
            })
            backGround.endRaining(backCeu: backBordersCeu, backGrama: backBordersGrama)
            cantRaining+=1
        }
        else{
            dog.removeAllActions()
            dog.animateCloseEyes()
        }
        
    }
    
    
    private func raining(){
        self.addChild(rain)
        rain.zPosition = -1
        rain.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        var speed = 8
        nuvens.forEach({ nuvem in
            self.addChild(nuvem)
            nuvem.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY - nuvem.size.height)
            nuvem.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveTo(x: self.frame.minX - nuvem.size.width, duration: TimeInterval(speed)), SKAction.moveTo(x: self.frame.maxX + nuvem.size.width, duration: 0)]) ))
            speed += 4
        })
    }
    
    private func positionBacks(){
        self.backBordersCeu.position = CGPoint(x: 0, y: self.backGround.frame.maxY + 265/2 - 3)
        self.backBordersGrama.position = CGPoint(x: 0, y: self.backGround.frame.minY - 265/2 + 3)
    }
    
    private func point(x: CGFloat, y: CGFloat) -> CGPoint{
        return CGPoint(x: x, y: y)
    }
    
    private func positionsAndMessageAll(){
        var y = self.frame.maxY / 2
        self.dog.position = point(x: -self.frame.maxX/2 + self.dog.size.width, y: -self.dog.size.height/1.3)
        self.arbusto.position = point(x: self.frame.minX + self.arbusto.size.width/2, y: -self.arbusto.size.height*1.8)
        self.comedouro.position = point(x: self.frame.minX/2 - (self.comedouro.size.width*1.35), y: -self.comedouro.size.height*5.2)
        self.recebeMessage(tipo: Messages.Dog, taskName: dog.name!)
        self.goalsLockers.values.forEach({ goal in
            goal.position = point(x: self.frame.maxX - goal.size.width, y: y)
            y -= (goal.size.height * 1.5)
        })
        
        self.tasks.forEach({ taskN in
            switch taskN.taskEnum{
            case .Petisco:
                taskN.position = self.addPositionInDict(taskName: taskN.name!, point: point(x: self.frame.minX/2 - (taskN.size.width * 1.9), y: -taskN.size.height*10.2))
                self.recebeMessage(tipo: Messages.Petisco, taskName: taskN.name!)
            case .GuardaChuvaFechado:
                taskN.position = self.addPositionInDict(taskName: taskN.name!, point: point(x: self.frame.maxX - taskN.size.width * 2.8, y: -taskN.size.height/0.8))
                self.recebeMessage(tipo: Messages.GuardaChuva, taskName: taskN.name!)
            case .Lixeira:
                taskN.position = self.addPositionInDict(taskName: taskN.name!, point: point(x: self.frame.maxX - taskN.size.width * 0.7, y: -taskN.size.height/0.5))
            case .Bolinha:
                taskN.position = self.addPositionInDict(taskName: taskN.name!, point: point(x: self.frame.maxX - taskN.size.width*2, y: -taskN.size.height*9))
                self.recebeMessage(tipo: Messages.Bolinha, taskName: taskN.name!)
            case .coco:
                taskN.position = self.addPositionInDict(taskName: taskN.name!, point: point(x: self.frame.minX/2 - (taskN.size.width * 7), y: -taskN.size.height*6))
                self.recebeMessage(tipo: Messages.Coco, taskName: taskN.name!)
            default:
                return
            }
        })
    }
    
    private func taskComplete(name: String){
        self.goalsLockers[name]?.opened = true
        self.goalsLockers[name]?.IsShowingMessage = true
        self.addChild(self.goalsLockers[name]!.currentNode)
    }
    
    private func recebeMessage(tipo: String, taskName: String){
        goalsLockers[taskName]?.text = tipo
        goalsLockers[taskName]?.frameParent = self.frame
        goalsLockers[taskName]?.createMessage()
    }
    
    private func addPositionInDict(taskName: String, point:CGPoint) -> CGPoint{
        locationSprites[taskName] = point
        return point
    }
    
    private func audios(taskEnum: TasksNames){
        if taskEnum == .coco{
            self.run(SKAction.playSoundFileNamed("Lixeira", waitForCompletion: true))
        }
        else if taskEnum == .Bolinha{
            self.run(SKAction.playSoundFileNamed("Bolinha", waitForCompletion: true))
        }
    }
    
    private func final(){
        let scene = FinalScene()
        scene.size = CGSize(width:UIScreen.main.bounds.width,height:UIScreen.main.bounds.height)
        scene.scaleMode = .aspectFill
        self.view?.presentScene(scene,transition:SKTransition.moveIn(with:.right,duration:1))
    }
}
