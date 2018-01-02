//
//  ViewController+ARSCNViewDelegate.swift
//  WallPapers
//
//  Created by Ihor on 11/9/17.
//  Copyright © 2017 TechMagic. All rights reserved.
//

import Foundation
import ARKit

extension ViewController: ARSCNViewDelegate {
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
		
		// Create a SceneKit plane to visualize the plane anchor using its position and extent.
		let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
		let planeNode = SCNNode(geometry: plane)
		planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
		
		/*
		`SCNPlane` is vertically oriented in its local coordinate space, so
		rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
		*/
		planeNode.eulerAngles.x = -.pi/2.0
		
		// Make the plane visualization semitransparent to clearly show real-world placement.
		planeNode.opacity = 0.25
		
		/*
		Add the plane visualization to the ARKit-managed node so that it tracks
		changes in the plane anchor as plane estimation continues.
		*/
		node.addChildNode(planeNode)
		
		// create room with walls based on the floor found (this plane)
		
		let floor = Floor(plane: plane, node: planeNode)
		createRoomForFloor(floor: floor)
	}
	
	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
		// Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
		guard let planeAnchor = anchor as? ARPlaneAnchor,
			let planeNode = node.childNodes.first,
			let plane = planeNode.geometry as? SCNPlane
			else { return }
		
		// Plane estimation may shift the center of a plane relative to its anchor's transform.
		planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
		
		/*
		Plane estimation may extend the size of the plane, or combine previously detected
		planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
		corresponding node for one plane, then calls this method to update the size of
		the remaining plane.
		*/
		plane.width = CGFloat(planeAnchor.extent.x)
		plane.height = CGFloat(planeAnchor.extent.z)
		
		let floor = Floor(plane: plane, node: planeNode)
		createRoomForFloor(floor: floor)
	}
	
	func session(_ session: ARSession, didUpdate frame: ARFrame) {
		
	}
	
}
