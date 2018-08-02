//
//  MovieDBRequest.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/1/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import UIKit

class MovieDBRequest: NSObject {
	//MARK: - Class Properties
	private static let publicAPIKey = "876db37c9eb2be92a162285d2d985373"
	private static let searchEndPoint = "https://api.themoviedb.org/3/search/movie"
	private static let configurationEndPoint = "https://api.themoviedb.org/3/configuration"
	
	//MARK: - Public Properties
	var imageEndPoint = {
		return ""
	}
	
	//MARK: - Private properties
	private let session = URLSession(configuration: .default)
	private var currentTask: URLSessionDataTask?
}

//MARK: - Public Methods
extension MovieDBRequest {
	func search(query: String, completion: @escaping (MovieResults) -> Void) {
		//Cancel the current task
		currentTask?.cancel()
		
		if var components = URLComponents(string: MovieDBRequest.searchEndPoint) {
			components.query = "api_key=\(MovieDBRequest.publicAPIKey)&query=\(query)"
			guard let url = components.url else { completion(MovieResults()); return; }
			
			currentTask = session.dataTask(with: url) { (data, response, error) in
				defer { self.currentTask = nil }
				
				if let error = error {
					print("There was an error with the request: \(error).")
					completion(MovieResults())
					return
				}
				
				if let data = data {
					do {
						let movieResults = try JSONDecoder().decode(MovieResults.self, from: data)
						print("Data \(data)")
						print("Movie \(movieResults)")
						completion(movieResults)
					} catch let jsonError {
						print("Failed to decode Json with error \(jsonError)")
						completion(MovieResults())
					}
				}
				
			}
			currentTask?.resume()
		}
	}
}

//MARK: - Private Methods
extension MovieDBRequest {
	private func get<T: Decodable>(endPoint: String, query: String, completion: @escaping (T?) -> ()) {
		//Cancel the current task
		currentTask?.cancel()
		
		if var components = URLComponents(string: endPoint) {
			components.query = "api_key=\(MovieDBRequest.publicAPIKey)&query=\(query)"
			guard let url = components.url else { completion(nil); return; }
			
			currentTask = session.dataTask(with: url) { (data, response, error) in
				defer { self.currentTask = nil }
				
				if let error = error {
					print("There was an error with the request: \(error).")
					completion(nil)
					return
				}
				
				if let data = data {
					do {
						let results = try JSONDecoder().decode(T.self, from: data)
						print("Data \(data)")
						print("Movie \(movieResults)")
						completion(movieResults)
					} catch let jsonError {
						print("Failed to decode Json with error \(jsonError)")
						completion(MovieResults())
					}
				}
				
			}
			currentTask?.resume()
		}
	}
}
