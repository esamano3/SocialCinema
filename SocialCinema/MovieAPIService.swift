//
//  MovieAPIService.swift
//  SocialCinema
//
//  Created by Joseph Loveall (Student) on 4/17/26.
//

import Foundation

class MovieAPIService {
    
    private let baseURL = "https://api.themoviedb.org/3/search/movie"
    private let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiYzNlNDA1NzU1MmY4YjYxOWRiZmQ5NGRlYmJkZjFiMiIsIm5iZiI6MTc3NjI3OTgxOC4yMjg5OTk5LCJzdWIiOiI2OWRmZTEwYWM4M2JhNTkxZDUyZDk5Y2IiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.U4AGLLArU6W2IfdeaifL3_n3_e1nT0bkMtWg7L_kDJ0"
    // temporary for testing
    
    func fetchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?query=\(queryEncoded)&language=en-US&page=1"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(decoded.results))
                }
                
            } catch {
                print("DECODING ERROR:", error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
