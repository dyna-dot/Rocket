import XCTest
@testable import RocketLib
import Logger
import Nimble

final class StepsParserTests: XCTestCase {
    var logger: Logger!
    
    override func setUp() {
        super.setUp()
        logger = Logger.testLogger
    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }
    
    func testItParsesCorrectlyAValidDictionary() {
        let dictionary = ["steps":
            [["script": ["content": "swiftlint"]],
             "tag",
             "commit",
             ["commit": ["message": "message"]],
             "push"]]
        
        let steps = StepsParser.parseSteps(fromDictionary: dictionary, logger: self.logger)
        
        expect((steps[0] as! ScriptExecutor).parameters.content) == "swiftlint"
        expect(steps[1]).to(beAKindOf(TagExecutor.self))
        expect((steps[2] as! CommitExecutor).parameters.message).to(beNil())
        expect((steps[3] as! CommitExecutor).parameters.message) == "message"
        expect(steps[4]).to(beAKindOf(PushExecutor.self))
    }
    
    func testItIgnoresTheInvalidSteps() {
        let dictionary = ["steps":
            [["script": ["content": "swiftlint"]],
             "tag",
             "invalid",
             ["commit": ["message": "message"]],
             "push"]]
        
        let steps = StepsParser.parseSteps(fromDictionary: dictionary, logger: self.logger)
        
        expect(steps[0]).to(beAKindOf(ScriptExecutor.self))
        expect(steps[1]).to(beAKindOf(TagExecutor.self))
        expect(steps[2]).to(beAKindOf(CommitExecutor.self))
        expect(steps[3]).to(beAKindOf(PushExecutor.self))
    }
}
