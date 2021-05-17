//
//  UserRouter.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import Foundation
import Alamofire

enum UserRouter {
    case users(since:Int,perPage:Int)
}

extension UserRouter :Router {
  var method: HTTPMethod? {
    switch self {
    case .users:
      return .get
    }
  }
    var params: Parameters? {
        switch self {
        case .users(let since,let perPage):
            return ["since":since,"per_page":perPage]
        }
    }
    
  var path: String {
    switch self {
    case .users:
      return ServiceConstants.USERS
    }
  }
}
