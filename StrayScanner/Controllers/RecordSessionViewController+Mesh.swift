//
//  RecordSessionViewController+Mesh.swift
//  StrayScanner
//
//  Created by Himanshu on 1/6/26.
//  Copyright © 2026 Stray Robots. All rights reserved.
//

import ARKit
import RealityKit

enum MeshUpdateType {
    case add
    case update
    case remove
}

extension RecordSessionViewController {
    func handleMeshAnchors(_ anchors: [ARAnchor], updateType: MeshUpdateType) {
        if meshBundle == nil {
            initializeMeshBundle()
        }
        
        /// Throttle updates per anchor
        if Date().timeIntervalSince1970 - (meshBundle?.lastUpdated ?? 0) < updateInterval { return }
        let meshAnchors = anchors.compactMap { $0 as? ARMeshAnchor }
        print("Handling \(updateType) for \(meshAnchors.count) mesh anchors.")
        
        var triangles: [(SIMD3<Float>, SIMD3<Float>, SIMD3<Float>)] = []
        var triangleNormals: [SIMD3<Float>] = []
        
        for meshAnchor in meshAnchors {
            let geometry = meshAnchor.geometry

            let faces = geometry.faces
            
            let transform = meshAnchor.transform

            for index in 0..<faces.count {
                /// Each face is a triangle (3 indices)
                let face = faces[index]

                let v0 = worldVertex(at: Int(face[0]), geometry: geometry, transform: transform)
                let v1 = worldVertex(at: Int(face[1]), geometry: geometry, transform: transform)
                let v2 = worldVertex(at: Int(face[2]), geometry: geometry, transform: transform)
                
                let edge1 = v1 - v0
                let edge2 = v2 - v0
                let normal = normalize(cross(edge1, edge2))
                
                triangles.append((v0, v1, v2))
                triangleNormals.append(normal)
            }
        }
        /// Step 2: Compute mean normal
        guard !triangles.isEmpty else { return }
        
        if let fullEntity = createHorizontalMeshEntity(
            triangles: triangles, color: meshBundle?.assignedColor ?? .green, opacity: 0.25, name: "FullMesh"
        ) {
            meshBundle?.fullEntity = fullEntity
        }
    }
    
    func initializeMeshBundle() {
        let anchorEntity = AnchorEntity(world: .zero)
        let fullEntity = ModelEntity()
        anchorEntity.addChild(fullEntity)
        
        let assignedColor = generateRandomColor()
        
        meshBundle = MeshBundle(
            anchorEntity: anchorEntity, fullEntity: fullEntity,
            lastUpdated: 0, assignedColor: assignedColor
        )
    }
    
    private func generateRandomColor() -> UIColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    func worldVertex(at index: Int, geometry: ARMeshGeometry, transform: simd_float4x4) -> SIMD3<Float> {
        let vertices = geometry.vertices
        let vertexPointer = vertices.buffer.contents().advanced(by: vertices.offset + (vertices.stride * Int(index)))
        let vertex = vertexPointer.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        let worldVertex4D = (transform * SIMD4(vertex.x, vertex.y, vertex.z, 1.0))
        return SIMD3(worldVertex4D.x, worldVertex4D.y, worldVertex4D.z)
    }
    
    func createHorizontalMeshEntity(
        triangles: [(SIMD3<Float>, SIMD3<Float>, SIMD3<Float>)],
        color: UIColor = .green,
        opacity: Float = 0.4,
        name: String = "HorizontalMesh"
    ) -> ModelEntity? {
        if (triangles.isEmpty) {
            return nil
        }
        
        var positions: [SIMD3<Float>] = []
        var indices: [UInt32] = []

        for (i, triangle) in triangles.enumerated() {
            let baseIndex = UInt32(i * 3)
            positions.append(triangle.0)
            positions.append(triangle.1)
            positions.append(triangle.2)
            indices.append(contentsOf: [baseIndex, baseIndex + 1, baseIndex + 2])
        }

        var meshDescriptors = MeshDescriptor(name: name)
        meshDescriptors.positions = MeshBuffers.Positions(positions)
        meshDescriptors.primitives = .triangles(indices)
        guard let mesh = try? MeshResource.generate(from: [meshDescriptors]) else {
            return nil
        }

        let material = UnlitMaterial(color: color.withAlphaComponent(CGFloat(opacity)))
        let entity = ModelEntity(mesh: mesh, materials: [material])
        return entity
    }
}
