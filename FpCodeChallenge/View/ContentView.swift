//
//  ContentView.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: UserViewModel
    
    var body: some View {
        UserList(
            users: viewModel.state.users,
            isLoading: viewModel.state.canLoadNextPage,
            onScrolledAtBottom: viewModel.fetchNextPageIfPossible
        )
        .onAppear(perform: viewModel.fetchNextPageIfPossible)
    }
}

struct UserList: View {
    let users: [User]
    let isLoading: Bool
    let onScrolledAtBottom: () -> Void
    
    var body: some View {
        List {
            userList
            if isLoading {
                loadingIndicator
            }
        }
    }
    
    private var userList: some View {
        ForEach(users) { user in
            UserRow(user: user).onAppear {
                if self.users.last == user {
                    self.onScrolledAtBottom()
                }
            }
        }
    }
    
    private var loadingIndicator: some View {
        Spinner(style: .medium)
            .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack {
            if let avatar = user.avatar_url{
                WebImage(url: URL(string: avatar)).resizable()
                    .placeholder {
                        Circle().foregroundColor(.gray)}
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
            Text(user.login).font(.title)
        }.frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .leading)
    }
    
}

