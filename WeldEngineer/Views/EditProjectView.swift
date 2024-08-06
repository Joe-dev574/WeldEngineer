//
//  EditProjectView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/4/24.
//

import SwiftUI

struct EditProjectView: View {
    @Environment(\.dismiss) private var dismiss
    let project: Project
    @State private var status = Status.queue
    @State private var priority: Int?
    @State private var title = ""
    @State private var briefDescription = ""
    @State private var engineerAssigned = ""
    @State private var location = ""
    @State private var projectSummary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    
    var body: some View {
        HStack {
            Text("Status")
            Picker("Status", selection: $status) {
                ForEach(Status.allCases) { status in
                    Text(status.descr).tag(status)
                }
            }
            .buttonStyle(.bordered)
        }
        VStack(alignment: .leading) {
            GroupBox {
                LabeledContent {
                    DatePicker("", selection: $dateAdded, displayedComponents: .date)
                } label: {
                    Text("Date Added")
                }
                if status == .active || status == .complete {
                    LabeledContent {
                        DatePicker("", selection: $dateStarted, in: dateAdded..., displayedComponents: .date)
                    } label: {
                        Text("Date Started")
                    }
                }
                if status == .complete {
                    LabeledContent {
                        DatePicker("", selection: $dateCompleted, in: dateStarted..., displayedComponents: .date)
                    } label: {
                        Text("Date Completed")
                    }
                }
            }
            .foregroundStyle(.secondary)
            .onChange(of: status) { oldValue, newValue in
                        if !firstView {
                    if newValue == .queue{
                        dateStarted = Date.distantPast
                        dateCompleted = Date.distantPast
                    } else if newValue == .active && oldValue == .complete {
                        // from completed to inProgress
                        dateCompleted = Date.distantPast
                    } else if newValue == .active && oldValue == .queue{
                        // Book has been started
                        dateStarted = Date.now
                    } else if newValue == .complete && oldValue == .queue {
                        // Project Placed on Hold or cancelled
                        dateCompleted = Date.now
                        dateStarted = dateAdded
                    } else {
                        // completed
                        dateCompleted = Date.now
                    }
                    firstView = false
                }
            }
            Divider()
            LabeledContent {
                PriorityView(maxPriority: 5 , currentPriority: $priority, width: 35)
                 
            } label: {
                Text("Priority")
            }
            .padding(.horizontal)
            LabeledContent {
                TextField("", text: $title)
            } label: {
                Text("Title").foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField("", text: $briefDescription)
            } label: {
                Text("Project Description").foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField("", text: $location)
            } label: {
                Text("Location").foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField("", text: $engineerAssigned)
            } label: {
                Text("Author").foregroundStyle(.secondary)
            }
            Divider()
            Text(" Project Summary").foregroundStyle(.secondary)
            TextEditor(text: $projectSummary)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if changed {
                Button("Update") {
                    project.status = status.rawValue
                    project.priority = priority
                    project.title = title
                    project.briefDescription = briefDescription
                    project.location = location
                    project.engineerAssigned = engineerAssigned
                    project.projectSummary    = projectSummary
                    project.dateAdded = dateAdded
                    project.dateStarted = dateStarted
                    project.dateCompleted = dateCompleted
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            status = Status(rawValue: project.status)!
            priority = project.priority
            title = project.title
            briefDescription = project.briefDescription
            location = project.location
            engineerAssigned = project.engineerAssigned
            projectSummary = project.projectSummary
            dateAdded = project.dateAdded
            dateStarted = project.dateStarted
            dateCompleted = project.dateCompleted
        }
    }
    
    var changed: Bool {
        status != Status(rawValue: project.status)!
        || priority != project.priority
        || title != project.title
        || briefDescription != project.briefDescription
        || location != location
        || engineerAssigned != project.engineerAssigned
        || projectSummary != project.projectSummary
        || dateAdded != project.dateAdded
        || dateStarted != project.dateStarted
        || dateCompleted != project.dateCompleted
    }
}

#Preview {
   let preview = Preview(Project.self)
  return NavigationStack {
    EditProjectView(project: Project.sampleProjects[4])
          .modelContainer(preview.container)
  }
}

