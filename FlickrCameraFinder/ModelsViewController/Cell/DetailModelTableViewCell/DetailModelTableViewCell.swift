//
//  DetailModelTableViewCell.swift
//  FlickrCameraFinder
//
//  Created by Vadim on 17/11/2019.
//  Copyright © 2019 Vadim Mezentsev. All rights reserved.
//

import UIKit

struct DetailModelTableViewCellModel {
    let title: String
    let megapixels: String
    let screeenSize: String
    let imageUrl: String
    let memoryType: String
}

class DetailModelTableViewCell: UITableViewCell {

    static let reuseId = "DetailModelTableViewCellReuseId"
    static let nib = UINib(nibName: "DetailModelTableViewCell", bundle: nil)

    @IBOutlet private weak var cameraImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var megapixelsLabel: UILabel!
    @IBOutlet private weak var screeenSizeLabel: UILabel!
    @IBOutlet private weak var memoryTypeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func set(from model: DetailModelTableViewCellModel) {
        titleLabel.text = model.title
        megapixelsLabel.text = "Megapixels: " + model.megapixels
        screeenSizeLabel.text = "Screen size: " + model.screeenSize
        memoryTypeLabel.text = "Memory type: " + model.memoryType
        
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
