//
//  UserListViewModel.swift
//  FpCodeChallenge
//
//  Created by Fariba on 5/16/21.
//

import Foundation
import Combine

class UserViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    private var disposables = Set<AnyCancellable>()
    private let userService: UserService

    init() {
        self.userService = UserService()
    }
    
    func fetchNextPageIfPossible() {
        guard state.canLoadNextPage else { return }
        fetchUsers()
            .sink(receiveCompletion: onReceive,receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            state.canLoadNextPage = false
        }
    }

    private func onReceive(_ batch: [User]) {
        state.users += batch
        state.since += state.since+batch.count
        state.canLoadNextPage = batch.count == state.perPage
    }
    
    private func fetchUsers()->AnyPublisher<[User],Error>{
        Future { promise in
            self.userService.fetchUserList(since: self.state.since,perPage: self.state.perPage){ data, error in
                if let users = data {
                    promise(.success(users))
                }
                if let err = error {
                    promise(.failure(err))
                }
             }
         }.eraseToAnyPublisher()
    }
}


struct State {
    var users: [User] = []
    var since: Int = 0
    var perPage:Int = 20
    var canLoadNextPage = true
  }
