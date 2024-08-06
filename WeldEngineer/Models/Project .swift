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
    var engineerAssigned: String
    var dateAdded: Date
    var dateStarted: Date
    var dateCompleted: Date
    var projectSummary: String
    var priority: Int?
    var status: Status.RawValue
    
    init(
        title: String,
        briefDescription: String,
        location: String,
        engineerAssigned: String,
        dateAdded: Date = Date.now,
        dateStarted: Date = Date.distantPast,
        dateCompleted: Date = Date.distantFuture,
        projectSummary: String = "",
        priority: Int? = nil,
        status: Status = .queue
    ) {
        self.title = title
        self.briefDescription = briefDescription
        self.location = location
        self.engineerAssigned = engineerAssigned
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.projectSummary = projectSummary
        self.priority = priority
        self.status = status.rawValue
    }
    var icon: Image {
        switch Status(rawValue: status)! {
        case .queue:
            Image(systemName: "calendar")
        case .active:
            Image(systemName: "calendar.badge.clock")
        case .hold:
            Image(systemName: "calendar.badge.exclamationmark")
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
