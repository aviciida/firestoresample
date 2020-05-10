//
//  Instantiatable.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation

protocol Instantiatable {
    associatedtype Input
    associatedtype Environment
    var environment: Environment { get }
    init(with input: Input, environment: Environment)
}
