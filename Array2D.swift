//
//  Array2D.swift
//  Swiftris
//
//  Created by Loke on 10/6/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

class Array2D<T> {
    let columns : Int
    let rows : Int
    
    var array : Array<T?>
    
    init(columns : Int, rows : Int) {
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(count: rows * columns, repeatedValue: nil)
    }
    
    subscript(column : Int, row : Int) -> T? {
        get {
            return array[(columns * row) + column]
        }
        set {
            array[(columns * row) + column] = newValue
        }
    }
}
