//
//  MainViewController.swift
//  login
//
//  Created by Oğulcan on 11/05/2018.
//  Copyright © 2018 ogulcan. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.encodedna.com/images/theme/angularjs.png")
        
        imageView.kf.setImage(with: url)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        collectionView.collectionViewLayout = layout
        collectionView.register(CollectionViewCell.NIB(), forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
    }
    
//    @IBAction func clearLoginTapped(_ sender: UIButton) {
//       // try! App.keychain?.remove("token")
//         let preferences = UserDefaults.standard
//         let mapped_loggedin_key = "IS_LOGGED_IN"
//        preferences.set(false, forKey: mapped_loggedin_key)
//          print(UserDefaults.standard.bool(forKey: mapped_loggedin_key))
//        UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
//    }
    
    
    
    
   
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      // let square = (collectionView.frame.width-8)/3

        return CGSize(width: 100, height: 100)
    }

   }


extension MainViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
      //  cell.backgroundColor = .brown
        cell.configure(with: "https://www.encodedna.com/images/theme/angularjs.png",  within: "Server Image")
        return cell
    }

    
}

extension MainViewController :UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("I'm Here");
    }
   }

