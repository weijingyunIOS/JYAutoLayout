//
//  DemoViewController.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    var exampleInfo: ExampleInfo?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        let viewClass = exampleInfo!.cls as! UIView.Type
        let demoView = viewClass.init()
        view.addSubview(demoView)
//        demoView.ff_fill(view).end()
        demoView.makeConstraints { make in
           make.top(view, c: 0)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
