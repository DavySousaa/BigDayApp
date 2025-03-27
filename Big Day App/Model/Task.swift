//
//  Task.swift
//  Big Day App
//
//  Created by Davy Sousa on 15/03/25.
//
import Foundation

class Task: Codable {
    var id: Int
    var title: String
    var time: String?
    var isCompleted: Bool
    
    init(id: Int, title: String, time: String?, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.time = time
        self.isCompleted = isCompleted
    }
}
