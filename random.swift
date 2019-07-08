//
//  random.swift
//  7 Sides
//
//  Created by Student on 7/12/18.
//  Copyright © 2018 dmaadmin. All rights reserved.
//

import Foundation
import UIKit

public func random (lower: CGFloat, upper: CGFloat) -> CGFloat {
    return lower + CGFloat(arc4random_uniform(UInt32(upper-lower)))
}
