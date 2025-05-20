//
//  Camera_PhotosApp.swift
//  Camera Photos
//
//  Created by William Liu on 2025-05-18.
//

import SwiftUI
import SwiftData

@main
struct Camera_PhotosApp: App {
    var body: some Scene {
        WindowGroup {
            PhotosListView()
        }
        .modelContainer(for: SampleModel.self)
    }
}
