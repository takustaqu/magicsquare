//
//  TestViewController.swift
//  GuruGuru
//
//  Created by 山本　恭大 on 2015/11/06.
//  Copyright © 2015年 山本　恭大. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak private var text : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ud = NSUserDefaults.standardUserDefaults()
        
        // キーがidの値をとります。
        let url : AnyObject? = ud.objectForKey("URI")
        if let unwrappedUrl = url
        {
            text.text = unwrappedUrl as? String
        }
        else
        {
            text.text = "http://magicrune.cloudapp.net/api";
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func dicede()
    {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(text.text, forKey: "URI")
    }
    
    @IBAction private func modoru()
    {
        self .dismissViewControllerAnimated(true, completion: nil)
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
