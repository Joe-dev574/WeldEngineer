//
//  InvestigationsListView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/9/24.
//

import SwiftUI
import SwiftData

struct InvestigationsListView: View {
    @Environment(\.modelContext) private var modelContainer
    @Environment(\.dismiss) var dismiss
    let project : Project
    @State private var investigationTitle = ""
    @State private var investigationText = ""
    @State private var page = ""
    @State private var selectedInvestigation: Investigation?
    var isEditing:  Bool {
        selectedInvestigation != nil
    }
    
    var body: some View {
        
        GroupBox {
            HStack {
                LabeledContent("Title") {
                    TextField("page #", text: $page)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 150)
                    Spacer()
                }
                if isEditing {
                    Button("Cancel") {
                        page = ""
                        investigationText = ""
                        selectedInvestigation = nil
                    }
                    .buttonStyle(.bordered)
                }
                Button(isEditing ? "Update" : "Create") {
                    if isEditing {
                        selectedInvestigation?.investigationText = investigationText
                        selectedInvestigation?.page = page.isEmpty ? nil : page
                        page = ""
                        investigationText = ""
                        selectedInvestigation = nil
                    } else {
                        let investigation = page.isEmpty ? Investigation(investigationText: investigationText) : Investigation(investigationText: investigationText, page: page)
                        project.investigations?.append(investigation)
                        investigationText = ""
                        page = ""
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(investigationText.isEmpty)
            }
            TextEditor(text: $investigationText)
                .border(Color.secondary)
                .frame(height: 200)
        }
        .padding(.horizontal, 1)
        List {
            let sortedInvestigations = project.investigations?.sorted(using: KeyPathComparator(\Investigation.creationDate)) ?? []
            ForEach(sortedInvestigations) { investigation in
                VStack(alignment: .leading) {
                    Text(investigation.creationDate, format: .dateTime.month().day().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(investigation.investigationText)
                    HStack {
                        Spacer()
                        if let page = investigation.page, !page.isEmpty {
                            Text("Page: \(page)")
                        }
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedInvestigation = investigation
                    investigationText = investigation.investigationText
                    page = investigation.page ?? ""
                }
            }
            .onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        let investigation = sortedInvestigations[index]
                        project.investigations?.forEach{ projectInvestigation in
                            if investigation.id == projectInvestigation.id {
                                modelContainer.delete(investigation)
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Investigations")
    }
}

#Preview {
    let preview = Preview(Project.self)
    let projects = Project.sampleProjects
    preview.addExamples(projects)
    return NavigationStack {
        InvestigationsListView(project: projects[4])
            .navigationBarTitleDisplayMode(.inline)
            .modelContainer(preview.container)
    }
}
