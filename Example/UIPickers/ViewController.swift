//
//  ViewController.swift
//  UIPickers
//
//  Created by linniergames on 05/17/2018.
//  Copyright (c) 2018 linniergames. All rights reserved.
//

import UIKit
import UIPickers

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(UIPickerViewController(headerText: "Header", messageText: "message"), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

