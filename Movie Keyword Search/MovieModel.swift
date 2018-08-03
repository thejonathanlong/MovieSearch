//
//  MovieModel.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/1/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import Foundation

//MARK: -
struct MovieResults: Decodable {
	var page: Int
	var total_results: Int
	var total_pages: Int
	var results: [Movie]?
	
	//MARK: - Initializers
	init() {
		page = 0
		total_results = 0
		total_pages = 0
		results = []
	}
}

//MARK: -
struct Movie: Decodable {
	var id: Int?
	var title: String?
	var poster_path: String?
	var overview: String?
	var release_date: String?
	var video: Bool?
	var vote_average: Double?
	var popularity: Double?
	var original_language: String?
	var original_title: String?
	var genre_ids: [Int]?
	var backdrop_path: String?
	var adult: Bool?
}

//MARK: -
struct MovieConfiguration: Decodable {
	//MARK: - Static Properties
	static let rootKey = "images"
	
	//MARK: - Public Properties
	var base_url: String?
	var secure_base_url: String?
	var backdrop_sizes: [String]?
	var logo_sizes: [String]?
	var profile_sizes: [String]?
	var change_keys: [String]?
	
}

/*http://image.tmdb.org/t/p/w185/9gLu47Zw5ertuFTZaxXOvNfy78T.jpg
{"images":{"base_url":"http://image.tmdb.org/t/p/","secure_base_url":"https://image.tmdb.org/t/p/","backdrop_sizes":["w300","w780","w1280","original"],"logo_sizes":["w45","w92","w154","w185","w300","w500","original"],"poster_sizes":["w92","w154","w185","w342","w500","w780","original"],"profile_sizes":["w45","w185","h632","original"],"still_sizes":["w92","w185","w300","original"]},"change_keys":["adult","air_date","also_known_as","alternative_titles","biography","birthday","budget","cast","certifications","character_names","created_by","crew","deathday","episode","episode_number","episode_run_time","freebase_id","freebase_mid","general","genres","guest_stars","homepage","images","imdb_id","languages","name","network","origin_country","original_name","original_title","overview","parts","place_of_birth","plot_keywords","production_code","production_companies","production_countries","releases","revenue","runtime","season","season_number","season_regular","spoken_languages","status","tagline","title","translations","tvdb_id","tvrage_id","type","video","videos"]}
*/
