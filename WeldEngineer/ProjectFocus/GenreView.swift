//
//  ProjectFocusView.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/10/24.
//

import SwiftData
import SwiftUI

struct GenreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Bindable var project: Project
    @Query(sort: \Genre.name) var genres: [Genre]
    @State private var newGenre = false
    var body: some View {
        NavigationStack {
            Group {
                if genres.isEmpty {
                    ContentUnavailableView {
                        Image(systemName: "bookmark.fill")
                            .font(.largeTitle)
                    } description: {
                        Text("You need to create some labels first.")
                    } actions: {
                        Button("Create Label") {
                            newGenre.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(genres) { genre in
                            HStack {
                                if let projectGenres = project.genres {
                                    if projectGenres.isEmpty {
                                        Button {
                                            addRemove(genre)
                                        } label: {
                                            Image(systemName: "circle")
                                        }
                                        .foregroundStyle(genre.hexColor)
                                    } else {
                                        Button {
                                            addRemove(genre)
                                        } label: {
                                            Image(systemName: projectGenres.contains(genre) ? "circle.fill" : "circle")
                                        }
                                        .foregroundStyle(genre.hexColor)
                                    }
                                }
                                Text(genre.name)
                            }
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                if let projectGenres = project.genres,
                                   projectGenres.contains(genres[index]),
                                   let projectGenreIndex = projectGenres.firstIndex(where: {$0.id == genres[index].id}) {
                                    project.genres?.remove(at: projectGenreIndex)
                                }
                                context.delete(genres[index])
                            }
                        })
                        LabeledContent {
                            Button {
                                newGenre.toggle()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                            }
                            .buttonStyle(.borderedProminent)
                        } label: {
                            Text("Create new Label")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(project.title)
            .sheet(isPresented: $newGenre) {
                NewGenreView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addRemove(_ genre: Genre) {
        if let projectGenres = project.genres {
            if projectGenres.isEmpty {
                project.genres?.append(genre)
            } else {
                if projectGenres.contains(genre),
                   let index = projectGenres.firstIndex(where: {$0.id == genre.id}) {
                    project.genres?.remove(at: index)
                } else {
                    project.genres?.append(genre)
                }
            }
        }
    }
}

#Preview {
    let preview = Preview(Project.self)
    let projects = Project.sampleProjects
    let genres = Genre.sampleGenres
    preview.addExamples(genres)
    preview.addExamples(projects)
    projects[1].genres?.append(genres[0])
    return GenreView(project: projects[1])
}
