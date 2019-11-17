//
//  ViewController.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 14/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

class BrandsViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private var brands = [FlickrCameraBrand]()
    
    private var filteredBrands = [FlickrCameraBrand]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
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
        return searchController
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTableView()
        setupActivityIndicator()
        fetchBrands()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Brands"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
        view.bringSubviewToFront(activityIndicator)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: BrandTableViewCell.reuseId)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.rowHeight = 50
    }
    
    private func fetchBrands() {
        networkService.fetchCameraBrands { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cameraBrands):
                    self?.brands = cameraBrands.brands!.brand
                    self?.filteredBrands = cameraBrands.brands!.brand
                case .failure(let error):
                    print(error.message)
                    // TODO: show alert
                }
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension BrandsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredBrands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.reuseId) as! BrandTableViewCell
        let brandName = filteredBrands[indexPath.row].name
        let cellModel = BrandTableViewCellModel(brandName: brandName)
        cell.set(from: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BrandsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brandId = brands[indexPath.row].id
        
        let ModelsViewControler = ModelsViewController()
        ModelsViewControler.brandId = brandId
        
        navigationController?.pushViewController(ModelsViewControler, animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UISearchBarDelegate

extension BrandsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredBrands = brands
        } else {
            filteredBrands = brands.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
