//
//  Project .swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/3/24.
//

import SwiftUI
import SwiftData


@Model
class Project {
    var title: String
    var briefDescription: String
    var location: String
    var engineer: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var projectSummary: String
    var priority: Int?
    var status: Status.RawValue
    var problemDefinition:  String
    @Relationship(deleteRule: .cascade)
    var investigations: [Investigation]?
    @Relationship(inverse: \Genre.projects)
    var genres: [Genre]?
    
    init(
        title: String,
        briefDescription: String,
        location: String,
        engineer: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantFuture,
        projectSummary: String = "",
        priority: Int? = nil,
        status: Status = .queue,
        problemDefinition: String = ""
    ) {
        self.title = title
        self.briefDescription = briefDescription
        self.location = location
        self.engineer = engineer
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.projectSummary = projectSummary
        self.priority = priority
        self.status = status.rawValue
        self.problemDefinition = problemDefinition
    }
    var icon: Image {
        switch Status(rawValue: status)! {
        case .queue:
            Image(systemName: "questionmark.circle")
        case .active:
            Image(systemName: "a.circle")
        case .hold:
            Image(systemName: "exclamationmark.circle")
        case .complete:
            Image(systemName: "checkmark.rectangle.fill")
               
        }
    }
}

enum Status:  Int, Codable, Identifiable, CaseIterable {
    case queue, active, hold, complete
    var id: Self {
        self
    }
    var descr: String {
        switch self {
        case .queue:
            "Plan"
        case .active:
            "Active"
        case .hold:
            "Hold"
        case .complete:
            "Complete"
        }
    }
}
