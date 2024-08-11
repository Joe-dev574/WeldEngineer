//
//  WeldEngineerApp.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/3/24.
//

import SwiftUI
import SwiftData

@main
struct WeldEngineerApp: App {
    let container: ModelContainer
    
    var body: some Scene {
        WindowGroup {
            ProjectListView()
        }
        .modelContainer(for: Project.self)
    }
    
    init() {
        let schema = Schema([Project.self])
        let config = ModelConfiguration("Project", schema: schema)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not configure the container")
        }
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
