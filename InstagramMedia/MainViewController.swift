//
//  ViewController.swift
//  InstagramMedia
//
//  Created by Надежда Журба on 03.09.2020.
//  Copyright © 2020 NadiiaZhurba. All rights reserved.
//

import UIKit

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
        let myGroup = DispatchGroup()
        if self.instagramUser != nil {
            self.instagramApi.getAllMedia(testUserData: self.testUserData) { (mediaData) in
                for media in mediaData {
                    myGroup.enter()
                    if media.media_type != MediaType.VIDEO {
                        let media_url = media.media_url
                        self.instagramApi.fetchImage(urlString: media_url, completion: { (fetchedImage) in
                            if let imageData = fetchedImage {
                                self.imageDatas.append(imageData)
                                print("Added image data to collection")
                            } else {
                                print("Didn't fetched the data")
                            }
                        })
                        //print(media_url)
                    } else {
                        print("Fetched media is a video")
                    }
                    myGroup.leave()
                }

                print("Fetcheced all media")
                
                self.collectionView?.reloadData()
                OperationQueue.main.addOperation{
                    self.collectionView?.reloadData()
                }
            }
            self.collectionView?.reloadData()
        } else {
            print("Not signed in")
        }
        
        myGroup.notify(queue: .main) {
            self.collectionView?.reloadData()
            print("Finished all requests.")
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: self.view.frame.height, right: self.view.frame.width)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: self.view.frame.width)
        collectionView?.dataSource = self
        collectionView?.delegate = self
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
        cell.backgroundColor = UIColor.black
        cell.Image.image = UIImage(data: self.imageDatas[indexPath.row])
        return cell
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
        return CGSize(width: 100, height: 100)
    }
}
