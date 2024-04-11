//
//  ViewController.swift
//  OMDBMovies
//
//  Created by David Auld on 2024-04-10.
//

import UIKit
import Combine

class MovieListViewController: UIViewController {
  private let viewModel: MovieListViewModel
  private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?
  private var subscriptions = Set<AnyCancellable>()
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = UIImage(systemName: "popcorn")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let backgroundLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "OMDBMovies\nSearch for your favorite movies!"
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textColor = .label
    return label
  }()
  
  private let collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
    collectionView.backgroundColor = .clear
    return collectionView
  }()
  
  private let searchTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Search or enter movie name"
    textField.borderStyle = .roundedRect
    return textField
  }()
  
  private let activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    return activityIndicator
  }()
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Error"
    label.textColor = .red
    label.isHidden = true
    return label
  }()
  
  init(viewModel: MovieListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "OMDBMovies"
    
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    view.addSubview(activityIndicator)
    view.addSubview(searchTextField)
    view.addSubview(errorLabel)
    view.addSubview(backgroundImageView)
    view.addSubview(backgroundLabel)
    
    setupConstraints()
    setupObservers()
    setupDataSource()
  }
}
  
private extension MovieListViewController {
  func setupConstraints() {
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
      searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
      searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      errorLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      errorLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
      backgroundImageView.widthAnchor.constraint(equalToConstant: 100),
      backgroundImageView.heightAnchor.constraint(equalToConstant: 100),
      backgroundImageView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      backgroundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      backgroundLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 8),
      backgroundLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
    ])
  }
  
  func setupObservers() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        switch state {
        case .idle:
          self?.clearList()
          UIView.animate(withDuration: 0.5) {
            self?.errorLabel.isHidden = true
            self?.activityIndicator.isHidden = true
            self?.backgroundImageView.isHidden = false
            self?.backgroundLabel.isHidden = false
          }
        case .loading:
          UIView.animate(withDuration: 0.5) {
            self?.errorLabel.isHidden = true
            self?.activityIndicator.isHidden = false
            self?.backgroundImageView.isHidden = true
            self?.backgroundLabel.isHidden = true
          }
        case .success(let movies):
          UIView.animate(withDuration: 0.5) {
            self?.errorLabel.isHidden = true
            self?.activityIndicator.isHidden = true
            self?.backgroundImageView.isHidden = true
            self?.backgroundLabel.isHidden = true
          } completion: { _ in
            guard let searchResults = movies.searchResults else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
            snapshot.appendSections([0])
            snapshot.appendItems(searchResults)
            self?.dataSource?.apply(snapshot, animatingDifferences: true)
          }
        case .error(let error):
          UIView.animate(withDuration: 0.5) {
            self?.activityIndicator.isHidden = true
            self?.backgroundImageView.isHidden = true
            self?.backgroundLabel.isHidden = true
            self?.errorLabel.isHidden = false
          } completion: { _ in
            switch error {
            case .movieNotFound, .generalError:
              self?.errorLabel.text = "No movies found"
            case .tooManyResults:
              self?.errorLabel.text = "Too many results"
            }
            self?.clearList()
          }
        }
      }
      .store(in: &subscriptions)
    
    // Observe textfield changes - only search when user has typed more than 3 characters
    NotificationCenter.default.publisher(
      for: UITextField.textDidChangeNotification,
      object: searchTextField
    )
    .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
    .map { ($0.object as? UITextField)?.text  ?? "" }
    .sink { [weak self] searchTerm in
      if searchTerm.count > 3 {
        self?.viewModel.searchByTitle(title: searchTerm)
      } else {
        self?.viewModel.state = .idle
      }
    }
    .store(in: &subscriptions)
  }
  
  func setupDataSource() {
    dataSource = UICollectionViewDiffableDataSource(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in
        guard let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: MovieCell.identifier,
          for: indexPath
        ) as? MovieCell else {
          return UICollectionViewCell()
        }
        cell.configure(movie: itemIdentifier)
        return cell
      })
    collectionView.dataSource = dataSource
  }
  
  func clearList() {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
    snapshot.deleteAllItems()
    dataSource?.apply(snapshot, animatingDifferences: true)
  }
  
  static func createCollectionViewLayout() -> UICollectionViewLayout {
    let estimatedHeight: CGFloat = 100
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1),
      heightDimension: .estimated(estimatedHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
    return UICollectionViewCompositionalLayout(section: section)
  }
}
