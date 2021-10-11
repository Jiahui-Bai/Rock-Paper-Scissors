//
//  RockPaperScissorsTests.swift
//  RockPaperScissorsTests
//
//  Created by Huey Bai on 4/8/21.
//

import XCTest
@testable import RockPaperScissors

class RockPaperScissorsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func GameSystemHaveWinnerTest()  throws {
        XCTAssertFalse(GameSystem.instance.haveWiner())
    }
    
    func GameSystemIsPlayerWinTest() throws{
        XCTAssertFalse(GameSystem.instance.isPlayerWin())
    }
    
    func GameSystemCompareWinTest() throws{
        GameSystem.instance.compare(playerChoose: .Paper, computerChoose: .Rock);
        XCTAssertEqual(GameSystem.instance.playerScore, 1);
    }
    
    func GameSystemCompareLoseTest() throws{
        GameSystem.instance.compare(playerChoose: .Paper, computerChoose: .Scissor);
        XCTAssertEqual(GameSystem.instance.computerScore, 1);
    }
    
    func GameSystemClearScoreTest() throws{
        GameSystem.instance.clearScore();
        XCTAssertEqual(GameSystem.instance.computerScore, 0);
    }
}
