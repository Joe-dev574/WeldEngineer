//
//  Investigation.swift
//  WeldEngineer
//
//  Created by Joseph DeWeese on 8/9/24.
//

import Foundation
import SwiftData


@Model
class Investigation {
    var creationDate: Date = Date.now
    var investigationText: String
    var page: String?
    
    
//add picture attachments.   multiple attachments
    init(investigationText: String, page: String? = nil) {
        self.investigationText = investigationText
        self.page = page
    }
    
    var project: Project?
}
