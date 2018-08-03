//
//  MovieTableViewController.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/1/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import UIKit

//MARK: -
class MovieTableViewCell: UITableViewCell {
	
	//MARK: - Public Properties
	@IBOutlet var posterImageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var overviewLabel: UILabel!
	var posterImage: UIImage? {
		set (image) {
			posterImageView.image = image
		}
		get {
			return posterImageView.image
		}
	}
	weak var imageLoadingOperation: BlockOperation?
	
	//MARK: - Private Properties
	var posterImageViewWidthConstraint = NSLayoutConstraint()
	var posterImageViewHeightConstraint = NSLayoutConstraint()
	
	//MARK: - Overridden Methods
//	override func updateConstraints() {
//		if let image = posterImage {
//			posterImageViewWidthConstraint = posterImageView.widthAnchor.constraint(equalToConstant: image.size.width)
//			posterImageViewWidthConstraint.isActive = true
//		}
//		super.updateConstraints()
//	}
	
	override func prepareForReuse() {
		imageLoadingOperation = nil
		super.prepareForReuse()
	}
}

//MARK: -
class MovieTableViewController: UITableViewController {

	//MARK: - Public Properties
	var movies: [Movie] = [] {
		didSet {
			DispatchQueue.main.async { [weak self] in
				guard let strongSelf = self else { return }
				strongSelf.tableView.reloadData()
			}
		}
	}
	
	let imageLoadingQueue = OperationQueue()
}

// MARK: - UITableViewDataSource
extension MovieTableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return movies.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// If these are not MovieTableViewCells we have a problem
		let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCellReuseIdentifier", for: indexPath) as! MovieTableViewCell
		let movie = movies[indexPath.row]
		cell.titleLabel.text = movie.title
		cell.overviewLabel.text = movie.overview
		if let currentImageLoadingOperation = cell.imageLoadingOperation {
			currentImageLoadingOperation.cancel()
		}
		let imageLoadingOperation = BlockOperation {
			let posterImage = MovieDBRequest.shared.movieImage(movie: movie)
			DispatchQueue.main.async {
				cell.posterImage = posterImage
			}
		}
		cell.imageLoadingOperation = imageLoadingOperation
		imageLoadingQueue.addOperation(imageLoadingOperation)

		return cell
	}

}
