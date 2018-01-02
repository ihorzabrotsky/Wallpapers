//
//  Room.swift
//  WallPapers
//
//  Created by Ihor on 11/13/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import Foundation
import ARKit

class Room {
	
	var floor: Floor
	var walls: [Wall] = []
	
	let wallPositions: [WallPosition] = [.Top, .Right, .Bottom, .Left]
	
	init(floor: Floor) {
		self.floor = floor
	}
	
	func buildWalls() {
		// build walls for floor
		
		for position in wallPositions {
			buildWallOnPosition(position, withHeight: 5.0)
		}
	}
	
	func buildWallOnPosition(_ position: WallPosition, withHeight height: Float) {
		let wallNode = createWallForPosition(wallPosition: position, withHeight: 5.0)
		floor.node.addChildNode(wallNode)
		
		guard let wallPlane = wallNode.geometry as? SCNPlane else { return }
		
		let wall = Wall(plane: wallPlane, node: wallNode)
		
		walls.append(wall)
	}
	
	func createWallForPosition(wallPosition: WallPosition, withHeight height: Float) -> SCNNode {
		let wallPlane = SCNPlane(width: wallPosition.rawValue % 2 == 0 ? floor.plane.width : floor.plane.height, height: CGFloat(height))
		wallPlane.materials.first?.diffuse.contents = "bricks.png"
		wallPlane.materials.first?.diffuse.contentsTransform = SCNMatrix4MakeScale(4, 4, 0)
		wallPlane.materials.first?.diffuse.wrapS = .repeat
		wallPlane.materials.first?.diffuse.wrapT = .repeat
		
		
		let wallNode = SCNNode(geometry: wallPlane)
		wallNode.simdPosition = wallPositionCoordsForPosition(wallPosition, withWallHeight: height)
		wallNode.eulerAngles = wallEulerAnglesForPosition(wallPosition)
		wallNode.opacity = 1.0
		
		return wallNode
	}
	
	// next methods must be refactored in terms of polymorphizm
	
	func wallPositionCoordsForPosition(_ position: WallPosition, withWallHeight height: Float) -> float3 {
		switch position {
		case .Top:
			return float3(x: 0, y: Float(floor.plane.height/2.0), z: height/2.0)
		case .Right:
			return float3(x: Float(floor.plane.width)/2.0, y: 0, z: height/2.0)
		case .Bottom:
			return float3(x: 0, y: -Float(floor.plane.height/2.0), z: height/2.0)
		case .Left:
			return float3(x: -Float(floor.plane.width)/2.0, y: 0, z: height/2.0)
		}
	}
	
	func wallEulerAnglesForPosition(_ position: WallPosition) -> SCNVector3 {
		switch position {
		case .Top:
			return SCNVector3(x: .pi/2.0, y: 0, z: 0)
		case .Right:
			return SCNVector3(x: .pi/2.0, y: 0, z: -.pi/2.0)
		case .Bottom:
			return SCNVector3(x: .pi/2.0, y: 0, z: -.pi)
		case .Left:
			return SCNVector3(x: .pi/2.0, y: 0, z: -.pi*1.5)
		}
	}
	
}
