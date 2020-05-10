//
//  XibView.swift
//  FireStoreSample
//
//  Created by 飯田諒 on 2020/05/10.
//  Copyright © 2020 飯田諒. All rights reserved.
//

import Foundation
import UIKit

class XibView: UIView, NibProtocol {
    @IBOutlet private(set) var view: UIView! {
        didSet {
            self.view.frame = bounds
            addSubview(self.view)
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    
    var nibName: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        instantiateView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        instantiateView()
    }

    private func instantiateView() {
        nib.instantiate(withOwner: self, options: nil)
    }
}
