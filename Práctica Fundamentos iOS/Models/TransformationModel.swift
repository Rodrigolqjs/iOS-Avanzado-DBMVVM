//
//  Transformation.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 19/6/22.
//

import Foundation

struct Transformation: ModelDisplayable, Decodable {
  let photo: URL
  let id: String
  let name: String
  let description: String
}
