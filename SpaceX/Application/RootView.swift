//
//  RootView.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI
import Combine

struct RootView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var di: AppDIContainer
    @State private var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            LandingView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .launchesList:
                        LaunchList()
                    case .launchDetails(let id):
                        LaunchDetails(launchID: id)
                    case .favorites:
                        Favorites()
                    }
                }
        }
        .onAppear {
            coordinator.start()
            di.launchesRepository.debugFetchPastRaw()
                           .sink(receiveCompletion: { completion in
                               print("completion:", completion)
                           }, receiveValue: { data in
                               print("OK bytes:", data.count)
                               if let snippet = String(data: data.prefix(300), encoding: .utf8) {
                                   print("snippet:", snippet)
                               }
                           })
                           .store(in: &cancellables)
        }
    }
}

private struct LandingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("SpaceX")
                .font(.largeTitle).bold()
            Text("Bootstrapping…").foregroundColor(.secondary)
            ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
