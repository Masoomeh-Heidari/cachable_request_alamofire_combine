//
//  Router.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import Foundation
import Alamofire

protocol Router:URLRequestConvertible {
  var baseURLString :String? { get }
  var method: HTTPMethod? { get }
  var path: String {get }
  var headers: HTTPHeaders? { get }
  var encoding: ParameterEncoding? { get }
  var params: Parameters? { get }
  func asURLRequest() throws -> URLRequest
}

extension Router {
  
  var baseURLString: String? {
    return  ServiceConstants.BASE_URL
  }
  
  var method: HTTPMethod? {
    return .post
  }
  
  var path: String {
    return ""
  }
  
  var headers: HTTPHeaders? {
    return [:]
  }
  
  var encoding: ParameterEncoding? {
    return JSONEncoding.default
  }
  
  var params: Parameters? {
    return [:]
  }
  
  // MARK: URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = URL(string: self.baseURLString!.appending(path))
    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = method?.rawValue
    urlRequest.allHTTPHeaderFields = headers?.dictionary
    urlRequest.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

    if self.method == .get {
      urlRequest = try URLEncoding.queryString.encode(urlRequest, with: self.params)
    }else {
      urlRequest.httpBody = try JSONSerialization.data(withJSONObject: self.params ?? [:], options: .prettyPrinted)
    }
    return urlRequest
  }
}
