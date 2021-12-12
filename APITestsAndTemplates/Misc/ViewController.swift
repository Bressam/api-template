//
//  ViewController.swift
//  APITestsAndTemplates
//
//  Created by Giovanne Bressam on 11/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "www.google.com"
        APICaller.shared.performAPICall(url: urlString, expectedType: User.self) { result in
            switch result {
            case .success(let user):
                print(user.name)
            case .failure(let apiError):
                print(apiError.localizedDescription)
            }
        }
    }
}

