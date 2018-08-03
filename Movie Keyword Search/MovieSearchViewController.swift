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
	static let movieCollectionViewControllerSegue = "MovieCollectionViewSegue"
	
	//MARK: - Private Properties
	let movieDBRequest = MovieDBRequest.shared
	
	//MARK: - Public Properties
	@IBOutlet var searchField: UITextField!
	@IBOutlet var loadingIndicatorView: UIActivityIndicatorView!
	var movieCollectionViewController = MovieCollectionViewController()
	
	//MARK: Overridden Methods
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let segueIdentifier = segue.identifier {
			if segueIdentifier == MovieSearchViewController.movieCollectionViewControllerSegue {
				// If this is not a MovieCollectionViewController we have a serious problem...
				movieCollectionViewController = segue.destination as! MovieCollectionViewController
			}
		}
	}
}

//MARK: - UITextFieldDelegate
extension MovieSearchViewController {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if let searchText = textField.text {
			loadingIndicatorView.isHidden = false
			loadingIndicatorView.startAnimating()
			movieDBRequest.search(query: searchText) { [weak self] (movieResults) in
				DispatchQueue.main.async {
					guard let strongSelf = self else { return }
					if let movies = movieResults.results {
						strongSelf.movieCollectionViewController.movies = movies
					}
					strongSelf.loadingIndicatorView.stopAnimating()
					strongSelf.loadingIndicatorView.isHidden = true
				}
			}
		}
		return true
	}
}
