//
//  GameScene.swift
//  ZombieConga
//
//  Created by Jim Toepel on 5/2/20.
//  Copyright © 2020 FunderDevelopment. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // MARK: - Assets
    let zombie = SKSpriteNode(imageNamed: "zombie1")
    let background = SKSpriteNode(imageNamed: "background1")
    let enemy = SKSpriteNode(imageNamed: "enemy")
    
    // MARK: - Properties
    var lastUpdateTime: TimeInterval = 0.0
    var dt: TimeInterval = 0.0
    let zombieMovePointsPerSec: CGFloat = 480.0
    let zombieRotateRadiansPerSec: CGFloat = 4.0 * π
    var velocity = CGPoint.zero
    let playableRect: CGRect
    var lastTouchedLocation = CGPoint.zero

    // MARK: - Engine Methods
    override init(size: CGSize) {
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableHeight = size.width / maxAspectRatio
        let playableMargin = (size.height - playableHeight)/2.0
        playableRect = CGRect(x: 0,
                              y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //DidMove is essentially "on startup"
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let centerScreen = CGPoint(x: size.width/2, y: size.height/2)
        
        //Add a background
        background.position = centerScreen
        background.zPosition = -1
        addChild(background)
        
        //Add a zombie + enemy
        spawnZombie()
        spawnEnemy()
        
        //Create a reference to the size of the BG node
        let mySize = background.size
//        print("Size: \(mySize)")
        
        //Draw the aspect ratio
        debugDrawPlayableArea()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0.0
        }
        lastUpdateTime = currentTime
//        print("\(dt*1000) milliseconds since last update")
        let checkMoveOffset = zombie.position - lastTouchedLocation
        if (checkMoveOffset.length() <= zombieMovePointsPerSec * CGFloat(dt)) {
            zombie.position = lastTouchedLocation
            velocity = CGPoint.zero
        } else {
            move(sprite: zombie, velocity: velocity)
            rotate(sprite: zombie, direction: velocity, rotateRadiansPerSec: zombieRotateRadiansPerSec)
        }
        boundsCheckZombie()
    }
    
    // MARK: - Utility Methods
    func move(sprite:SKSpriteNode, velocity: CGPoint) {
        // 1
        let amountToMove = velocity * CGFloat(dt)
//        print("Amount to move: \(amountToMove)")
        // 2
        sprite.position += amountToMove
    }
    
    func moveZombieToward(location: CGPoint) {
        let offset = location - zombie.position
        
        // normalize the direction into a unit vector, then multiply by speed
        let direction = offset.normalized()
        velocity = direction * zombieMovePointsPerSec
    }
    
    func sceneTouched(touchLocation:CGPoint) {
        moveZombieToward(location: touchLocation)
        lastTouchedLocation = touchLocation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
    }
    
    func debugDrawPlayableArea() {
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint, rotateRadiansPerSec: CGFloat) {
        let shortest = shortestAngleBetween(angle1: sprite.zRotation, angle2: velocity.angle)
        let amountToRotate = min(rotateRadiansPerSec * CGFloat(dt), abs(shortest))
        sprite.zRotation += (amountToRotate * shortest.sign())
    }
    
    func spawnEnemy() {
        enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: size.height/2)
        addChild(enemy)
        
        let actionMidMove = SKAction.moveBy(x: -size.width/2 - enemy.size.width/2,
                                            y: -playableRect.height/2 + enemy.size.height/2,
                                            duration: 2.0)
        
        let actionMove = SKAction.moveBy(x: -size.width/2 - enemy.size.width/2,
                                         y: playableRect.height/2 - enemy.size.height/2,
                                         duration: 2.0)
        
        let wait = SKAction.wait(forDuration: 0.25)
        let logMessage = SKAction.run() {
            print("Reached Bottom!")
        }
        
        
        let halfSequence = SKAction.sequence([actionMidMove, logMessage, wait, actionMove])
        let sequence = SKAction.sequence([halfSequence, halfSequence.reversed()])
        enemy.run(sequence)
    }
    
    func spawnZombie() {
        zombie.position = CGPoint(x: 400, y:400)
        addChild(zombie)
    }
}

