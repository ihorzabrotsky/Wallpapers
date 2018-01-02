//
//  Wall.swift
//  WallPapers
//
//  Created by Ihor on 11/13/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import Foundation
import ARKit

enum WallPosition: Int {
	case Top = 0
	case Right = 1
	case Bottom = 2
	case Left = 3
}

class Wall {
	var plane: SCNPlane
	var node: SCNNode
	
	init(plane: SCNPlane, node: SCNNode) {
		self.plane = plane
		self.node = node
	}
}
