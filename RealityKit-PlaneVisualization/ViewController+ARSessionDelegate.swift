//
//  ViewController+ARSessionDelegate.swift
//  RealityKit-PlaneVisualization
//
//  Created by Meng-Han Wu on 9/19/20.
//  Copyright © 2020 Meng-Han Wu. All rights reserved.
//

import ARKit
import RealityKit

extension ViewController: ARSessionDelegate {
    // When ARKit detects a new anchor, it will add it to the ARSession
    // Whenever there is a newly added ARAnchor, you will get that anchor here.
    // In this short tutorial, we will target the ARPlaneAnchor, and use the information stored
    // in that anchor for visualization.
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor {
                let planeAnchor = anchor as! ARPlaneAnchor
                addPlaneEntity(with: planeAnchor, to: arView)
            }
        }
    }
    
    // ARKit will automatically track and update the ARPlaneAnchor.
    // We use that anchor to update the `skin` of the plane.
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor {
                let planeAnchor = anchor as! ARPlaneAnchor
                updatePlaneEntity(with: planeAnchor, in: arView)
            }
        }
    }
    
    // When ARKit remove an anchor from the ARSession, you will get the removed
    // anchor here.
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        for anchor in anchors {
            if anchor is ARPlaneAnchor {
                let planeAnchor = anchor as! ARPlaneAnchor
                removePlaneEntity(with: planeAnchor, from: arView)
            }
        }
    }
}

