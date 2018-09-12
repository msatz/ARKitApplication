//
//  ViewController.swift
//  ARKitApplication
//
//  Created by Sathish on 8/14/18.
//  Copyright © 2018 smac. All rights reserved.
//

import ARKit

let kStartingPosition = SCNVector3(0, -2, -3)
let kAnimationDurationMoving: TimeInterval = 0.2
let kMovingLengthPerLoop: CGFloat = 0.05
let kRotationRadianPerLoop: CGFloat = 0.2
var timer: Timer!
var alertBool = false


class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBAction func ClearButton(_ sender: Any) {
        
        drone.removeNode()
        nodeStatus = true
        //  sceneView.scene.rootNode.removeFromParentNode()
    }
    @IBOutlet weak var viewUI: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var captureUI: UIButton!
    @IBAction func captureAction(_ sender: Any) {
        image.isHidden = false
        image.image = sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(image.image!, self, nil, nil)
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(hideImaView), userInfo: nil, repeats: false)
        
    }
    
    var nodeStatus = true
    var drone = Drone()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfiguration()
        setupScene()
        captureUI.layer.cornerRadius = 28
        viewUI.layer.cornerRadius = 30
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let alert = UIAlertController(title: "Instructions", message: "Touch any where to place object and use arrow to move object.", preferredStyle: UIAlertControllerStyle.alert)
        //  alert.addAction(UIAlertAction(title: "Dn't show again", style: .cancel, handler: {action in
        //alertBool = true
        //}))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        setupConfiguration()
        // addDrone()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches....")
        
        if nodeStatus{
            setupScene()
            addDrone()
        }
    }
    
    func addDrone() {
        
        print("add Node..")
        _ = self.sceneView.pointOfView?.worldPosition
        drone.loadModel()
        drone.position = kStartingPosition
        drone.rotation = SCNVector4Zero
        sceneView.scene.rootNode.addChildNode(drone)
        nodeStatus = false
    }
    
    @objc func hideImaView(){
        image.isHidden = true
    }
    // MARK: - setup
    func setupScene() {
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func setupConfiguration() {
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    // MARK: - actions
    @IBAction func upLongPressed(_ sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        
        execute(action: action, sender: sender)
    }
    
    @IBAction func downLongPressed(_ sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    @IBAction func moveLeftLongPressed(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().cos
        let z = deltas().sin
        moveDrone(x: x, z: z, sender: sender)
    }
    
    @IBAction func moveRightLongPressed(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().cos
        let z = -deltas().sin
        moveDrone(x: x, z: z, sender: sender)
        
    }
    
    @IBAction func moveForwardLongPressed(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().sin
        let z = -deltas().cos
        moveDrone(x: x, z: z, sender: sender)
    }
    
    @IBAction func moveBackLongPressed(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().sin
        let z = deltas().cos
        moveDrone(x: x, z: z, sender: sender)
    }
    
    @IBAction func rotateLeftLongPressed(_ sender: UILongPressGestureRecognizer) {
        rotateDrone(yRadian: kRotationRadianPerLoop, sender: sender)
    }
    
    @IBAction func rotateRightLongPressed(_ sender: UILongPressGestureRecognizer) {
        rotateDrone(yRadian: -kRotationRadianPerLoop, sender: sender)
    }
    
    // MARK: - private
    private func rotateDrone(yRadian: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: yRadian, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    private func moveDrone(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            drone.runAction(loopAction)
        } else if sender.state == .ended {
            drone.removeAllActions()
        }
    }
    
    private func deltas() -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(drone.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(drone.eulerAngles.y)))
    }
}

