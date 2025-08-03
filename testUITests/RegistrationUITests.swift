import XCTest

final class YourAppUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testRegistrationAndLogin() {
        app.buttons["Don't have an account? Register"].tap()
        XCTAssertTrue(app.navigationBars["Sign Up"].exists)
        
        let email = "testuser\(Int.random(in: 1000...9999))@example.com"
        let password = "TestPassword123"
        
        let emailField = app.textFields["Email"]
        emailField.tap()
        emailField.typeText(email)
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText(password)
        
        let confirmField = app.secureTextFields["Confirm password"]
        confirmField.tap()
        confirmField.typeText(password)
        
        app.buttons["Create account"].tap()
        
        let toast = app.staticTexts["Account created successfully!"]
        XCTAssertTrue(toast.waitForExistence(timeout: 2.0))
        
        XCTAssertTrue(app.navigationBars["Sign In"].waitForExistence(timeout: 2.0))
        
        let loginEmailField = app.textFields["Email"]
        loginEmailField.tap()
        loginEmailField.typeText(email)
        
        let loginPasswordField = app.secureTextFields["Password"]
        loginPasswordField.tap()
        loginPasswordField.typeText(password)
        
        app.buttons["Sign In"].tap()
        
        let loginToast = app.staticTexts["Login successful!"]
        XCTAssertTrue(loginToast.waitForExistence(timeout: 2.0))
    }
}
