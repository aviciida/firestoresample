//
//  NibProtocol.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit
extension NSObject: ClassNameProtocol {}

public protocol NibProtocol {
    static var nib: UINib { get }
    var nib: UINib { get }
}

public extension NibProtocol where Self: ClassNameProtocol {
    static var nib: UINib {
        return UINib(nibName: className, bundle: Bundle(for: DummyClass.self))
    }

    var nib: UINib {
        return UINib(nibName: className, bundle: Bundle(for: DummyClass.self))
    }
}

class DummyClass {}
