//
//  Drone.swift
//  ARKitApplication
//
//  Created by smac on 8/14/18.
//  Copyright © 2018 smac. All rights reserved.
//

import ARKit

class Drone: SCNNode {
    var wrapperNode = SCNNode()
    func loadModel() {
        guard let virtualObjectScene = SCNScene(named: "demo.scn") else { return }
        
        //let position = SCNVector3(x: 0, y: 0, z: -5)
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
            // updatePositionAndOrientationOf(child, withPosition: position, relativeTo: wrapperNode)
        }
        
        addChildNode(wrapperNode)
    }
    
    func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
        let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
        //setup a
        // Setup a translation matrix with the desired position
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.x = position.x
        translationMatrix.columns.3.y = position.y
        translationMatrix.columns.3.z = position.z
        
        // Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
        let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
        node.transform = SCNMatrix4(updatedTransform)
    }
    
    
    func removeNode(){
        //let node = SCNScene(named: "Demo.scn")
        print("Removed...")
        wrapperNode.removeFromParentNode()
    }
    
}
