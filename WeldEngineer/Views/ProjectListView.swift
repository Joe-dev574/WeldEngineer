//
//  Project ListView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/3/24.
//

import SwiftUI
import SwiftData


struct  ProjectListView: View {
    //MARK: Properties
    @State private var createNewProject = false
    @Query(sort: \Project.title) private var projects: [Project]
    @Environment(\.modelContext) private var context
    
    
    
    var body: some View {
        NavigationStack{
            Group {
                if projects.isEmpty{
                    ContentUnavailableView("No Available Projects", systemImage: "atom")
                        .tint(.accentColor)
                } else {
                    List {
                        ForEach(projects) { project in
                            NavigationLink{
                                Text(project.title)
                            } label: {
                                HStack(spacing: 10 ) {
                                    project.icon
                                    VStack(alignment: .leading){
                                        Text(project.title).font(.title2)
                                        Text(project.briefDescription).font(.callout)
                                        HStack{
                                            Text(project.label).font(.callout).foregroundStyle(.blue)
                                            Text(project.engineerAssigned).font(.callout).foregroundStyle(.gray)
                                        }
                                        
                                        if let priority = project.priority {
                                            HStack {
                                                ForEach(0..<priority, id: \.self) {
                                                    _ in
                                                    Image(systemName: "exclamationmark")
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
                    .padding()
                }
            }
                    .navigationTitle("Project List")
                    .fontDesign(.serif)
                    .toolbar {
                        Button(action: {
                            createNewProject = true
                        }, label: {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                        })
                    }
                    .sheet(isPresented: $createNewProject){
                        NewProjectView()
                            .presentationDetents([.medium])
                    }
                   
                }
            }
        }
    

#Preview {
    ProjectListView()
        .modelContainer(for: Project.self, inMemory: true)
}
