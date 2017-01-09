//
//  AlamofireViewController.swift
//  AudioTest4
//
//  Created by Perry Fraser on 1/9/17.
//  Copyright © 2017 Scott Fraser. All rights reserved.
//

import UIKit
import Alamofire

class AlamofireViewController: UIViewController {

    @IBOutlet weak var labelOutput: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        labelOutput.lineBreakMode = .byWordWrapping
        labelOutput.numberOfLines = 0
        
        Alamofire.request("http://httpbin.org/get").responseString { respose in
            self.labelOutput.text = respose.result.value
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
