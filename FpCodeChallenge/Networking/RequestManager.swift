//
//  Networking.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import Foundation
import Alamofire

class RequestManager {

    static let sharedInstance = RequestManager()
    
    let retryLimit = 5
    let retryDelay: TimeInterval = 10
    private let cache: URLCache
    private let sessionManager: Session

    init() {
        cache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 200 * 1024 * 1024, diskPath: nil)
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = cache
        configuration.timeoutIntervalForRequest = 15
        sessionManager = Session(configuration: configuration)
    }

    func fetchData(request: URLRequestConvertible ,callBack: @escaping (_ response: Data? , _ error: Error?) -> Void ) {
        sessionManager.request(request).validate().responseJSON { response in
            switch(response.result){
                case .success:
                    if let data = response.data {
                        callBack(data,nil)
                    }
                case .failure(let error):
                    if error.responseCode == NSURLErrorNotConnectedToInternet {
                        let urlRequest = try? response.request?.asURLRequest()
                        if let data = self.cache.cachedResponse(for: urlRequest!)?.data {
                            callBack(data,nil)
                        }else {
                            callBack(nil,error)
                        }
                    }
            }
        }
    }
}

extension RequestManager :RequestInterceptor {
    func retry(_ request: Request,for session: Session,dueTo error: Error,completion: @escaping (RetryResult) -> Void) {
      let response = request.task?.response as? HTTPURLResponse
      //Retry for 5xx status codes
      if
        let statusCode = response?.statusCode,
        (500...599).contains(statusCode),
        request.retryCount < retryLimit {
          completion(.retryWithDelay(retryDelay))
      } else {
        return completion(.doNotRetry)
      }
    }
}
