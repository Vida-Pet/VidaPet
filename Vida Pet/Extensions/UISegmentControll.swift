//
//  UISegmentControll.swift
//  Vida Pet
//
//  Created by João Pedro Giarrante on 06/11/20.
//  Copyright © 2020 João Pedro Giarrante. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    func selectSegment(thatMatches title: String?) {
        for index in 0...self.numberOfSegments - 1{
            if self.titleForSegment(at: index) == title {
                self.selectedSegmentIndex = index
            }
        }
    }
}
