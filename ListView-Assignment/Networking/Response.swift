//
//  Response.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit

extension HTTPrequest {
    
    public func response<T: Decodable>( decodeTo: T.Type = T.self, completion: @escaping ((_ data: T?, _ response: URLResponse?, _ error: Error?) -> ())) {
        let networkManager = NetworkLayer()
        networkManager.request = self
        networkManager.resumeTask()
        networkManager.didFinishDownloadedData = { (data, error, request, response) in
            if let error = error {
                completion(nil, response, error)
            } else {
                do {
                    let decodedModel = try JSONDecoder().decode(T.self, from: data!)
                    completion(decodedModel, response, error)
                    
                } catch {
                    completion(nil, response, ResponseError.serializationError)
                }
            }
        }
    }
    
    public func responseImage( completion: @escaping ((_ image: UIImage?, _ response: URLResponse?, _ error: Error?) -> ())) {
        let networkManager = NetworkLayer()
        networkManager.request = self
        networkManager.resumeTask()
        networkManager.didFinishDownloadedData = { (data, error, request, response) in
            if let error = error {
                completion(nil, response, error)
            } else {
                
                if let data = data,
                    let image = UIImage.init(data: data) {
                    completion(image, response, error)
                } else {
                    completion(nil, response, ResponseError.APIError)
                }
            }
        }
    }
}

