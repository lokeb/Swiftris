//
//  LineShape.swift
//  Swiftris
//
//  Created by Loke on 10/11/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

class LineShape: Shape {
/*
 Orienations 0, 180
     | 0.|
     | 1 |
     | 2 |
     | 3 |

 Orientation 90, 270
     | 0 | 1.| 2 | 3 |
 */
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero : [(0,0), (0,1), (0,2), (0,3)],
            Orientation.Ninety : [(-1,0), (0,0), (1,0), (2,0)],
            Orientation.OneEighty : [(0,0), (0,1), (0,2), (0,3)],
            Orientation.TwoSeventy : [(-1,0), (0,0), (1,0), (2,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        return[
            Orientation.Zero : [blocks[FourthBlockIdx]],
            Orientation.Ninety : blocks,
            Orientation.OneEighty : [blocks[FourthBlockIdx]],
            Orientation.TwoSeventy : blocks
        ]
    }
}
