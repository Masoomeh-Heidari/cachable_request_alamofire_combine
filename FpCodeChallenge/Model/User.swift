//
//  User.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    var avatar_url: String?
    var login: String
    var id: Int
    
    
}
