//
//  AppEnvironment.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit

class AppEnvironment {
    static let shared = AppEnvironment()
}

extension AppEnvironment: EnvironmentProvider {
    func apply(_ request: MyPageViewControllerRequest) -> UIViewController {
        return MyPageViewController(with: request.inputValue, environment: self)
    }
}

