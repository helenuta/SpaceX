//
//  LaunchDetails.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import SwiftUI

struct LaunchDetails: View {
    @EnvironmentObject private var di: AppDIContainer
       let launchID: String
       @StateObject private var vm: LaunchDetailsViewModel

       init(launchID: String) {
           self.launchID = launchID
           // Temporary construction (we’ll refactor injection to a factory later)
           _vm = StateObject(wrappedValue: LaunchDetailsViewModel(
               launchID: launchID,
               repo: AppDIContainer.make().launchesRepository,
               favorites: AppDIContainer.make().favoritesStore
           ))
       }

       var body: some View {
           LaunchDetailsView(vm: vm)
               .navigationTitle("Details")
               .navigationBarTitleDisplayMode(.inline)
       }
}
