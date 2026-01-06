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
        print("Handling \(updateType) for \(anchors.count) mesh anchors.")
    }
}
