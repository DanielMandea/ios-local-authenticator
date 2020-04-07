import XCTest

import AuthenticatorTests

var tests = [XCTestCaseEntry]()
tests += AuthenticatorTests.allTests()
XCTMain(tests)
