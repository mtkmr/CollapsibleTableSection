//
//  SectionsData.swift
//  CollapsibleTableSection
//
//  Created by Masato Takamura on 2021/09/24.
//

import Foundation

struct Row {
    var name: String
}

struct Section {
    var name: String
    var rows: [Row]
    var collapsed: Bool

    init(name: String, rows: [Row], collapsed: Bool = true) {
        self.name = name
        self.rows = rows
        self.collapsed = collapsed
    }
}
