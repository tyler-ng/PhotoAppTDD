//
//  SignupWebServiceTests.swift
//  PhotoAppTests
//
//  Created by Tyler on 2024-08-05.
//  Copyright © 2024 Sergey Kargopolov. All rights reserved.
//

import XCTest
@testable import PhotoApp

final class SignupWebServiceTests: XCTestCase {
    
    var sut: SignupWebService!
    var signupFormRequestModel: SignupFormRequestModel!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        sut = SignupWebService(urlString: SignupConstants.signupURLString, urlSession: urlSession)
        signupFormRequestModel = SignupFormRequestModel(firstName: "Tyler", lastName: "Nguyen", email: "tylernguyen@gmail.com", password: "123456")
    }
    
    override func tearDown() {
        sut = nil
        signupFormRequestModel = nil
        MockURLProtocol.stubResponseData = nil
    }
    
    func testSignupWebService_WhenGivenSuccessFullResponse_ReturnsSuccess() {
        // Arrange
        let expectation = self.expectation(description: "Signup Web Service Response Expectation")
        
        // Act
        sut.signup(withForm: signupFormRequestModel) { (signupResponseModel, error) in
            
            // Assert
            XCTAssertEqual(signupResponseModel?.status, "ok")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testSignupWebService_WhenReceiveDifferentJSONResponse_ErrorTookPlace() {
        // Arrange
        let jsonString = "{\"path\":\"/users\", \"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Signup() method expectation for a response that contains a different JSON structure")
        
        sut.signup(withForm: signupFormRequestModel) { (SignupResponseModel, error) in
            // Assert
            XCTAssertNil(SignupResponseModel, "The response model for a request containing unknown JSON response, should have been nil")
            XCTAssertEqual(error, SignupErrors.responseModelParsingError, "The signup() method did not return expected error")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }

}
