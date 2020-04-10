//
//  DataModel.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation

struct ListModel: Codable {
    
    var title: String?
    var description: String?
    var imageHref: String?
}


struct ResponseModel: Codable {
    
    var title: String?
    var rows: [ListModel]?
}
