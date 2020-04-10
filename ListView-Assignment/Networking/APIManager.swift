//
//  APIManager.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation


import Foundation
import UIKit

enum Request {
    case listAPI
    
    var baseURL: String {
        return "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl"
    }
    
    var listPath: String {
        return "/facts.json"
    }
    
    func getRequest() -> HTTPrequest {
        switch self {
            
        case .listAPI:
            return HTTPrequest(url: baseURL + listPath, headers: nil, body: nil)
        }
    }
}

class APIManager {
    
    typealias ListCompletion = ((Result<ResponseModel?,ResponseError>)->())
    typealias ImageCompletion = ((Result<UIImage?,ResponseError>)->())
    
    typealias APICompletion = ((_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ())
    
    //TODO: - Check off line
    static func getListData(completion: @escaping ListCompletion) {
        
        let request = Request.listAPI.getRequest()
        request.response(decodeTo: ResponseModel.self) { (model, response, error) in
            if let _ = error {
                completion(.failure(.APIError))
            } else {
                completion(.success(model))
            }
        }
    }
    
    static func getImage(with path: String, completion: @escaping ImageCompletion) {
        
        let request = HTTPrequest(url: path, headers: nil, body: nil)
        request.responseImage() { (image, response, error) in
            if let _ = error {
                completion(.failure(.APIError))
            } else {
                completion(.success(image))
            }
        }
    }
}
