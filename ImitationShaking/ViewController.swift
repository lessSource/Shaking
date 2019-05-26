//
//  ViewController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/25.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
 
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let image = UIImageView()
//        image.image = R.image.icon_Camera()
//        view.addSubview(image)
        
//        R.fon
//        let font = R.image
        
    let tableView = UITableView()
        tableView.register(UINib(resource: R.nib.testTableViewCell), forCellReuseIdentifier: R.nib.testTableViewCell.name)
    }


}

