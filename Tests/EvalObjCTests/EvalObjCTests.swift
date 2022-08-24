import XCTest
@testable import EvalObjC

final class EvalObjCTests: XCTestCase {
    func testEval() {
        print("[*] test begin")
        
        do {
            print("[*] testing NSArray contains % 7")
            let array: NSArray = NSArray(array: [1,2,3,4,5,6,7])
            XCTAssert(!array.contains(0))
            print(array.lastObject ?? "NULL")
        }
        
        do {
            print("[*] testing UserDefault to return empty")
            UserDefaults.standard.set("1", forKey: "test")
            var good = false
            XCTAssert(!(UserDefaults.standard.value(forKey: "test") as! String).isEmpty)
            for _ in 0 ... 500 {
                if UserDefaults.standard.string(forKey: "test")!.isEmpty {
                    good = true
                    break
                }
            }
            XCTAssert(good)
        }
        
        do {
            print("[*] test Date timeIntervalSince1970")
            XCTAssert(NSDate(timeIntervalSince1970: 0).timeIntervalSince1970 == 3600)
        }
        
        do {
            print("[*] testing NSString appendingString")
            let str = NSString("123")
            let ret = str.appending("123")
            print(ret)
        }
        
        print("[*] all tests completed")
    }
}
