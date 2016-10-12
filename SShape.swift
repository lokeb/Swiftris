//
//  SShape.swift
//  Swiftris
//
//  Created by Loke on 10/11/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

class SShape:Shape {
/*
     Orientation
     0
     | 0.|
     | 1 | 2 |
         | 3 |
     
     90
       . | 1 | 0 |
     | 3 | 2 |
     
     180
     | 0.|
     | 1 | 2 |
         | 3 |
     
     270
      .  | 1 | 0 |
     | 3 | 2 |
 */
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero : [(0,0), (0,1), (1,1), (1,2)],
            Orientation.Ninety : [(2,0), (1,0), (1,1), (0, 1)],
            Orientation.OneEighty : [(0,0), (0,1), (1,1), (1,2)],
            Orientation.TwoSeventy : [(2,0), (1,0), (1,1), (0,1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        return [
            Orientation.Zero : [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety : [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.OneEighty : [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy : [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}
