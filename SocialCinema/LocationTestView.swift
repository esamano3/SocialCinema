//
//  LocationTestView.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import SwiftUI
import CoreLocation

struct LocationTestView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Location Test")
                .font(.title)
            
            Text("Status: \(statusText)")
            
            if let location = locationManager.location {
                Text("Latitude: \(location.coordinate.latitude)")
                Text("Longitude: \(location.coordinate.longitude)")
            } else {
                Text("No location yet")
            }
            
            Text("Location: \(locationManager.locationName)")
            
            Button("Request Location") {
                locationManager.requestPermission()
                locationManager.startUpdatingLocation()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var statusText: String {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "Authorized Always"
        case .authorizedWhenInUse:
            return "Authorized When In Use"
        @unknown default:
            return "Unknown"
        }
    }
}

#Preview {
    LocationTestView()
}
