//
//  Aparence.swift
//  Big Day App
//
//  Created by Davy Sousa on 29/03/25.
//

import Foundation

class Aparence: Codable {
    var id: Int
    var title: String
    var isCompleted: Bool
    
    init(id: Int, title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

