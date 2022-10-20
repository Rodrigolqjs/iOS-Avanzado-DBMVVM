//
//  HeroModel.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 18/6/22.
//

import Foundation

struct Hero: ModelDisplayable, Decodable {
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}
