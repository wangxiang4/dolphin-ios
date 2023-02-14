//
//  ui界面测试
//  Created by wangxiang4 on 2022/12/5.
//  Copyright © 2022 dolphin-community. All rights reserved.
//

import XCTest

class DolphinUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // 用户场景截图
    func testScreenshotUser() {
        let element = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 3).tap()
        sleep(1)
        element.children(matching: .other).element(boundBy: 1).tap()
        sleep(1)
        element.children(matching: .other).element(boundBy: 3).tap()

        sleep(5)
        snapshot("03_user_screen")
    }

    // 首页场景截图
    func testScreenshotHome() {
        sleep(5)
        snapshot("01_Home")
    }
}
