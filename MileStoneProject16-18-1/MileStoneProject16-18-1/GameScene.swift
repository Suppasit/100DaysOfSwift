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
    var gameOver: SKSpriteNode!
    var restartLabel: SKLabelNode!
    var bullet1: SKSpriteNode!
    var bullet2: SKSpriteNode!
    
    var gameTimer: Timer?
    var countDownTimer: Timer?
    
    var isGameOver = false
    var targetSpeed = 10.0
    var targetDelay = 1.5
//    var targetsCreated = 0
    
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
        createBackground()
        createWater()
        createOverlay()
        
        runGame()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location    = touch.location(in: self)
        
        if !isGameOver {
    //        let tappedNodes = nodes(at: location)
    //
    //        for node in tappedNodes {
    //            print(node.name)
    //        }

            if numOfBullet > 0 {
                shot(at: location)
                run(SKAction.playSoundFileNamed("shot.wav", waitForCompletion: false))
            } else {
                if numOfBullet < 0 { numOfBullet = 0 }
                run(SKAction.playSoundFileNamed("empty.wav", waitForCompletion: false))
            }
            
            numOfBullet -= 1
            reloadBullet(at: location)
        } else {
            reloadGame(at: location)
        }
    }
    
    func createBackground() {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.position = CGPoint(x: 512, y: 384)
        background.size = self.frame.size
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        let grass = SKSpriteNode(imageNamed: "grass-trees")
        grass.position = CGPoint(x: 512, y: 434)
        grass.size.width = self.frame.size.width
        addChild(grass)
        grass.zPosition = 100
        
    }
    
    func createWater() {
        func animate(_ node: SKNode, distance: CGFloat, duration: TimeInterval) {
            let moveUP = SKAction.moveBy(x: 0, y: distance, duration: duration)
            let moveDown = moveUP.reversed()
            let sequenc = SKAction.sequence([moveUP, moveDown])
            let repeatForever = SKAction.repeatForever(sequenc)
            node.run(repeatForever)
        }
        
        let waterBackground = SKSpriteNode(imageNamed: "water-bg")
        waterBackground.position = CGPoint(x: 512, y: 314)
        waterBackground.size.width = frame.size.width
        waterBackground.zPosition = 200
        addChild(waterBackground)
        
        let waterForeground = SKSpriteNode(imageNamed: "water-fg")
        waterForeground.position = CGPoint(x: 512, y: 254)
        waterForeground.size.width = self.frame.size.width
        waterForeground.zPosition = 300
        addChild(waterForeground)
        
        animate(waterBackground, distance: 8, duration: 1.3)
        animate(waterForeground, distance: 12, duration: 1)
    }
    
    func createOverlay() {
        let curtains = SKSpriteNode(imageNamed: "curtains")
        curtains.position = CGPoint(x: 512, y: 384)
        curtains.size = self.frame.size
        curtains.zPosition = 400
        addChild(curtains)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: 0"
        scoreLabel.zPosition = 500
        addChild(scoreLabel)
        
        cntDwnLabel = SKLabelNode(fontNamed: "Chalkduster")
        cntDwnLabel.position = CGPoint(x: 424, y: 16)
        cntDwnLabel.horizontalAlignmentMode = .left
        cntDwnLabel.text = "Timer: 60"
        cntDwnLabel.zPosition = 500
        addChild(cntDwnLabel)
        
        bullet1 = SKSpriteNode(imageNamed: "shots3")
        bullet1.position = CGPoint(x: 870, y: 30)
        bullet1.name = "bullet"
        bullet1.zPosition = 500
        addChild(bullet1)
        
        bullet2 = SKSpriteNode(imageNamed: "shots3")
        bullet2.position = CGPoint(x: 950, y: 30)
        bullet2.name = "bullet"
        bullet2.zPosition = 500
        addChild(bullet2)
    }
    
    func runGame() {
        gameTimer = Timer.scheduledTimer(timeInterval: targetDelay, target: self, selector: #selector(createTargets), userInfo: nil, repeats: true)

        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    func reloadGame(at location: CGPoint) {
        let hitNodes = nodes(at: location).filter { $0.name?.contains("restart") ?? false }
        guard let hitNode = hitNodes.first else { return }
        
        print(hitNode.name!)
        if hitNode.name == "restart" {
            run(SKAction.playSoundFileNamed("bell.wav", waitForCompletion: false))
            score       = 0
            cntTimer    = 60
            numOfBullet = 6
            targetSpeed = 10.0
            targetDelay = 1.5
            isGameOver  = false
            
            gameOver.removeFromParent()
            restartLabel.removeFromParent()
            
            runGame()
        }
        
    }
    
    func shot(at location: CGPoint) {
        let hitNodes         = nodes(at: location).filter { $0.name?.contains("target") ?? false }
        guard let hitNode    = hitNodes.first else {
            score -= 5
            return
        }
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
    
    func reloadBullet(at location: CGPoint) {
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
        let target = HitTarget()
        target.setup()
        
        let level = Int.random(in: 0...2)
        var movingRight = true
        
        switch level {
        case 0:
            target.zPosition = 150
            target.position.y = 414
            target.setScale(0.7)
        case 1:
            target.zPosition = 250
            target.position.y = 324
            target.setScale(0.85)
            movingRight = false
        default:
            target.zPosition = 350
            target.position.y = 184
        }
        
        let move: SKAction
        
        if movingRight {
            target.position.x = 0
            move = SKAction.moveTo(x: 1024, duration: targetSpeed)
        } else {
            target.position.x = 1024
            target.xScale = -target.xScale
            move = SKAction.moveTo(x: 0, duration: targetSpeed)
        }
        
        let sequence = SKAction.sequence([move, SKAction.removeFromParent()])
        target.run(sequence)
        addChild(target)
        
        levelUp()
    }
    
    func levelUp() {
        targetSpeed *= 0.99
        targetDelay *= 0.99
    }
    
    @objc func countDown() {
        cntTimer -= 1
        
        if cntTimer == 0 {
            isGameOver = true
            countDownTimer?.invalidate()
            gameTimer?.invalidate()

            gameOver = SKSpriteNode(imageNamed: "game-over")
            gameOver.position = CGPoint(x: 512, y: 414)
            gameOver.zPosition = 500
            addChild(gameOver)
            
            restartLabel = SKLabelNode(fontNamed: "Chalkduster")
            restartLabel.position = CGPoint(x: 900, y: 730)
            restartLabel.text = "<Restart>"
            restartLabel.name = "restart"
            restartLabel.zPosition = 500
            addChild(restartLabel)
        }
    }
    
}
