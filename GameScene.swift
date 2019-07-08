//
//  GameScene.swift
//  7 Sides
//
//  Created by Student on 7/12/18.
//  Copyright © 2018 dmaadmin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var colorWheelBase = SKShapeNode();
    let leftTap = SKAction.rotate(byAngle: (convertDegreesToRadians(degrees: (360/7))), duration: 0.2)
    let rightTap = SKAction.rotate(byAngle: (-convertDegreesToRadians(degrees: (360/7))), duration: 0.2)
    var currentGameState: gameState = gameState.beforeGame
    let tapToStartLabel = SKLabelNode(fontNamed: "Caviar Dreams")
    let scoreLabel = SKLabelNode(fontNamed: "Caviar Dreams")
    let playCorrectSound = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    let playIncorrectSound = SKAction.playSoundFileNamed("death.wav" , waitForCompletion: false)
    var highScore = UserDefaults.standard.integer(forKey: "highScoreSaved")
    let highScoreLabel = SKLabelNode(fontNamed: "Caviar Dreams")
    
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        //setting up the background image
        let background = SKSpriteNode(imageNamed: "gameBackground")
        background.size = self.size
        //puts background in the middle of th escreen
        background.position = CGPoint (x: self.size.width/2, y: self.size.height/2)
        //makes background behind everything else using z position
        background.zPosition = -1
        self.addChild(background)
        //making the color wheel base and makes it red
        colorWheelBase = SKShapeNode(rectOf: CGSize(width: self.size.width * 0.8, height: self.size.width * 0.8))
        colorWheelBase.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        colorWheelBase.fillColor = SKColor.clear
        colorWheelBase.strokeColor = SKColor.clear
        self.addChild(colorWheelBase)
        
        prepColorWheel()
        
        tapToStartLabel.text = "Tap To Start"
        tapToStartLabel.fontSize = 100
        tapToStartLabel.fontColor = SKColor.darkGray
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.1)
        self.addChild(tapToStartLabel)
        
        scoreLabel.text = "0"
        scoreLabel.fontSize = 225
        scoreLabel.fontColor = SKColor.darkGray
        scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.85)
        self.addChild(scoreLabel)
        
        highScoreLabel.text = "Best: \(highScore)"
        highScoreLabel.fontSize = 100
        highScoreLabel.fontColor = SKColor.darkGray
        highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.8)
        self.addChild(highScoreLabel)
    }
    
    func prepColorWheel() {
        
        for i in 0...(numberOfSides - 1) {
            let side = Side(type: colorWheelOrder[i])
            let basePosition = CGPoint(x: self.size.width/2, y: self.size.height/4)
            side.position = convert(basePosition, to: colorWheelBase)
            colorWheelBase.addChild(side)
            side.zRotation = -colorWheelBase.zRotation
            
            colorWheelBase.zRotation += (convertDegreesToRadians(degrees: (360/7)))
        }
        
        for side in colorWheelBase.children {
            let sidePosition = side.position
            let positionInScene = convert(sidePosition, from: colorWheelBase)
            sidePositions.append(positionInScene)
            
        }
        
    } 
    func spawnBall() {
        let ball = Ball()
        ball.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.addChild(ball)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == .beforeGame {
            startTheGame()
        } else if currentGameState == .inGame {
            let point = touches.first!.location(in: self)
            
            
            
            
            
            if point.x < frame.size.width / 2 {
                colorWheelBase.run(leftTap)
            }
            if point.x > frame.size.width / 2 {
                colorWheelBase.run(rightTap)
            }

        }
    }
    
    func startTheGame () {
        spawnBall()
        let scaleDown = SKAction.scale(to: 0, duration: 0.2)
        let deleteLabel = SKAction.removeFromParent()
        let deleteSequence = SKAction.sequence([scaleDown, deleteLabel])
        tapToStartLabel.run(deleteSequence)
        
        currentGameState = .inGame
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        ballMovementSpeed = 2;
        let ball: Ball
        let side: Side
        if contact.bodyA.categoryBitMask == physicsCategories.Ball {
            ball = contact.bodyA.node! as! Ball
            side = contact.bodyB.node! as! Side
        } else {
            ball = contact.bodyB.node! as! Ball
            side = contact.bodyA.node! as! Side
        }
        
        if ball.isActive == true {
            checkMatch(ball: ball, side: side)
            
        }
        
    }
    
    func checkMatch (ball: Ball, side: Side) {
        if ball.type == side.type {
            correctMatch(ball: ball)
            
        } else {
            wrongMatch(ball: ball)
        }
    }
    
    func correctMatch (ball: Ball) {
        ball.delete()
        self.run(playCorrectSound)
        score += 1
        scoreLabel.text = "\(score)"
        if score < 5 {
            ballMovementSpeed = 2.0
        } else if score < 10 {
            ballMovementSpeed = 1.8
        } else if score < 15 {
            ballMovementSpeed = 1.7
        } else if score < 25 {
            ballMovementSpeed = 1.6
        } else if score < 40 {
            ballMovementSpeed = 1.5
        } else if score < 60 {
            ballMovementSpeed = 1.4
        } else if score < 85 {
            ballMovementSpeed = 1.3
        } else if score < 115 {
            ballMovementSpeed = 1.2
        } else if score < 150 {
            ballMovementSpeed = 1.1
        } else if score < 190 {
            ballMovementSpeed = 1.0
        }
        
        spawnBall()
        
        
        if score > highScore {
            highScoreLabel.text = "Best: \(score)"
        }
        
    }
    
    func wrongMatch (ball: Ball) {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "highScoreSaved")
        }
        ball.flash()
        self.run(playIncorrectSound)
        currentGameState = .afterGame
        colorWheelBase.removeAllActions()
        
        let waitToChangeScene = SKAction.wait(forDuration: 2)
        let changeScene = SKAction.run {
            let sceneToMoveTo = GameOverScene(fileNamed: "GameOverScene")!
            sceneToMoveTo.scaleMode = self.scaleMode
            let sceneTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        }
        let sceneChangeSequence = SKAction.sequence([waitToChangeScene, changeScene])
        self.run(sceneChangeSequence)
        
        
    }
}





