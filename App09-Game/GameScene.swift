//
//  GameScene.swift
//  App09-Game
//
//  Created by Alumno on 01/11/21.
//

import SwiftUI
import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    let ball = SKSpriteNode(imageNamed: "barrel")
    let basket = SKSpriteNode(imageNamed: "canasta")
    let aro = SKSpriteNode(imageNamed: "aro")
    var planeTouched = false
    var started = false
    var timer: Timer?
    var hasGone = false
    var originalBallPos: CGPoint!
    @Binding var currentScore: Int
    
    init(_ score: Binding<Int>) {
        _currentScore = score
        super.init(size: CGSize(width: 926, height: 444))
        self.scaleMode = .fill
    }
    
    required init?(coder aDecoder: NSCoder) {
        _currentScore = .constant(0)
        super.init(coder: aDecoder)
    }
    
    
    override func didMove(to view: SKView) {
        
//        let background = SKSpriteNode(imageNamed: "sky")
//        background.size = CGSize(width: 926, height: 444)
//        background.zPosition = 0
//        addChild(background)
        
        
        basket.zPosition = 5
        basket.position = CGPoint(x: 330, y: -10)
        basket.scale(to: CGSize(width: 280, height: 280))
        basket.name = "basket"
        addChild(basket)
        
//        basket.physicsBody = SKPhysicsBody(texture: basket.texture!, size: basket.texture!.size())
//        basket.physicsBody?.isDynamic = false
//        basket.physicsBody?.contactTestBitMask = 1
        
        
        
        aro.zPosition = 5
        aro.position = CGPoint(x: 286, y: 9)
        aro.scale(to: CGSize(width: 270, height: 280))
        addChild(aro)
        aro.physicsBody = SKPhysicsBody(texture: aro.texture!, size: CGSize(width: 60, height: 60))
        aro.physicsBody?.isDynamic = false
        aro.physicsBody?.contactTestBitMask = 1
        aro.physicsBody?.linearDamping = 0
        aro.name = "aro"
        
        
        ball.zPosition = 5
        ball.position = CGPoint(x: -400, y: -100)
        ball.scale(to: CGSize(width: 30, height: 30))
        ball.name = "ball"
        addChild(ball)
        
        originalBallPos = ball.position
        
        ball.physicsBody = SKPhysicsBody(texture: ball.texture!, size: CGSize(width: 30, height: 30))
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.affectedByGravity = false
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -4)
        
        let node = SKSpriteNode(imageNamed: "cancha")
        node.zPosition = 0
        node.scale(to: CGSize(width: 926, height: 444))
        addChild(node)
       // parallaxScroll(image: "ground", y: -180, z: 5, duration: 6, needsPhysics: true)

        physicsWorld.contactDelegate = self
        
       // timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if !hasGone {
                    if let touch = touches.first {
                        let touchLocation = touch.location(in: self)
                        let touchedWhere = nodes(at: touchLocation)
                        
                        if !touchedWhere.isEmpty {
                            for node in touchedWhere {
                                if let sprite = node as? SKSpriteNode {
                                    if sprite == ball {
                                        print("Plane Touched")
                                        ball.position = touchLocation
                                        planeTouched = true

                                    }
                                }
                            }
                        }
                    }
                }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        guard planeTouched else { return }
//        guard let touch = touches.first else { return }
//
//        let location = touch.location(in: self)
//        plane.position = location
        if !hasGone {
                    if let touch = touches.first {
                        let touchLocation = touch.location(in: self)
                        let touchedWhere = nodes(at: touchLocation)
                        
                        if !touchedWhere.isEmpty {
                            for node in touchedWhere {
                                if let sprite = node as? SKSpriteNode {
                                    if sprite == ball {
                                        // MARK: Made duck snap back to its original position when it has been dragged further than the mid-X point to prevent the user from cheating (and dragging the duck around so it hits the boxes)!
                                       
                                            ball.position = touchLocation
                                        
                                    }
                                }
                            }
                        }
                    }
                }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        planeTouched = false
        if !hasGone {
                    if let touch = touches.first {
                        let touchLocation = touch.location(in: self)
                        let touchedWhere = nodes(at: touchLocation)
                        
                        if !touchedWhere.isEmpty {
                            for node in touchedWhere {
                                if let sprite = node as? SKSpriteNode {
                                    if sprite == ball {
                                        let dx = -(touchLocation.x - originalBallPos.x)
                                        let dy = -(touchLocation.y - originalBallPos.y)
                                        let impulse = CGVector(dx: dx, dy: dy)
                        
                                        ball.physicsBody?.applyImpulse(impulse)
                                        ball.physicsBody?.applyAngularImpulse(-0.01)
                                        ball.physicsBody?.affectedByGravity = true
                                        
                                        hasGone = true
                                    }
                                }
                            }
                        }
                    }
                }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        print(ball.position.x,ball.position.y)
        if let ballPhysicsBody = ball.physicsBody {
            if ballPhysicsBody.velocity.dx <= 0.1 && ballPhysicsBody.velocity.dy <= 0.1 && ballPhysicsBody.angularVelocity <= 0.1 && hasGone && ball.position.y <= 190{
                    print ("reset")
                       ball.physicsBody?.affectedByGravity = false
                       ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                       ball.physicsBody?.angularVelocity = 0
                       ball.zRotation = 0
                       ball.position = originalBallPos
                    
                       hasGone = false
                       
                       // 3: When you reset, loop through the boxes and set them to its original position, rotation and velocity
                       
                    
                   }
               }
        if ball.position.y > 190 {
            let dy = -((ball.physicsBody?.velocity.dy)!)
            let dx = ((ball.physicsBody?.velocity.dx)!)
            ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
            
        }
        if ball.position.y < -190 {
            let dy = -((ball.physicsBody?.velocity.dy)!)
            let dx = ((ball.physicsBody?.velocity.dx)!)
            ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
       
        }
//        if ball.position.x < 200 {
//            let dy = ((ball.physicsBody?.velocity.dy)!)
//            let dx = -((ball.physicsBody?.velocity.dx)!)
//            ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
//            ball.physicsBody?.angularVelocity = 0
//        }
        if ball.position.x > 444 {
            let dy = ((ball.physicsBody?.velocity.dy)!)
            let dx = -((ball.physicsBody?.velocity.dx)!)
            ball.physicsBody?.velocity = CGVector(dx : dx, dy: dy )
          
        }
    }
    
    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool) {
        
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            
            node.position = CGPoint(x: 1024 * CGFloat(i), y: y)
            node.zPosition = z
            node.scale(to: CGSize(width: 825, height: 428))
            addChild(node)
            
            if needsPhysics {
                node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
                node.physicsBody?.isDynamic = false
                node.physicsBody?.contactTestBitMask = 1
                
                node.name = "obstacle"
            }
            
            let move = SKAction.moveBy(x: -1024, y: 0, duration: duration)
            let wrap = SKAction.moveBy(x: 1024, y: 0, duration: 0)
            
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
            node.run(forever)
            
        }
        
    }
    
    func planeHit(_ node: SKNode) {
        
        if node.name == "aro" {
            if let explosion = SKEmitterNode(fileNamed: "planeExplosion") {
                explosion.position = aro.position
                explosion.zPosition = 10
                currentScore = 0
                addChild(explosion)
                currentScore += 1
                print(currentScore)
            }
            
//            run(SKAction.playSoundFileNamed("explosion", waitForCompletion: false))
            ball.removeFromParent()
//            music.removeFromParent()
            started = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let scene = GameScene(self.$currentScore)
                scene.scaleMode = .aspectFit
                scene.size = CGSize(width: 926, height: 444)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.view?.presentScene(scene)
                
            }
            
        } 
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
       
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        print("hit")
        if nodeA == ball {
            planeHit(nodeB)
        } else {
            planeHit(nodeA)
        }
        
    }
    
    @objc func createObstacle() {
        
        let obstacle = SKSpriteNode(imageNamed: "enemy-plane")
        obstacle.zPosition = 5
        obstacle.position.x = 700
        obstacle.scale(to: CGSize(width: 50, height: 50))
        addChild(obstacle)
        
        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: CGSize(width: 50, height: 50))
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.physicsBody?.linearDamping = 0
        obstacle.name = "obstacle"
        
        let rand = GKRandomDistribution(lowestValue: -130, highestValue: 190)
        obstacle.position.y = CGFloat(rand.nextInt())
        
        let move = SKAction.moveTo(x: -700, duration: 9)
        let remove = SKAction.removeFromParent()
        let action = SKAction.sequence([move, remove])
        obstacle.run(action)
        
        // Para incrementar el score
        let collision = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 20, height: 444))
        collision.physicsBody = SKPhysicsBody(rectangleOf: collision.size)
        collision.physicsBody?.contactTestBitMask = 1
        collision.physicsBody?.isDynamic = false
        collision.position.x = obstacle.frame.maxX
        collision.name = "score"
        addChild(collision)
        collision.run(action)
        
    }
}
