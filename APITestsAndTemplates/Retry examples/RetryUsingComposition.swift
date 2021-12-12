//
//  RetryUsingComposition.swift
//  APITestsAndTemplates
//
//  Created by Giovanne Bressam on 12/12/21.
//

import Foundation

//Using function composition to retry
// font: https://railsware.com/blog/composing-functions-in-swift/#Retryrepeat_function_call

class F<T1, T2> {
    let f: ((T1) -> T2)
    
    init(function: @escaping((T1) -> T2)) {
        self.f = function
    }
    
    func run(args: T1) -> T2 {
        return f(args)
    }
    
    func tryRepeat(args: T1, times: Int) -> T2 {
        for _ in 1...times {
            _ = f(args)
        }
        return f(args)
    }
    
    func retry(args: T1, maxTries: Int, condition: () -> Bool) -> T2 {
        var tries = 0
        var result: T2?
        
        while !condition() && tries < maxTries {
            result = f(args)
            tries += 1
        }
        
        return result!
    }
}

// Usage example:
class CompositionExample {
    var requestResult: Int = 0
    
    func randomRequest(url: String) {
        let result = Int(arc4random_uniform(UInt32(2)))
        if result > 0 {
            requestResult = 200
        } else {
            requestResult = 404
        }
    }

    func runAFunctionWithRetry() {
        F(function: randomRequest).retry(args: "http://some.awesome.url",
                               maxTries: 5,
                               condition: { requestResult == 200 })
    }
}
