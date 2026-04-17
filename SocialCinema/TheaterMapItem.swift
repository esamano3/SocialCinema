//
//  TheaterMapItem.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import Foundation
import CoreLocation

struct TheaterMapItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let address: String
    let distance: String?
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
