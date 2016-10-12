//
//  GameViewController.swift
//  Swiftris
//
//  Created by Loke on 10/5/16.
//  Copyright (c) 2016 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene : GameScene!
    var swiftris : Swiftris!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        scene.tick = didTick
        
        swiftris = Swiftris()
        swiftris.beginGame()
        
        skView.presentScene(scene)
        
        scene.addPreviewShapeToScene(swiftris.nextShape!) {
            self.swiftris.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.swiftris.nextShape!) {
                let nextShapes = self.swiftris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!){}
            }
        }
        
    }
    
    func didTick() {
        swiftris.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(swiftris.fallingShape!, completion: {})
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
