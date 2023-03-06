//
//  Utils.swift
//  RealityKit-PlaneVisualization
//
//  Created by Meng-Han Wu on 9/19/20.
//  Copyright © 2020 Meng-Han Wu. All rights reserved.
//

import ARKit
import RealityKit

// The ARPlaneAnchor contains the information we need to create the `skin` of the plane.
func addPlaneEntity(with anchor: ARPlaneAnchor, to view: ARView) {
    /*
    let planeAnchorEntity = AnchorEntity(.plane([.any],
                                    classification: [.any],
                                    minimumBounds: [0.5, 0.5]))
    */
    let planeAnchorEntity = AnchorEntity(anchor: anchor)
    let planeModelEntity = createPlaneModelEntity(with: anchor)

    // Give Entity a name for tracking.
    planeAnchorEntity.name = anchor.identifier.uuidString + "_anchor"
    planeModelEntity.name = anchor.identifier.uuidString + "_model"
    
    // Add ModelEntity as a child of AnchorEntity.
    // AnchorEntity handles `position` of the plane.
    // ModelEntity handles the `skin` of the plane.
    planeAnchorEntity.addChild(planeModelEntity)
    
    // Finally, add the entity to scene.
    view.scene.addAnchor(planeAnchorEntity)
}

func createPlaneModelEntity(with anchor: ARPlaneAnchor) -> ModelEntity {
    var planeMesh: MeshResource
    var color: UIColor
    
    if anchor.alignment == .horizontal {
        print("horizotal plane")
        color = UIColor.blue.withAlphaComponent(0.5)
        planeMesh = .generatePlane(width: anchor.extent.x, depth: anchor.extent.z)
    } else if anchor.alignment == .vertical {
        print("vertical plane")
        color = UIColor.yellow.withAlphaComponent(0.5)
        planeMesh = .generatePlane(width: anchor.extent.x, height: anchor.extent.z)
    } else {
        fatalError("Anchor is not ARPlaneAnchor")
    }
    
    return ModelEntity(mesh: planeMesh, materials: [SimpleMaterial(color: color, roughness: 0.25, isMetallic: false)])
}

func removePlaneEntity(with anchor: ARPlaneAnchor, from arView: ARView) {
    guard let planeAnchorEntity = arView.scene.findEntity(named: anchor.identifier.uuidString+"_anchor") else { return }
    arView.scene.removeAnchor(planeAnchorEntity as! AnchorEntity)
}

func updatePlaneEntity(with anchor: ARPlaneAnchor, in view: ARView) {
    var planeMesh: MeshResource
    guard let entity = view.scene.findEntity(named: anchor.identifier.uuidString+"_model") else { return }
    let modelEntity = entity as! ModelEntity

    if anchor.alignment == .horizontal {
        planeMesh = .generatePlane(width: anchor.extent.x, depth: anchor.extent.z)
    } else if anchor.alignment == .vertical {
        planeMesh = .generatePlane(width: anchor.extent.x, height: anchor.extent.z)
    } else {
        fatalError("Anchor is not ARPlaneAnchor")
    }
    
    modelEntity.model!.mesh = planeMesh
}
