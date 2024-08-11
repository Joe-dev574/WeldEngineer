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
    @State private var engineer = ""
    @State private var location = ""
    @State private var projectSummary = ""
    @State private var dateAdded = Date.distantPast
    @State private var dateStarted = Date.distantPast
    @State private var dateCompleted = Date.distantPast
    @State private var firstView = true
    @State private var problemDefinition = ""
    @State private var showGenres = false
    
    var body: some View {
        List{
            HStack {
                Picker("Status", selection: $status) {
                    ForEach(Status.allCases) { status in
                        Text(status.descr).tag(status)
                    }
                }
                .buttonStyle(.bordered)
            }
            VStack(alignment: .leading) {
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
                TextField("", text: $engineer)
            } label: {
                Text("Engineer").foregroundStyle(.secondary)
            }
            Section("Problem Statement") {
                Text("Define the Problem:").foregroundStyle(.primary)
                TextEditor(text: $problemDefinition)
                    .padding(.horizontal)
                    .overlay(RoundedRectangle(cornerRadius:10).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
                    .frame(height: 120)
            }
            Section("Brief Summary") {
                Text(" Project Summary").foregroundStyle(.secondary)
                TextEditor(text: $projectSummary)
                    .padding(.horizontal)
                    .frame(height: 250)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(uiColor: .tertiarySystemFill), lineWidth: 2))
                if let genres = project.genres {
                    ViewThatFits {
                        GenresStackView(genres: genres)
                        ScrollView(.horizontal, showsIndicators: false) {
                            GenresStackView(genres: genres)
                        }
                    }
                }
                HStack {
                    Button("Labels", systemImage: "bookmark.fill") {
                        showGenres.toggle()
                    }.buttonStyle(.bordered)
                        .sheet(isPresented: $showGenres) {
                        GenreView(project: project)
                    }
                    
                    NavigationLink {
                        InvestigationsListView(project: project)
                    } label: {
                        let count = project.investigations?.count ?? 0
                        Label("^[\(count) Investigations](inflect: true)", systemImage: "quote.opening")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal)
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
                            project.engineer = engineer
                            project.problemDefinition = problemDefinition
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
                    engineer = project.engineer
                    problemDefinition = project.problemDefinition
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
                || location != project.location
                || engineer != project.engineer
                || problemDefinition != project.problemDefinition
                || projectSummary != project.projectSummary
                || dateAdded != project.dateAdded
                || dateStarted != project.dateStarted
                || dateCompleted != project.dateCompleted
            }
        }
    }
}
#Preview {
   let preview = Preview(Project.self)
  return NavigationStack {
    EditProjectView(project: Project.sampleProjects[4])
          .modelContainer(preview.container)
  }
}

