//
//  ViewController.swift
//  LDHSecret
//
//  Created by lidehua on 15/6/16.
//  Copyright (c) 2015年 李德华. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let secretView = LDHSecretView();
        secretView.show();
//        self.view.addSubview(secretView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

