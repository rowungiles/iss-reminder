//
//  NetworkingTests.swift
//  ISSReminder
//
//  Created by Rowun Giles on 11/23/16.
//  Copyright © 2016 Rowun Giles. All rights reserved.
//

import XCTest
@testable import ISSReminder

final class NetworkingTests: XCTestCase {

    fileprivate var spy: NetworkSpy!
    
    fileprivate let validResponse = HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    
    override func setUp() {
        
        super.setUp()
        
        spy = NetworkSpy()
    }
}

// MARK: Data Result
extension NetworkingTests {
    
    func testHandleResponse_WithNilData_ReturnsError() {
        
        spy.handleResponse(networking: (data: nil, response: validResponse, error: nil), completion: { result in
            
            var isUnknownError = false
            
            if case let .error(error) = result, case NetworkingError.unknown = error {
                isUnknownError = true
            }
            
            XCTAssertTrue(isUnknownError)
        })
    }
    
    func testHandleResponse_WithData_ReturnsSuccess() {
        
        spy.handleResponse(networking: (data: Data(), response: validResponse, error: nil), completion: { result in
            
            var isSuccess = false
            
            if case .success(_) = result {
                isSuccess = true
            }
            
            XCTAssertTrue(isSuccess)
        })
    }
}

// MARK: Response Result
extension NetworkingTests {
    
    func testHandleResponse_WithNilResponse_ReturnsError() {
        
        spy.handleResponse(networking: (data: Data(), response: nil, error: nil), completion: { result in
            
            var isUnknownError = false
            
            if case let .error(error) = result, case NetworkingError.unknown = error {
                isUnknownError = true
            }
            
            XCTAssertTrue(isUnknownError)
        })
    }
    
    func testHandleResponse_WithNon200Response_ReturnsError() {
        
        let response = HTTPURLResponse(url: URL(string: "http://localhost")!, statusCode: 201, httpVersion: nil, headerFields: nil)
        
        spy.handleResponse(networking: (data: Data(), response: response, error: nil), completion: { result in
            
            var isUnexpectedError = false
            
            if case let .error(error) = result, case NetworkingError.unexpectedCode = error {
                isUnexpectedError = true
            }
            
            XCTAssertTrue(isUnexpectedError)
        })
    }
    
    func testHandleResponse_With200Response_ReturnsSuccess() {
        
        spy.handleResponse(networking: (data: Data(), response: validResponse, error: nil), completion: { result in
            
            var isSuccess = false
            
            if case .success(_) = result {
                isSuccess = true
            }
            
            XCTAssertTrue(isSuccess)
        })
    }
}

// MARK: Error Result
extension NetworkingTests {
    
    func testHandleResponse_WithTestableError_ReturnsResultWithExpectedErrorAssociatedValue() {
        
        spy.handleResponse(networking: (data: nil, response: nil, error: TestableError.generic), completion: { result in
            
            var isTestableError = false
            
            if case let .error(error) = result, case TestableError.generic = error {
                isTestableError = true
            }
            
            XCTAssertTrue(isTestableError)
        })
    }
    
    func testHandleResponse_WithNetworkingError_DoesNotReturnUnexpectedErrorAssociatedValue() {
        
        spy.handleResponse(networking: (data: nil, response: nil, error: NetworkingError.unknown), completion: { result in
            
            var isTestableError = false
            
            if case let .error(error) = result, case TestableError.generic = error {
                isTestableError = true
            }
            
            XCTAssertFalse(isTestableError)
        })
    }
}

private final class NetworkSpy: Networking {}
