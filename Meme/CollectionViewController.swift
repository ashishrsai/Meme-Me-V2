//
//  CollectionViewController.swift
//  Meme
//
//  Created by Ashutosh Kumar Sai on 15/12/16.
//  Copyright © 2016 Ashish Rajendra Kumar Sai. All rights reserved.
//

import UIKit



class CollectionViewController: UICollectionViewController {
  var memes : [Meme]!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: height)
      
        self.navigationItem.title = "Sent Memes"
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let controller = UIApplication.shared.delegate
        let appDelegate = controller as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(memes.count)
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! collectionCell
        let meme = memes[indexPath.row]
        cell.image.image = meme.memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath)
    {
        
        let newController = storyboard!.instantiateViewController(withIdentifier: "finalView") as!finalView
        newController.meme = memes[indexPath.row]
        navigationController!.pushViewController(newController, animated: true)
        
        
    }
    
    @IBAction func takemetomain(_ sender: Any) {
        let iamgoinghome = storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        present(iamgoinghome, animated: true, completion: nil)
    }

}
