//
//  GameOverScene.swift
//  7 Sides
//
//  Created by Student on 7/13/18.
//  Copyright © 2018 dmaadmin. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        let scoreLabel: SKLabelNode = self.childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score: \(score)"
        
        let highScoreLabel: SKLabelNode = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        let highScore = UserDefaults.standard.integer(forKey: "highScoreSaved")
        highScoreLabel.text = "High Score: \(highScore)"
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = .aspectFill
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(sceneToMoveTo, transition: sceneTransition)
        score = 0
    }
}
