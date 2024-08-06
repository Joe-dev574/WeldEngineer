//
//  ProjectList.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/5/24.
//

import SwiftUI
import SwiftData

struct ProjectList: View {
    @Environment(\.modelContext) private var context
    @Query private var projects: [Project]
    init(sortOrder: SortOrder, filterString: String) {
        let sortDescriptors: [SortDescriptor<Project>] = switch sortOrder {
        case .status:
            [SortDescriptor(\Project.status), SortDescriptor(\Project.title)]
        case .title:
            [SortDescriptor(\Project.title)]
        case .priority:
            [SortDescriptor(\Project.priority)]
        case .location:
            [SortDescriptor(\Project.location)]
        }
        let predicate = #Predicate<Project> { project in
            project.title.localizedStandardContains(filterString)
            || project.location.localizedStandardContains(filterString)
            || filterString.isEmpty
        }
        _projects = Query(filter: predicate, sort: sortDescriptors)
    }
    
    var body: some View {
        
        Group {
            if projects.isEmpty {
              ContentUnavailableView("No Projects Available", systemImage: "atom")
            } else {
                List {
                    ForEach(projects) { project in
                        NavigationLink {
                            EditProjectView(project: project)
                        } label: {
                            HStack(spacing: 10) {
                                project.icon
                                VStack(alignment: .leading) {
                                    Text(project.title).font(.title2)
                                    Text(project.location).foregroundStyle(.secondary)
                                    if let priority = project.priority {
                                        HStack {
                                            ForEach(1..<priority, id: \.self) { _ in
                                                Image(systemName: "star")
                                                    .imageScale(.small)
                                                    .foregroundStyle(.red)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let project = projects[index]
                            context.delete(project)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    let preview = Preview(Project.self)
    preview.addExamples(Project.sampleProjects)
    return NavigationStack {
        ProjectList(sortOrder: .status, filterString: "")
    }
        .modelContainer(preview.container)
}
