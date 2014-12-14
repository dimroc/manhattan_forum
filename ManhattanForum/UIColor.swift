//
//  UIColor.swift
//  ManhattanForum
//
//  Created by Dimitri Roche on 12/14/14.
//  Copyright (c) 2014 dimroc. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(hex: String!) {
        var rgb: UInt32 = 0

        let scanner = NSScanner(string: hex)
        scanner.scanLocation = 1
        scanner.scanHexInt(&rgb)

        let red: CGFloat = CGFloat((rgb & 0xFF0000) >> 16)
        let green: CGFloat = CGFloat((rgb & 0x00FF00) >> 8)
        let blue: CGFloat = CGFloat(rgb & 0x0000FF)
        
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
}