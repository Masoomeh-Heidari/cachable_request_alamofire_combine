//
//  UserService.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import Foundation


class UserService {
    private let requestManager =  RequestManager.sharedInstance
    private let decoder = JSONDecoder()

    public func fetchUserList(since: Int,perPage: Int, callBack: @escaping (_ list:[User]?, _ error:Error?)->Void){
        requestManager.fetchData(request: UserRouter.users(since: since,perPage: perPage)) { data, error in
            if let result = data {
                do{
                    let users = try self.decoder.decode([User].self, from: result)
                    callBack(users,nil)
                   }catch let err{
                    callBack(nil,err)
                }
            }
        }
    }
}
