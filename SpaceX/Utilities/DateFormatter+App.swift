//
//  DateFormatter+App.swift
//  SpaceX
//
//  Created by Elena Anghel on 23.08.2025.
//

import Foundation

enum AppDateFormatter {
    static let launchShort: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        df.locale = .current
        return df
    }()
}
