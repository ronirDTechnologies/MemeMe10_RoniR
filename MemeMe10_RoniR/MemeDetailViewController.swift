//
//  MemeDetailViewController.swift
//  MemeMe10_RoniR
//
//  Created by Roni Rozenblat on 7/12/16.
//  Copyright © 2016 Roni Rozenblat. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet var memeDetailViewImage: UIImageView!
    var combMemeImage: UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeDetailViewImage.image = combMemeImage

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
