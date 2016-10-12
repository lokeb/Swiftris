//
//  Shape.swift
//  Swiftris
//
//  Created by Loke on 10/10/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, CustomStringConvertible {
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    var description: String {
        switch self {
        case .Zero:
            return "0"
        case .Ninety:
            return "90"
        case .OneEighty:
            return "180"
        case .TwoSeventy:
            return "270"
        }
    }
    
    static func random()->Orientation {
        return Orientation(rawValue:Int(arc4random_uniform(NumOrientations)))!
    }
    
    static func rotate(orientation: Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.TwoSeventy.rawValue {
            rotated = Orientation.Zero.rawValue
        } else if rotated < Orientation.Zero.rawValue {
            rotated = Orientation.TwoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}

let numShapeTypes: UInt32 = 7

let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

class Shape: Hashable, CustomStringConvertible {
    let color: BlockColor
    var blocks = Array<Block>()
    var orientation: Orientation
    var column, row: Int
    
    var blockRowColumnPositions : [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:]
    }
    
    var bottomBlocksForOrientations : [Orientation: Array<Block>] {
        return [:]
    }
    
    var bottomBlocks : Array<Block> {
        guard let bottomBlocks = bottomBlocksForOrientations[orientation] else {
            return []
        }
        return bottomBlocks
    }
    
    var hashValue: Int {
        return blocks.reduce(0) { $0.hashValue ^ $1.hashValue }
    }
    
    var description: String {
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation) {
        self.column = column
        self.row = row
        self.color = color
        self.orientation = orientation
        initializeBlocks()
    }
    
    convenience init(column: Int, row: Int) {
        self.init(column: column, row: row, color : BlockColor.random(), orientation: Orientation.random() )
    }
    
    final func initializeBlocks() {
        guard let blockRowColumnTranslations = blockRowColumnPositions[orientation] else {
            return
        }
        blocks = blockRowColumnTranslations.map { (diff)->Block in
            return Block(column: column + diff.columnDiff, row: row + diff.rowDiff, color: color )
        }
    }
    
    final func rotateBlocks(orientation : Orientation) {
        guard let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] else {
            return
        }
        for (idx, diff) in blockRowColumnTranslation.enumerate() {
            blocks[idx].column = column + diff.columnDiff
            blocks[idx].row = row + diff.rowDiff
        }
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(0, rows: 1)
    }
    
    final func shiftBy(columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    final func moveTo(column: Int, row: Int) {
        self.column = column
        self.row = row
        rotateBlocks(orientation)
    }
    
    final class func random(startingColumn: Int, startingRow: Int) -> Shape {
        switch Int(arc4random_uniform(numShapeTypes)) {
        case 0 :
            return SquareShape(column: startingColumn, row: startingRow)
        case 1 :
            return LineShape(column: startingColumn, row: startingRow)
        case 2 :
            return Tshape(column: startingColumn, row: startingRow)
        case 3 :
            return LShape(column: startingColumn, row: startingRow)
        case 4 :
            return JShape(column: startingColumn, row: startingRow)
        case 5 :
            return SShape(column: startingColumn, row: startingRow)
        default :
            return ZShape(column: startingColumn, row: startingRow)
        }
    }
}

func == (lhs: Shape, rhs: Shape)-> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}
