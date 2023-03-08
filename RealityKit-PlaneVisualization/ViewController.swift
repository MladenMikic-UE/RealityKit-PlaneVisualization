//
//  ViewController.swift
//  RealityKit-PlaneVisualization
//
//  Created by Meng-Han Wu on 9/19/20.
//  Copyright © 2020 Meng-Han Wu. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var doorModelEntity: ModelEntity? = nil
    var hasDoorBeenPlaced = false
    var hasFirstImageBeenFound = false
    var firstImageAnchorWorldPositin: SIMD3<Float>? = nil
    var hasWorldAnchorForImageBeenPlaced: Bool = false
    var worldAnchorEntityFotImage: AnchorEntity? = nil
    var firstImageAnchorIdentifidr: String? = nil
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialQueue")
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arView.session.delegate = self
        configureARView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let modelEntity = try ModelEntity.loadModel(named: "Bathroom_Door_Frame")
            print("modelEntity: \(modelEntity)")
            self.doorModelEntity = modelEntity
        } catch let error {
            
        }
    }
    
    func configureARView() {
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        // Enable vertical plane detection.
        config.planeDetection = [.vertical, .horizontal]
        
        config.detectionImages = referenceImages
        config.environmentTexturing = .automatic
        arView.session.run(config)
    }
}
