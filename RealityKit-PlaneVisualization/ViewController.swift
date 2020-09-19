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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arView.session.delegate = self
        configureARView()
    }
    
    func configureARView() {
        arView.automaticallyConfigureSession = false
        let config = ARWorldTrackingConfiguration()
        
        // Enable vertical plane detection.
        config.planeDetection = [.vertical, .horizontal]
        config.environmentTexturing = .automatic
        arView.session.run(config)
    }
}
