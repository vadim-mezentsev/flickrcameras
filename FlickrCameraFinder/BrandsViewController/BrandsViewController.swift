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
            self.table.reloadData()
        }
    }
    
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
    
    @IBOutlet private weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
        setupActivityIndicator()
        
        fetchBrands()
    }
    
    private func setupNavigationBar() {
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
        table.delegate = self
        table.dataSource = self
        table.register(BrandTableViewCell.self, forCellReuseIdentifier: BrandTableViewCell.reuseId)
        table.rowHeight = 50
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
