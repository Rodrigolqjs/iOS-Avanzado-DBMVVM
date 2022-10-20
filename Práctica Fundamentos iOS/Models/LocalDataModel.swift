//
//  LocalDataModel.swift
//  Práctica Fundamentos iOS
//
//  Created by Juan Cruz Guidi on 19/6/22.
//

import Foundation

private enum Constants {
  static let tokenKey = "KCToken"
}

final class LocalDataModel {

  private static let userDefaults = UserDefaults.standard
  
  static func getToken() -> String? {
    userDefaults.string(forKey: Constants.tokenKey)
  }
  
  static func save(token: String) {
    userDefaults.set(token, forKey: Constants.tokenKey)
  }
  
  static func deleteToken() {
    userDefaults.removeObject(forKey: Constants.tokenKey)
  }
}
