//
//  FpCodeChallengeApp.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import SwiftUI

@main
struct FpCodeChallengeApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: UserViewModel())
        }
    }
}
