//
//  GameScene.swift
//  Pachinko
//
//  Created by Leo Liu on 8/10/18.
//  Copyright © 2018 hungryforcookies. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //score
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    //editing
    var editLabel: SKLabelNode!
    
    var editMode: Bool = false {
        didSet{
            if editMode{
                editLabel.text = "Done"
            }else{
                editLabel.text = "Edit"
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //in case there are multiple collisions detected between two objects
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA.name == "ball"{
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
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
        
        //score label
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 32, y: 1280)
        addChild(scoreLabel)
        
        //edit label
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.horizontalAlignmentMode = .left
        editLabel.position = CGPoint(x: 32, y: 1200)
        addChild(editLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel){
                editMode = !editMode
            }else{
                
                if editMode{
                    //create a box
                    let size = CGSize(width: GKRandomDistribution(lowestValue: 16, highestValue: 128).nextInt(), height: 16)
                    let box = SKSpriteNode(color: RandomColor(), size: size)
                    
                    box.zRotation = RandomCGFloat(min: 0, max: 3)
                    box.position = location
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: size)
                    box.physicsBody?.isDynamic = false
                    
                    addChild(box)
                    
                }else{
                    //create a ball
                    //TODO: create a ball only at the top
                
                    let ball = SKSpriteNode(imageNamed: "ballRed.png")
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    ball.physicsBody?.restitution = 0.4
                    ball.position = location
                    ball.name = "ball"
                    
                    addChild(ball)
                }
            }
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
            slotBase.name = "good"
            
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "bad"
            
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }
        
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        slotGlow.position = position
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spinGlow = SKAction.rotate(byAngle: CGFloat.pi, duration: 10)
        let spinGlowForever = SKAction.repeatForever(spinGlow)
        slotGlow.run(spinGlowForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "good"{
            destroy(ball: ball)
            score += 1
        }else if object.name == "bad"{
            destroy(ball: ball)
            score -= 1
        }
        //else both are balls, do nothing
    }
    
    func destroy(ball: SKNode){
        
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            
            fireParticles.position = ball.position
            addChild(fireParticles)
            
            ball.removeFromParent()
        }
    }
}
