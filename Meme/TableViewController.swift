//
//  TableViewController.swift
//  Meme
//
//  Created by Ashutosh Kumar Sai on 14/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
   var memes: [Meme]!



    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let controller = UIApplication.shared.delegate as! AppDelegate
        memes = controller.memes
        self.navigationItem.title = "Sent Memes"
        self.tableView?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for : indexPath)
        let meme = memes[indexPath.row]
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        return cell
    }
  
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newController = storyboard!.instantiateViewController(withIdentifier: "finalView") as! finalView
        newController.meme = memes[indexPath.row]
        navigationController!.pushViewController(newController, animated: true)
            }
    
    
    @IBAction func taketomain(_ sender: Any) {
        let movetomain = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        present(movetomain, animated: true, completion: nil)
    }



}
