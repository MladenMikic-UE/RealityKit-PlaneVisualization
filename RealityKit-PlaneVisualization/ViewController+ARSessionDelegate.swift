//
//  ViewController+ARSessionDelegate.swift
//  RealityKit-PlaneVisualization
//
//  Created by Meng-Han Wu on 9/19/20.
//  Copyright © 2020 Meng-Han Wu. All rights reserved.
//

import ARKit
import RealityKit
// The growth and u
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
            } else if anchor is ARImageAnchor {
                let imageAnchor = anchor as! ARImageAnchor
                print("\t\t\tImageAnchor.worldPosition (initial): \(imageAnchor.transform.positionSIMD3())")
                self.firstImageAnchorWorldPositin = imageAnchor.transform.positionSIMD3()
                addPlaneEntity(with: imageAnchor, to: arView)
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
            } else if anchor is ARImageAnchor {
                let imageAnchor = anchor as! ARImageAnchor
                updateImageEntity(with: imageAnchor, in: arView)
                print("\t\t\tImageAnchor.worldPosition: \(imageAnchor.transform.positionSIMD3())")
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
            } else if anchor is ARImageAnchor {
                let imageAnchor = anchor as! ARImageAnchor
                removeImageEntity(with: imageAnchor, from: arView)
            }
        }
    }
    
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let arView = self.arView else { return }

        if let imageAnchorIdentifier = self.firstImageAnchorIdentifidr {
            guard let entity = arView.scene.findEntity(named: imageAnchorIdentifier),
                  let modelEntity = entity.children.first as? ModelEntity else { return }
            
            
            if  let firstEntity = modelEntity.children.first,
                UInt64(firstEntity.name) == modelEntity.id,
                let boxEntity = firstEntity as? ModelEntity {
                
                let width = (boxEntity.model?.mesh.bounds.max.x)! - (boxEntity.model?.mesh.bounds.min.x)!
                let height = (boxEntity.model?.mesh.bounds.max.y)! - (boxEntity.model?.mesh.bounds.min.y)!
                let depth = (boxEntity.model?.mesh.bounds.max.z)! - (boxEntity.model?.mesh.bounds.min.z)!
                
                boxEntity.position.y = height / 2.0
                //modelEntity.setPosition(anchor.transform.positionSIMD3(), relativeTo: nil)
                print("\t\t\tImageAnchorEntity.worldPosition: \(modelEntity.position(relativeTo: nil))")
                // initial
                // SIMD3<Float>(0.07171498, -1.286095, -0.37166595)
                // SIMD3<Float>(0.07171498, -1.286095, -0.37166595))
                print("\t\t\tworldAnchorEntityFotImage.worldPosition: \(worldAnchorEntityFotImage?.position(relativeTo: nil))")
                
                
            }
        }
        
        arView.scene.anchors.forEach { anchor in
            if let anchorEntity = anchor as? AnchorEntity, anchorEntity.name.contains("_image_anchor") {
                let localPosition = anchorEntity.position
                let worldPosition = anchorEntity.position(relativeTo: nil)
                
                print("\t\tlocalPosition = \(localPosition)")
                print("\t\tworldPosition = \(worldPosition)")
            }
        }
        // view.scene.findEntity(named: anchor.identifier.uuidString+"_model")
        /*
        arView.scene.anchors.forEach { anchor in
            if let anchorEntity = anchor as? AnchorEntity {
                if let boxEntity = anchorEntity.children.first, UInt64(boxEntity.name) == anchorEntity.id {
                    
                } else {
                    print("\tanchorEntity: \(anchorEntity)")
                    let boxEntity = createBoxEntity()
                    boxEntity.name = String(anchorEntity.id)
                    boxEntity.position.y = 0.3
                    anchorEntity.addChild(boxEntity)
                }
            }

        }
        */
    }
    
    
    @available(iOS 15.0, *)
    func createBoxEntity(color: UIColor) -> ModelEntity {
        let boxMesh = MeshResource.generateBox(width: 0.05, height: 1, depth: 0.05)
        let boxMaterial = SimpleMaterial(color: color, isMetallic: false)
        let boxModelEntity = ModelEntity(mesh: boxMesh, materials: [boxMaterial])
        return boxModelEntity
    }
    
    @available(iOS 15.0, *)
    func updatePlaneEntity(with anchor: ARPlaneAnchor, in view: ARView) {

        var planeMesh: MeshResource
        let isPlaneHorizontal = anchor.alignment == .horizontal
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

        if isPlaneHorizontal {
            if  let firstEntity = modelEntity.children.first,
                UInt64(firstEntity.name) == modelEntity.id,
                let boxEntity = firstEntity as? ModelEntity
            {
                
                let width = (boxEntity.model?.mesh.bounds.max.x)! - (boxEntity.model?.mesh.bounds.min.x)!
                let height = (boxEntity.model?.mesh.bounds.max.y)! - (boxEntity.model?.mesh.bounds.min.y)!
                let depth = (boxEntity.model?.mesh.bounds.max.z)! - (boxEntity.model?.mesh.bounds.min.z)!
                                    
                boxEntity.position.y = height / 2.0
                
            } else {
                // print("\tanchorEntity: \(modelEntity)")
                let boxEntity = createBoxEntity(color: .red)
                boxEntity.name = String(modelEntity.id)
                
                let width = (boxEntity.model?.mesh.bounds.max.x)! - (boxEntity.model?.mesh.bounds.min.x)!
                let height = (boxEntity.model?.mesh.bounds.max.y)! - (boxEntity.model?.mesh.bounds.min.y)!
                let depth = (boxEntity.model?.mesh.bounds.max.z)! - (boxEntity.model?.mesh.bounds.min.z)!
                                    
                boxEntity.position.y = height / 2.0
                
                modelEntity.addChild(boxEntity)
                
                if let doorModelEntity = self.doorModelEntity, !self.hasDoorBeenPlaced {
                    self.hasDoorBeenPlaced = true
                    print("Added door")
                    doorModelEntity.transform.scale *= [0.2,0.2,0.2]
                    print("doorModelEntity.transform./scale: \(doorModelEntity.transform.scale)")
                    print("doorModelEntity.scale: \(doorModelEntity.scale)")
                    modelEntity.addChild(doorModelEntity)
                }
                
            }
        }
        
    }
    
    func updateImageEntity(with anchor: ARImageAnchor, in view: ARView) {
        self.firstImageAnchorIdentifidr = anchor.identifier.uuidString + "_image_anchor"
        guard let entity = view.scene.findEntity(named: anchor.identifier.uuidString + "_image_anchor"),
        let modelEntity = entity.children.first as? ModelEntity else { return }
        
        
        let physicalSize = anchor.referenceImage.physicalSize
        modelEntity.model!.mesh = .generatePlane(width: Float(physicalSize.width), depth: Float(physicalSize.height))
        
        if  let firstEntity = modelEntity.children.first,
            UInt64(firstEntity.name) == modelEntity.id,
            let boxEntity = firstEntity as? ModelEntity {
            
            let width = (boxEntity.model?.mesh.bounds.max.x)! - (boxEntity.model?.mesh.bounds.min.x)!
            let height = (boxEntity.model?.mesh.bounds.max.y)! - (boxEntity.model?.mesh.bounds.min.y)!
            let depth = (boxEntity.model?.mesh.bounds.max.z)! - (boxEntity.model?.mesh.bounds.min.z)!
                                
            boxEntity.position.y = height / 2.0
            //modelEntity.setPosition(anchor.transform.positionSIMD3(), relativeTo: nil)
            print("\t\t\tImageAnchorEntity.worldPosition: \(modelEntity.position(relativeTo: nil))")
            // initial
            // SIMD3<Float>(0.07171498, -1.286095, -0.37166595)
            // SIMD3<Float>(0.07171498, -1.286095, -0.37166595))
            print("\t\t\tworldAnchorEntityFotImage.worldPosition: \(worldAnchorEntityFotImage?.position(relativeTo: nil))")
            
            
        } else {
            // print("\tanchorEntity: \(modelEntity)")
            let boxEntity = createBoxEntity(color: .black)
            boxEntity.name = String(modelEntity.id)
            
            let width = (boxEntity.model?.mesh.bounds.max.x)! - (boxEntity.model?.mesh.bounds.min.x)!
            let height = (boxEntity.model?.mesh.bounds.max.y)! - (boxEntity.model?.mesh.bounds.min.y)!
            let depth = (boxEntity.model?.mesh.bounds.max.z)! - (boxEntity.model?.mesh.bounds.min.z)!
                                
            boxEntity.position.y = height / 2.0
            
            modelEntity.addChild(boxEntity)
            
            if let imageAnchorWorldPosition = self.firstImageAnchorWorldPositin, !hasWorldAnchorForImageBeenPlaced {
                self.hasWorldAnchorForImageBeenPlaced = true
                let worldAnchor = AnchorEntity(world: imageAnchorWorldPosition)
                let _boxEntity = createBoxEntity(color: .yellow)
                self.worldAnchorEntityFotImage = worldAnchor
                worldAnchor.addChild(_boxEntity)
                view.scene.addAnchor(worldAnchor)
            }
            
            
            print("\t\t\tImageAnchorEntity.worldPosition (initial): \(modelEntity.position(relativeTo: nil))")
            /*
            if let doorModelEntity = self.doorModelEntity, !self.hasDoorBeenPlaced {
                self.hasDoorBeenPlaced = true
                print("Added door")
                doorModelEntity.transform.scale *= [0.2,0.2,0.2]
                print("doorModelEntity.transform./scale: \(doorModelEntity.transform.scale)")
                print("doorModelEntity.scale: \(doorModelEntity.scale)")
                modelEntity.addChild(doorModelEntity)
            }
             */
        }
    }
}

import Foundation
import simd
import SceneKit


public extension matrix_float4x4 {
    func position() -> SCNVector3 {
        return SCNVector3(columns.3.x, columns.3.y, columns.3.z)
    }
    
    func orientation() -> SCNVector3 {
        return SCNVector3(columns.2.x, columns.2.y, columns.2.z)
    }
    
    func orientationSIMD3()-> SIMD3<Float> { [columns.2.x, columns.2.y, columns.2.z] }
    
    func positionSIMD3() -> SIMD3<Float> { [columns.3.x, columns.3.y, columns.3.z] }
}


