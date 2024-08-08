//
//  Project ListView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/3/24.
//

import SwiftUI
import SwiftData

enum SortOrder: String, Identifiable, CaseIterable {
    case status, title, location
    
    var id: Self {
        self
    }
}
struct  ProjectListView: View {
    //MARK: Properties
    @State private var createNewProject = false
    @State private var sortOrder = SortOrder.status
    @State private var filter = ""
    
    var body: some View {
        NavigationStack{
            Picker("", selection: $sortOrder) {
                ForEach(SortOrder.allCases) {  sortOrder in
                    Text("\(sortOrder.rawValue)").tag(sortOrder)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ProjectList(sortOrder: sortOrder, filterString: filter)
                .searchable(text: $filter, prompt: Text("Filter with Title or Assigned Engineer"))

                    .navigationTitle("Project List")
                    .navigationBarTitleDisplayMode(.inline)
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
    let preview = Preview(Project.self)
    preview.addExamples(Project.sampleProjects)
   return  ProjectListView()
        .modelContainer(preview.container)
}
