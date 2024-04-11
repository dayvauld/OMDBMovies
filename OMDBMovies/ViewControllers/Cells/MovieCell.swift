//
//  MovieCell.swift
//  OMDBMovies
//
//  Created by David Auld on 2024-04-10.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell {
  static let identifier: String = "MovieCell"
  
  let view = MovieView()
  
  override var isHighlighted: Bool {
    didSet {
      updateHighlightedState()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
      view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
      view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    view.reset()
  }
  
  func updateHighlightedState() {
    UIView.animate(withDuration: 0.2) { [weak self] in
      guard let self else { return }
      if self.isHighlighted {
        self.view.backgroundColor = .lightGray
      } else {
        self.view.backgroundColor = .secondarySystemBackground
      }
    }
  }
  
  func configure(movie: Movie) {
    view.configure(movie: movie)
  }
}

class MovieView: UIView {
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.numberOfLines = 1
    label.lineBreakMode = .byTruncatingTail
    label.textColor = UIColor.label
    return label
  }()
  
  private var yearLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .footnote)
    label.numberOfLines = 1
    label.lineBreakMode = .byWordWrapping
    label.textColor = UIColor.tertiaryLabel
    return label
  }()
  
  private var mediaTypeLabel: UILabel = {
    let label = UILabel()
    label.font = .preferredFont(forTextStyle: .caption1)
    label.numberOfLines = 1
    label.lineBreakMode = .byWordWrapping
    label.textColor = UIColor.quaternaryLabel
    label.setContentHuggingPriority(.defaultLow, for: .vertical)
    return label
  }()
  
  private var posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .gray
    imageView.layer.cornerRadius = 5
    imageView.image = UIImage(systemName: "movie.clapper")
    return imageView
  }()
  
  private lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [titleLabel, yearLabel, mediaTypeLabel])
    stack.axis = .vertical
    stack.alignment = .fill
    stack.spacing = 5.0
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .secondarySystemBackground
    self.layer.cornerRadius = 12
    self.layer.shadowRadius = 2
    self.layer.shadowOpacity = 0.1
    self.layer.shadowOffset = CGSize(width: 0, height: 4)
    self.layer.masksToBounds = false
    
    self.addSubview(posterImageView)
    self.addSubview(stackView)
    
    NSLayoutConstraint.activate([
      posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
      posterImageView.widthAnchor.constraint(equalToConstant: 40),
      posterImageView.heightAnchor.constraint(equalToConstant: 60),
      posterImageView.bottomAnchor.constraint(lessThanOrEqualTo: stackView.bottomAnchor, constant: 0),
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      stackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    let shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    self.layer.shadowPath = shadowPath
  }
  
  func configure(movie: Movie) {
    titleLabel.text = movie.title
    yearLabel.text = movie.year
    mediaTypeLabel.text = movie.type.capitalized
    
    if let posterUrl = URL(string: movie.poster) {
      posterImageView.loadImage(from: posterUrl)
    } else {
      posterImageView.image = .init(systemName:  "movie.clapper")
    }
  }
  
  func reset() {
    posterImageView.image = nil
  }
}
