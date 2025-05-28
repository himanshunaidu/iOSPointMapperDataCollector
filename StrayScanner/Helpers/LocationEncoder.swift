//
//  LocationEncoder.swift
//  StrayScanner
//
//  Created by Himanshu on 5/28/25.
//  Copyright © 2025 Stray Robots. All rights reserved.
//

import CoreLocation

struct LocationData {
    let timestamp: Date
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let horizontalAccuracy: Double
    let verticalAccuracy: Double
    let speed: Double
    let course: Double
    let floorLevel: Int
}

struct HeadingData {
    let timestamp: Date
    let magneticHeading: Double
    let trueHeading: Double
    let headingAccuracy: Double
}
