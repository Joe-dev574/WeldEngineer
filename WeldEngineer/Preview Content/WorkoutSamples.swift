//
//  WorkoutSamples.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/4/24.
//


import Foundation

extension Project {
    static let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date.now)!
    static let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date.now)!
    static var sampleProjects:[Project] {
        [
            Project(title: "6005A Aluminum Qualification", briefDescription: "Develop WPS", location: "White River Marine Group", engineer: "JDeWeese", dateAdded: Date.distantPast, projectSummary: "TBD"),
            Project(title: "6005A Aluminum Qualification", briefDescription: "Develop WPS", location:  "White River Marine Group", engineer: "JDeWeese", dateAdded: Date.distantPast, projectSummary: "TBD"),
            Project(title: "6005A Aluminum Qualification", briefDescription: "Develop WPS", location: "White River Marine Group", engineer: "JDeWeese", dateAdded: Date.distantPast, projectSummary: "TBD"),
            Project(title: "6005A Aluminum Qualification", briefDescription: "Develop WPS", location:  "White River Marine Group", engineer: "JDeWeese", dateAdded: Date.distantPast, projectSummary: "TBD"),
            Project(title: "6005A Aluminum Qualification", briefDescription: "Develop WPS", location: "White River Marine Group", engineer: "JDeWeese", dateAdded: Date.distantPast, projectSummary: "TBD"),
            Project(title: "6005A Aluminum Qualification", briefDescription: "Develop WPS", location: "White River Marine Group", engineer: "JDeWeese", dateAdded: Date.distantPast, projectSummary: "TBD"),
        ]
    }
}
