//
//  MovieDetailViewController.swift
//  Movie Keyword Search
//
//  Created by Jonathan Long on 8/2/18.
//  Copyright © 2018 Jonathan Long. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

	//MARK: - Public Properties
	@IBOutlet var posterImageView: UIImageView!
	@IBOutlet var releaseDateLabel: UILabel!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var overviewLabel: UILabel!
	@IBOutlet var contentScrollView: UIScrollView!
	@IBOutlet var containerStackView: UIStackView!
	var movie: Movie = Movie()

	//MARK: - Overridden
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		posterImageView.image = MovieDBRequest.shared.movieImage(movie: movie)
		titleLabel.text = movie.title
		overviewLabel.text = movie.overview
		releaseDateLabel.text = movie.release_date
		
		let size = containerStackView.systemLayoutSizeFitting(view.frame.size)
		let topinset = view.frame.size.height - (3.1 * size.height)
		contentScrollView.contentInset = UIEdgeInsets(top: topinset, left: 0, bottom: -(size.height - 55), right: 0)
	}
	
	override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
    }

}
