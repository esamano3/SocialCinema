import SwiftUI
import MapKit

struct TheaterMapView: View {
    let theater: Theater
    let showType: String
    let selectedTime: String

    @StateObject private var viewModel = TheaterMapViewModel()
    @State private var position: MapCameraPosition = .automatic
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 16) {
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading theater map...")
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
            } else if let item = viewModel.mapItem {
                Map(position: $position) {
                    Marker(item.name, coordinate: item.coordinate)
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 10) {
                    Text(item.name)
                        .font(.title3)
                        .fontWeight(.bold)

                    Text(item.address)
                        .foregroundStyle(.secondary)

                    if let distance = item.distance, !distance.isEmpty {
                        Text("Distance: \(distance)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Divider()

                    Text("Selected Showtime")
                        .font(.headline)

                    Text("\(showType): \(selectedTime)")
                        .font(.body)

                    if let link = theater.link,
                       let url = URL(string: link) {
                        Button {
                            openURL(url)
                        } label: {
                            Label("Buy Tickets", systemImage: "ticket")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 8)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            } else {
                Spacer()
                Text("No map data available.")
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .navigationTitle("Theater Map")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.geocodeTheater(theater)
        }
        .onChange(of: viewModel.mapItem) { _, newValue in
            if let newValue {
                position = .region(
                    MKCoordinateRegion(
                        center: newValue.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
    }
}
