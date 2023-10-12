//
//  WeatherAPIClient.swift
//  hw3-liveapidata
//
//  Created by Runwei Wang on 10/10/23.
//

import Foundation

class APIClient {
    
    private let headers = [
        "X-RapidAPI-Key": "a70b094452msh4f1ca93c187a070p19227ajsne3d4bf56c8f9",
        "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com"
    ]
    
    func fetchData(for city: String, days: Int) async throws -> (Data?, URLResponse?, Error?) {
        let urlString = "https://weatherapi-com.p.rapidapi.com/forecast.json?q=\(city)&days=\(days)"
        
        guard let url = URL(string: urlString) else {
            return (nil, nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return try await withCheckedThrowingContinuation { continuation in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                continuation.resume(with: .success((data, response, error)))
            }
            task.resume()
        }
    }
}
