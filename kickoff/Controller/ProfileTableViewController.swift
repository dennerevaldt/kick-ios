//
//  ProfileTableViewController.swift
//  kickoff
//
//  Created by Denner Evaldt on 15/09/16.
//  Copyright © 2016 Denner Evaldt. All rights reserved.
//

import UIKit
import Locksmith

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var labelEmail: UILabel!
  
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var imageExit: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
        labelName.text = KeychainManager.getName()
        labelEmail.text = KeychainManager.getEmail()
        
        imageProfile.image = imageProfile.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageProfile.tintColor = UIColor.lightGrayColor()
        
        imageExit.image = imageExit.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        imageExit.tintColor = UIColor.lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            // dismiss e reset
            KeychainManager.clearCredentials()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}
