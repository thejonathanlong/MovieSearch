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
	
	//MARK: - Private properties
	private let session = URLSession(configuration: .default)
	private var currentTask: URLSessionDataTask?
	private var imageEndPoint: String?
	private let imageSize = "original"
	private let imageCache = NSCache<NSString, UIImage>()
	
	//MARK: - Public Propertis
	static let shared = MovieDBRequest()
	
	//MARK: - Initializers
	private override init() {
		super.init()
		configuration { [weak self] (movieConfig) in
			guard let strongSelf = self else { return }
			strongSelf.imageEndPoint = movieConfig.secure_base_url
			strongSelf.imageCache.countLimit = 15
		}
	}
}

//MARK: - Public Methods
extension MovieDBRequest {
	func search(query: String, completion: @escaping (MovieResults) -> Void) {
		get(endPoint: MovieDBRequest.searchEndPoint, query: query, decodeBlock:nil) { (results: MovieResults?) in
			if let movieResults = results {
				print(movieResults)
				completion(movieResults)
			}
			else {
				completion(MovieResults())
			}
		}
	}
	
	func movieImage(movie: Movie) -> UIImage? {
		guard let posterPath = movie.poster_path, let imageEndPoint = imageEndPoint, let imageURL = URL(string: imageEndPoint + imageSize + posterPath) else { return nil }
		if let cachedImage = imageCache.object(forKey: posterPath as NSString) {
			return cachedImage
		}
		
		do {
			let d = try Data(contentsOf: imageURL)
			if let image = UIImage(data: d) {
				imageCache.setObject(image, forKey: posterPath as NSString)
				return image
			}
		}
		catch let error as NSError {
			print("Error getting image for movie \(movie). Error: \(error)")
		}
		
		return nil
	}
}

//MARK: - Private Methods
extension MovieDBRequest {
	private func get<T: Decodable>(endPoint: String, query: String?, decodeBlock: ((Data) -> T)?, completion: @escaping (T?) -> ()) {
		//Cancel the current task
		currentTask?.cancel()
		
		if var components = URLComponents(string: endPoint) {
			if let query = query {
				components.query = "api_key=\(MovieDBRequest.publicAPIKey)&query=\(query)"
			}
			else {
				components.query = "api_key=\(MovieDBRequest.publicAPIKey)"
			}
			
			guard let url = components.url else { completion(nil); return; }
			
			currentTask = session.dataTask(with: url) { (data, response, error) in
				defer { self.currentTask = nil }
				
				if let error = error {
					print("There was an error with the request: \(error).")
					completion(nil)
					return
				}
				
				if let data = data {
					if let decodeBlock = decodeBlock {
						let results = decodeBlock(data)
						completion(results)
					}
					else {
						do {
							let results = try JSONDecoder().decode(T.self, from: data)
							completion(results)
						} catch let jsonError {
							print("Failed to decode Json with error \(jsonError)")
							completion(nil)
						}
					}
				}
			}
			currentTask?.resume()
		}
	}
	
	private func configuration(completion: @escaping (MovieConfiguration) -> Void) {
		get(endPoint: MovieDBRequest.configurationEndPoint, query: nil, decodeBlock: { (data) -> MovieConfiguration in
			var movieConfiguration = MovieConfiguration()
			do {
				let results = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]
				if let results = results, let root = results[MovieConfiguration.rootKey] {
					let resultsData = try JSONSerialization.data(withJSONObject: root, options: JSONSerialization.WritingOptions.init(rawValue: 0))
					movieConfiguration = try JSONDecoder().decode(MovieConfiguration.self, from: resultsData)
				}
				
			} catch let jsonError {
				print("Failed to decode Json with error \(jsonError)")
			}
			return movieConfiguration
		}) { (movieConfiguration) in
			if let movieConfiguration = movieConfiguration {
				completion(movieConfiguration)
			}
			else
			{
				completion(MovieConfiguration())
			}
		}
	}
}
