//
//  MovieSearchViewController.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/1/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITextFieldDelegate {

	//MARK: - Class Properties
	static let movieTableViewControllerSegue = "MovieTableViewControllerEmbeddedSegue"
	
	//MARK: - Private Properties
	let movieDBRequest = MovieDBRequest()
	
	//MARK: - Public Properties
	@IBOutlet var searchField: UITextField!
	var movieTableViewController = MovieTableViewController()
	
	//MARK: Overridden Methods
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let segueIdentifier = segue.identifier {
			if segueIdentifier == MovieSearchViewController.movieTableViewControllerSegue {
				// If this is not a UITableViewController we have a serious problem...
				movieTableViewController = segue.destination as! MovieTableViewController
			}
		}
	}
}

//MARK: - UITextFieldDelegate
extension MovieSearchViewController {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if let searchText = textField.text {
			movieDBRequest.search(query: searchText) { [weak self] (movieResults) in
				guard let strongSelf = self else { return }
				
				if let movies = movieResults.results {
					strongSelf.movieTableViewController.movies = movies
				}
			}
		}
		return true
	}
}
