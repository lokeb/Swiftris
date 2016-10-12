//
//  GameScene.swift
//  Swiftris
//
//  Created by Loke on 10/5/16.
//  Copyright (c) 2016 Bloc. All rights reserved.
//

import SpriteKit

let BlockSize:CGFloat = 20.0

let TickLengthLevelOne = NSTimeInterval(600)

class GameScene: SKScene {
    let gameLayer = SKNode()
    let shapeLayer = SKNode()
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne
    var lastTick:NSDate?
    
    var textureCache = Dictionary<String, SKTexture>()

    override func update(currentTime: CFTimeInterval) {
        guard let lastTick = lastTick else {
            return
        }
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        
        if timePassed > tickLengthMillis {
            self.lastTick = NSDate()
            
            tick?()
        }
    }
    
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
    
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let x = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize/2)
        let y = LayerPosition.y + (CGFloat(row) * BlockSize) + (BlockSize/2)
        return CGPointMake(x, y)
    }
    
    func addPreviewShapeToScene(shape: Shape, completion:()->()) {
        for block in shape.blocks {
            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            let sprite = SKSpriteNode(texture: texture)
            sprite.position = pointForColumn(block.column, row: block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
            sprite.alpha = 0
            
            let moveAction = SKAction.moveTo(pointForColumn(block.column, row: block.row), duration: NSTimeInterval(0.2))
            moveAction.timingMode = .EaseOut
            
            let fadeInAction = SKAction.fadeAlphaTo(0.7, duration: 0.4)
            fadeInAction.timingMode = .EaseOut
            
            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
        }
        runAction(SKAction.waitForDuration(0.4), completion: completion)
    }
    
    func movePreviewShape(shape: Shape, completion: ()->()) {
        for block in shape.blocks {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row: block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]), completion: {})
        }
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func redrawShape(shape: Shape, completion: ()->()) {
        for block in shape.blocks {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row: block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveToAction.timingMode = .EaseOut
            
            if block == shape.blocks.last {
                sprite.runAction(moveToAction, completion: completion)
            } else {
              sprite.runAction(moveToAction)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size : CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0, y: 1.0)
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
        
        addChild(gameLayer)
        
        let gameboardTexture = SKTexture(imageNamed: "gameboard")
        let gameboard = SKSpriteNode(texture: gameboardTexture, size: CGSizeMake(BlockSize * CGFloat(NumColumns), BlockSize * CGFloat(NumRows)))
        gameboard.anchorPoint = CGPoint(x: 0, y: 1.0)
        
        gameboard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameboard)
        gameLayer.addChild(shapeLayer)
    }
}
