import XCTest
@testable import Práctica_Fundamentos_iOS

enum ErrorMock: Error {
  case mockCase
}

class NetworkModelTests: XCTestCase {
  
  private var urlSessionMock: URLSessionMock!
  private var sut: NetworkModel!
  
  override func setUpWithError() throws {
    urlSessionMock = URLSessionMock()
    
      sut = NetworkModel(urlSession: urlSessionMock)
  }
  
  override func tearDownWithError() throws {
    sut = nil
  }
  
  func testLoginFailWithNoData() {
    var error: NetworkError?
    
    urlSessionMock.data = nil
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .noData)
  }
  
  func testLoginFailWithError() {
    var error: NetworkError?
    
    urlSessionMock.data = nil
    urlSessionMock.error = ErrorMock.mockCase
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .other)
  }
  
  func testLoginFailWithErrorCodeNil() {
    var error: NetworkError?
    
    urlSessionMock.data = "TokenString".data(using: .utf8)!
    urlSessionMock.response = nil
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .errorCode(nil))
  }
  
  func testLoginFailWithErrorCode() {
    var error: NetworkError?
    
    urlSessionMock.data = "TokenString".data(using: .utf8)!
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 404, httpVersion: nil, headerFields: nil)
    
    sut.login(user: "", password: "") { _, networkError in
      error = networkError
    }
    
    XCTAssertEqual(error, .errorCode(404))
  }
  
  func testLoginSuccessWithMockToken() {
    var error: NetworkError?
    var retrievedToken: String?
    
    urlSessionMock.error = nil
    urlSessionMock.data = "TokenString".data(using: .utf8)!
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.login(user: "", password: "") { token, networkError in
      retrievedToken = token
      error = networkError
    }

    XCTAssertEqual(retrievedToken, "TokenString", "Se debe haber recibido un Token")
    XCTAssertNil(error, "No deberia haber un error")
  }
  
  func testGetHerosSuccess() {
    var error: NetworkError?
    var retrievedHeroes: [Hero]?
    
    sut.token = "testToken"
    urlSessionMock.data = getHeroesData(resourceName: "heroes")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.getHeroes { heroes, networkError in
      error = networkError
      retrievedHeroes = heroes
    }
    
    XCTAssertEqual(retrievedHeroes?.first?.id, "Hero ID", "Debe ser el mismo Heroe que el de el JSON")
    XCTAssertNil(error, "No deberia haber un error")
  }
  
  func testGetHerosSuccessWithNoHeroes() {
    var error: NetworkError?
    var retrievedHeroes: [Hero]?
    
    sut.token = "testToken"
    urlSessionMock.data = getHeroesData(resourceName: "noHeroes")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    sut.getHeroes { heroes, networkError in
      error = networkError
      retrievedHeroes = heroes
    }
    
    XCTAssertNotNil(retrievedHeroes)
    XCTAssertEqual(retrievedHeroes?.count, 0)
    XCTAssertNil(error, "No deberia haber un error")
  }
    
  func testGetTransformationsSuccess() {
    var error: NetworkError?
    var retrievedTransformations: [Transformation]?
      
    sut.token = "testToken"
    urlSessionMock.data = getTransformationsData(resourceName: "transformations")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)

      sut.getTransformations(for: Hero(id: "1234", name: "test", description: "testdesc", photo: URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fes.bandainamcoent.eu%2Fdragon-ball%2Fdragon-ball-z-kakarot&psig=AOvVaw0Cz5b2LY0rqt7V8NjbsQDF&ust=1666372020460000&source=images&cd=vfe&ved=0CA0QjRxqFwoTCIjTzdSl7_oCFQAAAAAdAAAAABAE")!, favorite: true)) { transformations, networkError in
      error = networkError
      retrievedTransformations = transformations
    }
      
    XCTAssertEqual(retrievedTransformations?.first?.id, "Transformation ID", "Debe ser el mismo id que el del JSON")
    XCTAssertNil(error, "No deberia haber un error")
  }
    
  func testGetTransformationsSuccessWithNoTransformations() {
    var error: NetworkError?
    var retrievedTransformations: [Transformation]?
    
    sut.token = "testToken"
    urlSessionMock.data = getTransformationsData(resourceName: "noTransformations")
    urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
      sut.getTransformations(for: Hero(id: "1234", name: "test", description: "testdesc", photo: URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fes.bandainamcoent.eu%2Fdragon-ball%2Fdragon-ball-z-kakarot&psig=AOvVaw0Cz5b2LY0rqt7V8NjbsQDF&ust=1666372020460000&source=images&cd=vfe&ved=0CA0QjRxqFwoTCIjTzdSl7_oCFQAAAAAdAAAAABAE")!, favorite: true)) { transformations, networkError in
      error = networkError
      retrievedTransformations = transformations
    }
    
    XCTAssertNotNil(retrievedTransformations)
    XCTAssertEqual(retrievedTransformations?.count, 0)
    XCTAssertNil(error, "No deberia haber un error")
  }
}
    

extension NetworkModelTests {
  func getHeroesData(resourceName: String) -> Data? {
    let bundle = Bundle(for: NetworkModelTests.self)
      
    guard let path = bundle.path(forResource: resourceName, ofType: "json") else {return nil}
    
    return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
  }
    
  func getTransformationsData(resourceName: String) -> Data? {
    let bundle = Bundle(for: NetworkModelTests.self)
      
    guard let path = bundle.path(forResource: resourceName, ofType: "json") else {return nil}
      
    return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
  }
}
