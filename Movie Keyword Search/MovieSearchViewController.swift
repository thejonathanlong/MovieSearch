//
//  MovieSearchViewController.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/1/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITextFieldDelegate, MovieSelectionDelegate {

	//MARK: - Class Properties
	static let movieCollectionViewControllerSegue = "MovieCollectionViewSegue"
	static let movieDetailViewControllerShowSegue = "movieDetailViewControllerShowSegue"
	
	//MARK: - Private Properties
	private let movieDBRequest = MovieDBRequest.shared
	private var selectedMovie: Movie?
	
	//MARK: - Public Properties
	@IBOutlet var searchField: UITextField!
	@IBOutlet var loadingIndicatorView: UIActivityIndicatorView!
	var movieCollectionViewController = MovieCollectionViewController()
	
	//MARK: Overridden Methods
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let segueIdentifier = segue.identifier {
			switch segueIdentifier {
			case MovieSearchViewController.movieCollectionViewControllerSegue:
				movieCollectionViewController = segue.destination as! MovieCollectionViewController
				movieCollectionViewController.delegate = self
				
			case MovieSearchViewController.movieDetailViewControllerShowSegue:
				let movieDetailViewController = segue.destination as! MovieDetailViewController
				if let movie = selectedMovie {
					movieDetailViewController.movie = movie
				}
				
			default:
				break
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

//MARK: - MovieSelectionDelegate
extension MovieSearchViewController {
	func collectionViewController(_ collectionViewController: MovieCollectionViewController, didSelect movie: Movie) {
		selectedMovie = movie
		performSegue(withIdentifier: MovieSearchViewController.movieDetailViewControllerShowSegue, sender: self)
	}
}
