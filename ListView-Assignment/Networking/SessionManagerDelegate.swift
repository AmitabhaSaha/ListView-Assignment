//
//  SessionManagerDelegate.swift
//  ListView-Assignment
//
//  Created by Amitabha Saha on 10/04/20.
//  Copyright © 2020 Amitabha. All rights reserved.
//

import Foundation


final public class SessionManagerDelegate: NSObject, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    var networkRequest: NetworkLayer?
    var data: NSMutableData?
    public var queue: OperationQueue!
    
    public override init() {
        data = NSMutableData()
        self.queue = {
            let queue = OperationQueue()
            queue.maxConcurrentOperationCount = 1
            queue.isSuspended = true
            return queue
        }()
    }
    
    
    //MARK: - Download Delegate -
    
    // Stores downloaded file
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // File is downloaded to ***location*** url
        print("File downloaded to : \(location.absoluteString)")

        do {
            self.data = NSMutableData()
            let downloaded = try Data(contentsOf: location)
            self.data?.append(downloaded)
        }catch {}
    }
    
    // Progress checking - Manually
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        // task has to be Dwonload task
        print("Download: \(totalBytesWritten):\(totalBytesExpectedToWrite)")
    }
    
    //MARK: - Data Delegate -
    // Progress checking - Manually
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("Data: \(totalBytesSent):\(totalBytesExpectedToSend)")
    }
    
    // Did finish download with error
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let networkRequest = networkRequest{
            networkRequest.isProgressing = false
            if let error = error{
                self.data = nil
                networkRequest.didFinishWithError?(error, task.originalRequest, task.response)
            }else{
                
                print(self.data?.length ?? 0)
                networkRequest.didFinishDownloadedData?(self.data as Data?, nil, task.originalRequest, task.response)
                self.data = nil
            }
        }
    }
    
    // Did receive data
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        self.queue.isSuspended = false
        
        if let selfdata = self.data{
            selfdata.append(data)
        }else{
            self.data = NSMutableData()
            self.data?.append(data)
        }
        
        if let networkRequest = networkRequest{
            networkRequest.isProgressing = true
            networkRequest.didReceiveData?((self.data?.length ?? 0))
        }
        
        self.queue.isSuspended = true
    }
}

