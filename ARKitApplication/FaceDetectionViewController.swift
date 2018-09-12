//
//  FaceDetectionViewController.swift
//   ARKitApplication
//
//  Created by Sathish on 9/7/17.
//  Copyright © 2018 Vivid. All rights reserved.
//

import UIKit
import ARKit
import Vision



class FaceDetectionViewController: UIViewController,ARSCNViewDelegate {

    @IBOutlet weak var scnSceneView: ARSCNView!
    
    private var scanTimer: Timer?
    
    private var scannedFaceViews = [UIView]()
    
    private var imageOrientation: CGImagePropertyOrientation{
        switch UIDevice.current.orientation {
        case .portrait: return .right
        case .landscapeRight: return .down
        case .portraitUpsideDown: return .left
        case .unknown: fallthrough
        case .faceUp: fallthrough
        case .faceDown: fallthrough
        case .landscapeLeft: return .up
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            scnSceneView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        let config = ARWorldTrackingConfiguration()
        scnSceneView.session.run(config)
//        let config = ARFaceTrackingConfiguration()
//         scnSceneView.session.run(config)
       //scanForFaces()
         scanTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        scanTimer?.invalidate()
        scnSceneView.session.pause()
    }
    
    @objc func scanForFaces(){
        _ = scannedFaceViews.map{$0.removeFromSuperview()}
        scannedFaceViews.removeAll()
        guard let captureImage = scnSceneView.session.currentFrame?.capturedImage else {
            return
        }
        let image = CIImage.init(cvPixelBuffer: captureImage)
        let detectFaceRequest = VNDetectFaceRectanglesRequest{(request, error) in
            DispatchQueue.main.async {
                if let faces = request.results as? [VNFaceObservation]{
                    for face in faces{
                        let faceview = UIView(frame: self.faceFrame(from: face.boundingBox))
                        faceview.backgroundColor = .clear
                        faceview.layer.borderWidth = 2
                        faceview.layer.borderColor = UIColor.red.cgColor
                        self.scnSceneView.addSubview(faceview)
                        self.scannedFaceViews.append(faceview)
                    }
                    
                }
            }
            
        }
        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image, orientation: self.imageOrientation).perform([detectFaceRequest])
        }
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect{
        let origin = CGPoint(x: boundingBox.minX * scnSceneView.bounds.width, y: (1 - boundingBox.maxY) * scnSceneView.bounds.height)
        let size = CGSize(width: boundingBox.width * scnSceneView.bounds.width, height: boundingBox.height * scnSceneView.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }

}
