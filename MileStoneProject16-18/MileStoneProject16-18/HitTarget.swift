//
//  HitTarget.swift
//  MileStoneProject16-18
//
//  Created by suppasit chuwatsawat on 15/7/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//
import SpriteKit
import UIKit

class HitTarget: SKNode {
    var targetNode: SKSpriteNode!
    var possibleTargets = ["target0", "target1", "target2", "target3"]
    
    func configureTarget(at positionY: CGFloat) {
        guard let targetName = possibleTargets.randomElement() else { return }
        
        targetNode = SKSpriteNode(imageNamed: targetName)
        targetNode.position.y = positionY
        targetNode.name = targetName
        
        let gameScene = GameScene()
        
        if Int(positionY) == gameScene.possibleLocations[1] {
            targetNode.position.x = 1024
            targetNode.xScale = -targetNode.xScale
            let move = SKAction.moveTo(x: 0, duration: 6.0)
            let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
            targetNode.run(sequence)
        } else {
            targetNode.position.x = 0
            let move = SKAction.moveTo(x: 1024, duration: 6.0)
            let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
            targetNode.run(sequence)
        }
        
        addChild(targetNode)
    }
    
    func hit() {
        targetNode.removeFromParent()
    }
}
