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
	
	//MARK: - Private Properties
	var posterImageViewWidthConstraint = NSLayoutConstraint()
	var posterImageViewHeightConstraint = NSLayoutConstraint()
	
	//MARK: - Overridden Methods
	override func updateConstraints() {
		if let image = posterImage {
			posterImageViewWidthConstraint = posterImageView.widthAnchor.constraint(equalToConstant: image.size.width)
			posterImageViewHeightConstraint = posterImageView.heightAnchor.constraint(equalToConstant: image.size.height)
			posterImageViewHeightConstraint.isActive = true
			posterImageViewWidthConstraint.isActive = true
		}
		super.updateConstraints()
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
		
		
		return cell
	}

}
