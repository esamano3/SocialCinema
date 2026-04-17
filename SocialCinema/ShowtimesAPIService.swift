import Foundation

enum ShowtimesError: LocalizedError {
    case noShowtimesFound
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .noShowtimesFound:
            return "No showtimes were found for this movie and location."
        case .invalidURL:
            return "The showtimes request URL was invalid."
        }
    }
}

class ShowtimesAPIService {
    
    private let baseURL = "https://serpapi.com/search.json"
    private let apiKey = "dummyToken" // temporary for testing
    
    func fetchShowtimes(movieTitle: String, location: String, completion: @escaping (Result<[Theater], Error>) -> Void) {
        let query = "\(movieTitle) showtimes \(location)"
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedLocation = location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "\(baseURL)?engine=google&q=\(encodedQuery)&location=\(encodedLocation)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(ShowtimesError.invalidURL))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(ShowtimesError.noShowtimesFound))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ShowtimesResponse.self, from: data)
                let theaters = decoded.showtimes?.first?.theaters ?? []
                
                DispatchQueue.main.async {
                    if theaters.isEmpty {
                        completion(.failure(ShowtimesError.noShowtimesFound))
                    } else {
                        completion(.success(theaters))
                    }
                }
            } catch {
                print("Showtimes decoding error:", error)
                if let rawJSON = String(data: data, encoding: .utf8) {
                    print("Raw response:", rawJSON)
                }
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        .resume()
    }
}
