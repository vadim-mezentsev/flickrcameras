//
//  ModelsViewController.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

class ModelsViewController: UIViewController {
    
    var brandId: String!
    
    private let networkService = NetworkService()
    private var cameraModels = [FlickrCamera]() {
           didSet {
               self.tableView.reloadData()
           }
       }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        
        fetchModels()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Models"
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
        tableView.register(UINib(nibName: "ModelTableViewCell", bundle: nil), forCellReuseIdentifier: ModelTableViewCell.reuseId)
        tableView.register(UINib(nibName: "DetailModelTableViewCell", bundle: nil), forCellReuseIdentifier: DetailModelTableViewCell.reuseId)
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func fetchModels() {
        networkService.fetchCameraModels(for: brandId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cameraModels):
                    self?.cameraModels = cameraModels.cameras!.camera
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

extension ModelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cameraModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cameraModel = cameraModels[indexPath.row]
        
        if cameraModel.details == nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: ModelTableViewCell.reuseId) as! ModelTableViewCell
            cell.set(from: ModelTableViewCellModel(title: cameraModel.name.content,
                                                   imageUrl: cameraModel.images?.small?.content ?? ""))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailModelTableViewCell.reuseId) as! DetailModelTableViewCell
            cell.set(from: DetailModelTableViewCellModel(title: cameraModel.name.content,
                                                         megapixels: cameraModel.details?.megapixels?.content ?? "-",
                                                         screeenSize: cameraModel.details?.lcdScreenSize?.content ?? "-",
                                                         imageUrl: cameraModel.images?.large?.content ?? "",
                                                         memoryType: cameraModel.details?.memoryType?.content ?? "-"))
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension ModelsViewController: UITableViewDelegate {
    
}
