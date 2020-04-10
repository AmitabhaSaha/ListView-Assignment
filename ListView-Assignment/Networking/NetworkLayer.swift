//
//  NetworkLayer.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation
import UIKit.UIApplication


class NetworkLayer: NSObject {
    
    var urlSessionDefaultConfig: URLSession {
        get{
            
            let configuration: URLSessionConfiguration = URLSessionConfiguration.default
            
            configuration.waitsForConnectivity = false
            configuration.multipathServiceType = .none
            
            let delegate = SessionManagerDelegate()
            delegate.networkRequest = self
            
            return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        }
    }
    
    
    var didReceiveData: ((_ count: Int?) -> ())?
    var didFinishDownloadedData: ((_ data: Data?, _ error: Error?, _ request: URLRequest?, _ response: URLResponse?) -> ())?
    var didFinishWithError: (( _ error: Error?, _ request: URLRequest?, _ response: URLResponse?) -> ())?

    var isProgressing = false
    
    var request: HTTPrequest?
    
    internal var task: URLSessionTask?
    internal var resumeData: Data?
    internal var url: URL!
    
    // earliest begin date
    var earliestBeginDate: Date?
    
    public func resumeTask(){
        
        if let request = request, let url = URL.init(string: request.url){
            
            let urlRequest = NSMutableURLRequest.init(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
            urlRequest.httpMethod = request.method
            
            if let headers = request.headers {
                urlRequest.allHTTPHeaderFields = headers as? [String : String]
            }
            
            if let headers = request.headers as? [String: String] {
                for (key, value) in headers {
                    if urlRequest.value(forHTTPHeaderField: key) == nil {
                        urlRequest.setValue(value, forHTTPHeaderField: key)
                    }
                }
            }
            
            if let headers = request.body {
                do {
                    let data = try JSONSerialization.data(withJSONObject: headers, options:JSONSerialization.WritingOptions())
                    urlRequest.httpBody = data
                } catch {}
            }
            
            if let beginDate = earliestBeginDate{
                self.task?.earliestBeginDate = beginDate
            }
            
            self.task = urlSessionDefaultConfig.dataTask(with: urlRequest as URLRequest)
            
            print("==================================== REQUEST ====================================")
            print("Start Date: - \(Date())")
            print("Method: \(request.method)")
            print("URL: \(request.url)")
            print("Headers: \(urlRequest.allHTTPHeaderFields!)")
            print("=================================================================================")
            self.task?.resume()
        }
    }
    
    public func resumeTaskWithDownloadedData() {
        
        if let _ = self.task as? URLSessionDownloadTask{
            if let resumeData = resumeData{
                let downloadTask = urlSessionDefaultConfig.downloadTask(withResumeData: resumeData)
                self.task = downloadTask
                
            }else{
                let downloadTask = urlSessionDefaultConfig.downloadTask(with: self.url)
                self.task = downloadTask
            }
        }
        self.task?.resume()
    }
    
    public func cancel(){
        self.task?.cancel()
    }
    
    public func pause(){
        if self.isProgressing{
            
            if let task = self.task as? URLSessionDownloadTask{
                task.cancel(byProducingResumeData: { data in
                    self.resumeData = data
                })
            }
            
            self.isProgressing = false
        }
    }
}

