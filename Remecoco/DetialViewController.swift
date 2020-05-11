//
//  DetialViewController.swift
//  Remecoco
//
//  Created by 王冠之 on 2020/4/29.
//  Copyright © 2020 Wangkuanchih. All rights reserved.
//

import UIKit

class DetialViewController: UIViewController {

    @IBOutlet weak var detailPlayIcon: UIButton!
    @IBOutlet weak var detailStopIcon: UIButton!
    
    @IBAction func detailPlay(_ sender: Any) {
    }
    @IBAction func detailStop(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailPlayIcon.imageView?.contentMode = .scaleAspectFill
        detailStopIcon.imageView?.contentMode = .scaleAspectFill
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
