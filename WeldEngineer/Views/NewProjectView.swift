//
//  NewProjectView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/3/24.
//

import SwiftUI

struct NewProjectView: View {
    //MARK: Properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var briefDescription = ""
    @State private var label = ""
    @State private var engineerAssigned = ""
    
    
    var body: some View {
        NavigationStack {
            Form{
                TextField("Project Title", text: $title)
                    .textFieldStyle(.roundedBorder)
                TextField("Brief Description", text: $briefDescription)
                    .textFieldStyle(.roundedBorder)
                TextField("Location", text: $label)
                    .textFieldStyle(.roundedBorder)
                TextField("Engineer Assigned", text: $engineerAssigned)
                    .textFieldStyle(.roundedBorder)
                Button("Create") {
                    let newProject = Project(title: title, briefDescription: briefDescription, label: label, engineerAssigned: engineerAssigned)
                    context.insert(newProject)
                    dismiss()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .disabled(title.isEmpty || briefDescription.isEmpty)
                .navigationTitle("New Project")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NewProjectView()
}
