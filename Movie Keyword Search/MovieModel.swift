//
//  MovieModel.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/1/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import Foundation

struct MovieResults: Decodable {
	var page: Int
	var total_results: Int
	var total_pages: Int
	var results: Array<Movie>?
	
	init() {
		page = 0
		total_results = 0
		total_pages = 0
		results = []
	}
}

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
	var genre_ids: Array<Int>?
	var backdrop_path: String?
	var adult: Bool?
}

/*
Example Response:
"id": 177572,
"video": false,
"vote_average": 7.8,
"title": "Big Hero 6",
"popularity": 34.524,
"poster_path": "/9gLu47Zw5ertuFTZaxXOvNfy78T.jpg",
"original_language": "en",
"original_title": "Big Hero 6",
"genre_ids": [
12,
10751,
16,
28,
35
],
"backdrop_path": "/2BXd0t9JdVqCp9sKf6kzMkr7QjB.jpg",
"adult": false,
"overview": "The special bond that develops between plus-sized inflatable robot Baymax, and prodigy Hiro Hamada, who team up with a group of friends to form a band of high-tech heroes.",
"release_date": "2014-10-24"
*/
