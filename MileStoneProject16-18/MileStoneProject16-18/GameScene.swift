//
//  GameScene.swift
//  MileStoneProject16-18
//
//  Created by suppasit chuwatsawat on 15/7/2562 BE.
//  Copyright © 2562 suppasit chuwatsawat. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var spriteObject: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var cntDwnLabel: SKLabelNode!
    var bullet1: SKSpriteNode!
    var bullet2: SKSpriteNode!
    var gameTimer: Timer?
    var countDownTimer: Timer?
    var isGameOver = false
    
    public var possibleLocations = [164, 414, 654]
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var cntTimer = 60 {
        didSet {
            cntDwnLabel.text = "Timer: \(cntTimer)"
        }
    }
    
    var bulletTexture = [
        SKTexture(imageNamed: "shots0"),
        SKTexture(imageNamed: "shots1"),
        SKTexture(imageNamed: "shots2"),
        SKTexture(imageNamed: "shots3")
    ]
    
    var numOfBullet = 6 {
        didSet {
            handleBullet()
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 512, y: 384)
        background.size = self.frame.size
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        cntDwnLabel = SKLabelNode(fontNamed: "Chalkduster")
        cntDwnLabel.position = CGPoint(x: 424, y: 16)
        cntDwnLabel.horizontalAlignmentMode = .left
        cntDwnLabel.text = "Timer: 60"
        addChild(cntDwnLabel)
        
        bullet1 = SKSpriteNode(imageNamed: "shots3")
        bullet1.position = CGPoint(x: 870, y: 30)
        bullet1.name = "bullet"
        addChild(bullet1)
        
        bullet2 = SKSpriteNode(imageNamed: "shots3")
        bullet2.position = CGPoint(x: 950, y: 30)
        bullet2.name = "bullet"
        addChild(bullet2)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver { return }
        
        guard let touch = touches.first else { return }
        let location    = touch.location(in: self)

        numOfBullet -= 1
        
        if numOfBullet > 0 {
            shot(at: location)
            run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
        } else {
            if numOfBullet < 0 { numOfBullet = 0 }
            run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
        }
        
        handleReload(at: location)
    }
    
    func shot(at location: CGPoint) {
        let hitNodes         = nodes(at: location).filter { $0.name?.contains("target") ?? false }
        guard let hitNode    = hitNodes.first else { return }
        guard let parentNode = hitNode.parent as? HitTarget else { return }
        
        print(hitNode.name!)
        
        switch hitNode.name {
        case "target0":
            score += 1
        case "target1":
            score += 2
        case "target2":
            score += 3
        default:
            score -= 5
        }
        
        parentNode.hit()
    }
    
    func handleReload(at location: CGPoint) {
        let hitNodes         = nodes(at: location).filter { $0.name?.contains("bullet") ?? false }
        guard let hitNode    = hitNodes.first else { return }
        
        print(hitNode.name!)
        if hitNode.name == "bullet" {
            numOfBullet = 6
            run(SKAction.playSoundFileNamed("reload.wav", waitForCompletion: false))
        }
    }
    
    func handleBullet() {
        switch numOfBullet {
        case 6:
            bullet1.texture = bulletTexture[3]
            bullet2.texture = bulletTexture[3]
        case 5:
            bullet2.texture = bulletTexture[2]
        case 4:
            bullet2.texture = bulletTexture[1]
        case 3:
            bullet2.texture = bulletTexture[0]
        case 2:
            bullet1.texture = bulletTexture[2]
        case 1:
            bullet1.texture = bulletTexture[1]
        default:
            bullet1.texture = bulletTexture[0]
        }
    }
    
    @objc func createTargets() {
        guard let positionY = possibleLocations.randomElement() else { return }
        
        let target = HitTarget()
        target.configureTarget(at: CGFloat(positionY))
        addChild(target)
    }
    
    @objc func countDown() {
        cntTimer -= 1
        
        if cntTimer == 0 {
            isGameOver = true
            countDownTimer?.invalidate()
            gameTimer?.invalidate()

            let gameOver = SKSpriteNode(imageNamed: "game-over")
            gameOver.position = CGPoint(x: 512, y: 414)
            gameOver.zPosition = 10
            addChild(gameOver)
        }
    }
    
}
