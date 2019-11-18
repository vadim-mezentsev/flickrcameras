//
//  ViewController.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

class BrandsViewController: UIViewController {
    
    // MARK: - Storage properties
    
    private let networkService = NetworkService()
    private var timer: Timer?
    
    private var brands = [Brand]()
    private var cameras = [Camera]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    private var currentSearchBarText: String = ""
    
    // MARK: - Interface properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.isUserInteractionEnabled = false
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your search returned no results"
        return label
    }()
    
    // MARK: - Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupActivityIndicator()
        setupTableView()
        setupNoResultsLabel()
        fetchBrands()
    }
    
    // MARK: - Interface preparation
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Flickr cameras"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CameraTableViewCell.nib, forCellReuseIdentifier: CameraTableViewCell.reuseId)
        tableView.register(CameraDetailTableViewCell.nib, forCellReuseIdentifier: CameraDetailTableViewCell.reuseId)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func setupNoResultsLabel() {
        view.addSubview(noResultsLabel)
        
        noResultsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        noResultsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    }
    
    private func prepareForStartFetching() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        tableView.isHidden = true
        noResultsLabel.isHidden = true
    }
    
    private func prepareForFinishFetching() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        tableView.isHidden = cameras.isEmpty ? true : false
        noResultsLabel.isHidden = cameras.isEmpty && !currentSearchBarText.isEmpty ? false : true
    }
    
    // MARK: - Fetch models
    
    private func fetchBrands() {
        
        prepareForStartFetching()
        networkService.fetchBrands(completionQueue: DispatchQueue.main) { [weak self] result in
            switch result {
            case .success(let cameraBrands):
                self?.brands = cameraBrands.brands!.brand
                self?.prepareForFinishFetching()
                self?.searchController.searchBar.isUserInteractionEnabled = true
                self?.searchController.searchBar.becomeFirstResponder()
            case .failure(let error):
                print(error.message)
                self?.informAlert(title: "Error", message: error.message) { [weak self] _ in
                    self?.fetchBrands()
                }
            }
        }
    }
    
    private func fetchModels(for brands: [Brand]) {
        
        let searchText = self.currentSearchBarText
        
        prepareForStartFetching()
        networkService.fetchCameras(completionQueue: DispatchQueue.main, for: brands){ [weak self] result in
            
            guard searchText == self?.currentSearchBarText else { return }
            
            switch result {
            case .success(let cameras):
                self?.cameras = cameras
                self?.prepareForFinishFetching()
            case .failure(let error):
                print(error.message)
                self?.informAlert(title: "Error", message: error.message, handler: nil)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension BrandsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let camera = cameras[indexPath.row]
        
        let cell = camera.details == nil ? prepareDefaultCell(tableView, for: camera) :
                                            prepareDetailCell(tableView, for: camera)
        return cell
    }
    
    private func prepareDefaultCell(_ tableView: UITableView, for camera: Camera) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CameraTableViewCell.reuseId) as! CameraTableViewCell
        cell.set(from: CameraTableViewCellModel(title: camera.name.content,
                                               imageUrl: camera.images?.small?.content ?? ""))
        return cell
    }
    
    private func prepareDetailCell(_ tableView: UITableView, for camera: Camera) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CameraDetailTableViewCell.reuseId) as! CameraDetailTableViewCell
        cell.set(from: CameraDetailTableViewCellModel(title: camera.name.content,
                                                     megapixels: camera.details?.megapixels?.content ?? "-",
                                                     screeenSize: camera.details?.lcdScreenSize?.content ?? "-",
                                                     imageUrl: camera.images?.large?.content ?? "",
                                                     memoryType: camera.details?.memoryType?.content ?? "-"))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BrandsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
}

// MARK: - UISearchBarDelegate

extension BrandsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [unowned self] _ in
            self.currentSearchBarText = searchText
            let filteredBrands = self.brands.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            self.fetchModels(for: filteredBrands)
        }
    }
    
}
