//
//  TheaterMapViewModel.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import Foundation
import CoreLocation
import MapKit

@MainActor
class TheaterMapViewModel: ObservableObject {
    @Published var mapItem: TheaterMapItem?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let geocoder = CLGeocoder()

    func geocodeTheater(_ theater: Theater) {
        isLoading = true
        errorMessage = nil
        mapItem = nil

        geocoder.cancelGeocode()

        geocoder.geocodeAddressString(theater.address) { [weak self] placemarks, error in
            guard let self = self else { return }

            self.isLoading = false

            if let error = error {
                self.errorMessage = "Could not load map for this theater: \(error.localizedDescription)"
                return
            }

            guard let coordinate = placemarks?.first?.location?.coordinate else {
                self.errorMessage = "Could not find coordinates for this theater."
                return
            }

            self.mapItem = TheaterMapItem(
                name: theater.name,
                address: theater.address,
                distance: theater.distance,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
    }
}
