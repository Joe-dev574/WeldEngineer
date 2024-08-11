//
//  Genere.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/10/24.
//

import SwiftUI
import SwiftData

@Model
class Genre {
    var name: String
    var color: String
    var projects: [Project]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .red
    }
}

