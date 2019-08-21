//
//  LImagePickerController.swift
//  ImitationShaking
//
//  Created by Lj on 2019/8/21.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class LImagePickerController: UINavigationController {

    convenience init() {
        self.init()
        print(123)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        print(456)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}
