//
//  Movies.swift
//  SelfResizingCells
//
//  Created by Jalil Fierro on 10/06/22.
//

import Foundation

enum Section : CaseIterable {
    case one
    case two
}

class Movies: Hashable {

    var name: String
    var showDetails = false
    var body: String

    init(name: String, body: String = "NA") {

        self.name = name
        self.body = body
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }

    static func == (lhs: Movies, rhs: Movies) -> Bool {
        return lhs.name == rhs.name
    }
}
