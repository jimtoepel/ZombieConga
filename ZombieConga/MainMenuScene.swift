//
//  MainMenuScene.swift
//  ZombieConga
//
//  Created by Jim Toepel on 5/12/20.
//  Copyright © 2020 FunderDevelopment. All rights reserved.
//

import Foundation
import SpriteKit


class MainMenuScene: SKScene {
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "MainMenu")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTapped()
    }
    
    func sceneTapped() {
        let block = SKAction.run {
            let myScene = GameScene(size: self.size)
            myScene.scaleMode = self.scaleMode
            let reveal = SKTransition.doorway(withDuration: 0.5)
            self.view?.presentScene(myScene, transition: reveal)
        }
        self.run(block)
    }
}

