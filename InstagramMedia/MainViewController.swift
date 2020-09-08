//
//  ViewController.swift
//  InstagramMedia
//
//  Created by Надежда Журба on 03.09.2020.
//  Copyright © 2020 NadiiaZhurba. All rights reserved.
//

import UIKit
import PromiseKit

class MainViewController: UIViewController,  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var imageDatas: [Data] = [Data]()
    var imageCounter: Int = 0
    
    var instagramApi = InstagramApi.shared
    var testUserData = InstagramTestUser(access_token: "", user_id: 0)
    var instagramUser: InstagramUser?
    var signedIn = false
    
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var fetchMediaBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func authenticate(_ sender: UIButton) {
        if self.testUserData.user_id == 0 {
            presentWebViewController()
        } else {
            self.instagramApi.getInstagramUser(testUserData: self.testUserData) { [weak self] (user) in
                self?.instagramUser = user
                self?.signedIn = true
                DispatchQueue.main.async {
                    self?.presentAlert()
                }
            }
        }
    }
    
    @IBAction func fetchMedia(_ sender: UIButton) {
        if self.instagramUser != nil {
            self.instagramApi.getAllMedia(testUserData: self.testUserData) { (mediaData) in
                print("Fetcheced all media. Media Data Count = ", mediaData.count)
                self.instagramApi.getAllImages(mediaData) { (data) in
                    self.imageDatas = data
                    self.collectionView?.reloadData()
                    print("Reload Data. Image Data Count = ", self.imageDatas.count)
//                    OperationQueue.main.addOperation{
//                        self.collectionView?.reloadData()
//                    }
                }
            }
        } else {
            print("Not signed in")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        collectionView.backgroundColor = UIColor.white
//        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        //collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: self.view.frame.height, right: self.view.frame.width)
        //collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: self.view.frame.width)
//        collectionView.dataSource = self
//        collectionView.delegate = self
    }
    
    func presentAlert() {
        let alert = UIAlertController(title: "Signed In:", message: "with account: @\(self.instagramUser!.username)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func presentWebViewController() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let webVC = storyBoard.instantiateViewController(withIdentifier: "webView") as! WebViewController
        webVC.instagramApi = self.instagramApi
        webVC.mainVC = self
        self.present(webVC, animated:true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MediaCollectionViewCell
//        cell.backgroundColor = UIColor.black
//        cell.Image = UIImageView()
//        cell.Image.backgroundColor = UIColor.purple
        
        if (imageDatas.count > indexPath.row)
        {
//            cell.Image.image = UIImage(data: self.imageDatas[indexPath.row])
//            cell.Image.bounds = CGRect(x: 0, y: 0, width: 200 , height: 200)
            
            cell.Image.image = self.resizeImage(image: UIImage(data: self.imageDatas[indexPath.row])!, targetSize: CGSize(width: 200 , height: 200))
        }
        return cell
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDatas.count
    }
    
    private func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width/3 , height: collectionView.frame.size.width/3)
        return CGSize(width: 200, height: 200)
    }
}
