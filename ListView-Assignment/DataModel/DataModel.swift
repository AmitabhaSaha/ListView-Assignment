//
//  DataModel.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit.UIImage


struct ListModel: Codable {
    
    var title: String?
    var description: String?
    var imageHref: String?
}


struct ResponseModel: Codable {
    
    var title: String?
    var rows: [ListModel]?
}


class SharedData {
    
    static let instance = SharedData()
    
    private init() {}
    
    let cache = NSCache<NSString, UIImage>()
    
    func setToCache(image: UIImage, for path: String) {
        cache.setObject(image, forKey: NSString(string: path))
    }
    
    func getImageFromCache(for path: String) -> UIImage? {
        if let image = cache.object(forKey: NSString(string: path)) {
            return image
        } else {
            return nil
        }
    }
}
