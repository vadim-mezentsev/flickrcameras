//
//  ModelTableViewCell.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 15/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

struct ModelTableViewCellModel {
    let title: String
    let imageUrl: String
}

class ModelTableViewCell: UITableViewCell {
    
    static let reuseId = "ModelTableViewCellReuseId"
    static let nib = UINib(nibName: "ModelTableViewCell", bundle: nil)

    @IBOutlet private weak var cameraImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func set(from model: ModelTableViewCellModel) {
        titleLabel?.text = model.title
        
        if let url = URL(string: model.imageUrl) {
            cameraImageView.setImage(from: url)
        }
    }

    private func setup() {
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        cameraImageView.image = UIImage(systemName: "camera.fill")
    }

}
