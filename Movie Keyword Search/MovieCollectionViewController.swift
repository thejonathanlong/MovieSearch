//
//  MovieCollectionViewController.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/2/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import UIKit

protocol MovieSelectionDelegate: class {
	func collectionViewController(_ collectionViewController: MovieCollectionViewController, didSelect movie: Movie)
}

//MARK: -
class MovieCollectionViewCell: UICollectionViewCell {
	
	//MARK: - Class Properties
	static let reuseIdentifier = "MovieCollectionViewCell"
	
	//MARK: - Public Properties
	@IBOutlet var posterImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var overviewLabel: UILabel!
	var imageLoadingOperation: BlockOperation?
	
	//MARK: - Private Properties
	private let placeholderImage = UIImage(named: "movie-placeholder")
	
	//MARK: - Overridden
	override func prepareForReuse() {
		super.prepareForReuse()
		posterImageView.image = placeholderImage
	}
	
}

//MARK: -
class MovieCollectionViewController: UICollectionViewController {

	//MARK: - Public Properties
	var movies: [Movie] = [] {
		didSet {
			guard let collectionView = collectionView else { return }
			collectionView.reloadData()
		}
	}
	
	weak var delegate: MovieSelectionDelegate?
	
	//MARK: - Private Properties
	private let imageLoadingQueue = OperationQueue()
}

// MARK: - UICollectionViewDataSource
extension MovieCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
	
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		// This better be a MovieCollectionViewCell or there is a big problem.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
    
		let movie = movies[indexPath.row]
		cell.titleLabel.text = movie.title
		cell.overviewLabel.text = movie.overview
		if let currentImageLoadingOperation = cell.imageLoadingOperation {
			currentImageLoadingOperation.cancel()
		}
		let imageLoadingOperation = BlockOperation {
			let posterImage = MovieDBRequest.shared.movieImage(movie: movie)
			DispatchQueue.main.async {
				cell.posterImageView.image = posterImage
			}
		}
		cell.imageLoadingOperation = imageLoadingOperation
		imageLoadingQueue.addOperation(imageLoadingOperation)
    
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MovieCollectionViewController {
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let movie = movies[indexPath.row]
		delegate?.collectionViewController(self, didSelect: movie)
		
	}
}
