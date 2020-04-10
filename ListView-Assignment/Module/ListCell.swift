//
//  ListCell.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UITableViewCell {
 
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkGray
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
 
 
     private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .gray
        lbl.font = UIFont.systemFont(ofSize: 13)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
     }()
 
 
     private let itemImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
     }()
 
    var model: ListModel?
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.addSubview(itemImage)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(descriptionLabel)
        
        
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        itemImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        itemImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0).isActive = true
        itemImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        self.contentView.setContentHuggingPriority(UILayoutPriority(rawValue: 750), for: .vertical)
        self.itemImage.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 250), for: .vertical)
        
        titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.itemImage.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
    
        
        descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.itemImage.trailingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
    }
 
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }
    
    func setDataModel(model: ListModel) {
        self.model = model
        
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.description
    }
    
    func clearImage() {
        itemImage.image = nil
    }
    
    func loadImageIfRequired(from url: String? ) {
        itemImage.image = nil
        guard let url = url else {
            DispatchQueue.main.async {
                self.itemImage.contentMode = .center
                self.itemImage.image = #imageLiteral(resourceName: "noimagefound")
            }
            return
        }
        
        if let image = SharedData.instance.getImageFromCache(for: url) {
            
            DispatchQueue.main.async {
                self.itemImage.image = image
                self.itemImage.contentMode = .scaleAspectFill
                self.itemImage.clipsToBounds = true
            }
            
        } else {
            
            APIManager.getImage(with: url) { (result) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        
                        self.itemImage.image = image
                        self.itemImage.contentMode = .scaleAspectFill
                        self.itemImage.clipsToBounds = true
                        SharedData.instance.setToCache(image: image!, for: url)
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.itemImage.contentMode = .center
                        self.itemImage.image = #imageLiteral(resourceName: "noimagefound")
                    }
                }
            }
        }
    }
}


