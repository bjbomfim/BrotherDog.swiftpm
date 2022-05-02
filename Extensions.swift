//
//  File.swift
//  BrotherDog
//
//  Created by Alexandre Bomfim on 14/04/22.
//

import Foundation
import SpriteKit

extension SKAction {
    static var pulse:SKAction {
        return SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.1),
            SKAction.scale(to: 1, duration: 0.1)
        ])
    }
}
