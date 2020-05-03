//
//  GameScene.swift
//  ZombieConga
//
//  Created by Jim Toepel on 5/2/20.
//  Copyright © 2020 FunderDevelopment. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let centerScreen = CGPoint(x: size.width/2, y: size.height/2)
        
        //Add a background
        let background = SKSpriteNode(imageNamed: "background1")
        background.position = centerScreen
        background.zPosition = -1
        addChild(background)
        
        //Add a zombie
        let zombie1 = SKSpriteNode(imageNamed: "zombie1")
        zombie1.position = CGPoint(x: 400, y:400)
        addChild(zombie1)
        
        //Create a reference to the size of the BG node
        let mySize = background.size
        print("Size: \(mySize)")
        
    }
}
