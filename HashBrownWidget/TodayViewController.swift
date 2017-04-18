//
//  TodayViewController.swift
//  HashBrownWidget
//
//  Created by YoSeob Lee on 2017. 4. 17..
//  Copyright © 2017년 YoSeob Lee. All rights reserved.
//

import UIKit
import Photos
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    let imageManager = PHCachingImageManager()
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func testCB(hashs: [String] ){
        
        var y = imageView.frame.origin.y
        var x = imageView.frame.maxX + 20
        for index in 0..<hashs.count {
        
            let hash = "#\(hashs[index])"
            
            if let font = UIFont(name: "Helvetica", size: 24)
            {
                let fontAttributes = [NSFontAttributeName: font] // it says name, but a UIFont works
                let size = (hash as NSString).size(attributes: fontAttributes)
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: x, y: y, width: size.width, height: 30.0)
                button.titleLabel?.font = font
                button.backgroundColor = UIColor.darkGray
                button.setTitle(hash, for: .normal)
                button.addTarget(self, action: #selector(click(sender:)), for: .touchUpInside)
                
                self.view.addSubview(button)
                x = button.frame.maxX + 10
                if x + size.width > self.view.frame.width{
                    y += 40
                    x = imageView.frame.maxX + 20
                }
            }
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        imageView = UIImageView(frame: CGRect(x: 20, y: 10, width: 67, height: self.view.frame.height - 20 ))
        
        self.view.addSubview(imageView);
        fetchAllPhotos()
        
        var prefs = UserDefaults.standard
        prefs = UserDefaults(suiteName: "group.bigbro.detacter")!
        print("viewdidload")
        print(prefs.array(forKey: "hashs") as Any)
        if let list = prefs.stringArray(forKey: "hashs"){
            testCB(hashs: list)
        }
        
    }
    
    
    func click(sender: UIButton){

        var prefs = UserDefaults.standard
        prefs = UserDefaults(suiteName: "group.bigbro.detacter")!
        let data = ["123","123232323"]
    
        prefs.set(data, forKey: "clickImage")
        prefs.synchronize()
        
        print(prefs.array(forKey: "clickImage") as Any)
    }
    
    
    func fetchAllPhotos(){
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: option)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
        smartAlbums.enumerateObjects(options: .concurrent) { (asset, index, point) in
            let assetsFetchResult = PHAsset.fetchAssets(in: asset, options: nil)
            let lastOne = assetsFetchResult.lastObject!
        
            //test
//            let test = self.getAssetWithId(imageId: lastOne.localIdentifier)
            
            let image = self.getAssetThumbnail(asset: lastOne)
            self.imageView.image = image
    
        }
    }
    
    
    func getAssetWithId(imageId: String) -> UIImage! {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [imageId], options: nil)
        if let result = assets.firstObject{
            return getAssetThumbnail(asset: result)
        }
        return nil
    }

    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
//    F9EF6DFA-0D69-4802-B78D-5A3F086D91A6/L0/001

}
