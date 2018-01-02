//
//  Floor.swift
//  WallPapers
//
//  Created by Ihor on 11/13/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import Foundation
import ARKit

class Floor {
	var plane: SCNPlane
	var node: SCNNode
	
	init(plane: SCNPlane, node: SCNNode) {
		self.plane = plane
		self.node = node
	}
	
	func clearWalls() {
		for child in node.childNodes {
			child.removeFromParentNode()
		}
	}
	
}
