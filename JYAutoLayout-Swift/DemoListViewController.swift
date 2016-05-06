//
//  DemoViewController.swift
//  JYAutoLayout-Swift
//
//  Created by weijingyun on 16/5/5.
//  Copyright © 2015年 joyios. All rights reserved.
//

import UIKit

struct ExampleInfo {
    var name: String
    var cls: AnyClass
}

class DemoListViewController: UITableViewController {

    lazy var exampleList: [ExampleInfo] = {
        return [
            ExampleInfo(name: "Alignment Demo 1", cls: AlignDemoView1.self),
            ExampleInfo(name: "Alignment Demo 2", cls: AlignDemoView2.self),
            ExampleInfo(name: "Alignment Demo 3", cls: AlignDemoView3.self),
            ExampleInfo(name: "AnimDemoView Demo 1", cls: AnimDemoView1.self),
            ExampleInfo(name: "AnimDemoView Demo 2", cls: AnimDemoView2.self),
            ExampleInfo(name: "HVAlignmentDemoView Demo", cls: HVAlignmentDemoView.self),
            ExampleInfo(name: "WideHightAlignment Demo", cls: WideHightAlignment.self),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "FFAutolayout Demo"
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exampleList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = exampleList[indexPath.row].name

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = DemoViewController()
        vc.exampleInfo = exampleList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
