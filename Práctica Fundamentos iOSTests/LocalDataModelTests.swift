//
//  Pra_ctica_Fundamentos_iOSTests.swift
//  Práctica Fundamentos iOSTests
//
//  Created by Juan Cruz Guidi on 24/6/22.
//

import XCTest
@testable import Práctica_Fundamentos_iOS

private enum Constants {
  static let testToken = "testToken"
}

final class LocalDataModelTests: XCTestCase {
  
  override func tearDownWithError() throws {
    LocalDataModel.deleteToken()
  }
  
  func testSaveToken() throws {
    LocalDataModel.save(token: Constants.testToken)
    let retrievedToken = LocalDataModel.getToken()
    XCTAssertEqual(retrievedToken, Constants.testToken, "Retrieved token should be equal to test one")
  }
  
  func testDeleteToken() throws {
    LocalDataModel.save(token: Constants.testToken)
    LocalDataModel.deleteToken()
    let retrievedToken = LocalDataModel.getToken()
    XCTAssertNil(retrievedToken, "There should be no token retrieved")
  }
  
}
