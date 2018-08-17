//
//  GameScene.swift
//  Pachinko
//
//  Created by Leo Liu on 8/10/18.
//  Copyright © 2018 hungryforcookies. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x:375, y:667)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        placeBouncer(at: CGPoint(x: 0, y: 0))
        placeBouncer(at: CGPoint(x: 256, y: 0))
        placeBouncer(at: CGPoint(x: 512, y: 0))
        placeBouncer(at: CGPoint(x: 768, y: 0))
        placeBouncer(at: CGPoint(x: 1024, y: 0))
        
        placeSlot(at: CGPoint(x:128, y:0), isGood: true)
        placeSlot(at: CGPoint(x:384, y:0), isGood: false)
        placeSlot(at: CGPoint(x:640, y:0), isGood: true)
        placeSlot(at: CGPoint(x:896, y:0), isGood: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed.png")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4
            ball.position = location
            addChild(ball)
        }
    }
    
    //MARK: helpers
    func placeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func placeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotGlow.position = position
        addChild(slotBase)
        addChild(slotGlow)
        
        let spinGlow = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinGlowForever = SKAction.repeatForever(spinGlow)
        slotGlow.run(spinGlowForever)
    }
}
