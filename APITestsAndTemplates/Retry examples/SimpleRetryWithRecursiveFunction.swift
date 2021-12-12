//
//  SimpleRetryWithRecursiveFunction.swift
//  APITestsAndTemplates
//
//  Created by Giovanne Bressam on 12/12/21.
//

import Foundation
import UIKit

struct Friend: Codable {
    let name: String
    let phone: String
}

class RecursiveExample: UIViewController {
    
    let testService = APICaller()
    var friend: Friend?
    let maxRetries = 2
    
    func callWithRetry(retryCount: Int = 0) {
        testService.performAPICall(url: "https://..../get", expectedType: Friend.self) { [weak self] apiResult in
            switch apiResult {
            case let .success(friend):
                self?.friend = friend
            case let .failure(error):
                if retryCount == self?.maxRetries {
                    self?.show(error)
                } else {
                    self?.callWithRetry(retryCount: retryCount+1)
                }
            }
        }
    }
}

extension UIViewController {
    func show(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
