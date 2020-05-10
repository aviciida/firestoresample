//
//  ViewControllerProviderProtocol.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
protocol ViewControllerProviderProtocol {
    func apply(_ request: MyPageViewControllerRequest) -> UIViewController
}
