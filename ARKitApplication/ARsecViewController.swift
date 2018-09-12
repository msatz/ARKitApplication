//
//  ARsecViewController.swift
//   ARKitApplication
//
//  Created by Sathish on 9/7/17.
//  Copyright © 2018 smac. All rights reserved.
//

import UIKit
import ARKit
class ARsecViewController: UIViewController {
   
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        config.planeDetection = .horizontal
        sceneView.session.run(config)
//        let capsuleNode = SCNNode(geometry: SCNCapsule(capRadius: 0.03, height: 0.1))
//        capsuleNode.position = SCNVector3(0.1,0.1,-0.5)
//        sceneView.scene.rootNode.addChildNode(capsuleNode)
        // Do any additional setup after loading the view.
    }

}
extension ARsecViewController:ARSCNViewDelegate{
    func createFloorNode(anchor:ARPlaneAnchor) ->SCNNode{
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        floorNode.position=SCNVector3(anchor.center.x,0,anchor.center.z)
        //floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        floorNode.geometry?.firstMaterial?.diffuse.contents =  UIImage(named: "Tile_1")
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        floorNode.eulerAngles = SCNVector3(Double.pi/2,0,0)
        return floorNode
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let planeNode = createFloorNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        let planeNode = createFloorNode(anchor: planeAnchor)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else {return}
        node.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
}
