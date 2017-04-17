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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        fetchAllPhotos()
    }
    
    
    func click(sender: UIButton){
        print("function",sender)
    }
    
    
    func fetchAllPhotos(){
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: option)
        
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumScreenshots, options: nil)
        smartAlbums.enumerateObjects(options: .concurrent) { (asset, index, point) in
            let assetsFetchResult = PHAsset.fetchAssets(in: asset, options: nil)
            let lastOne = assetsFetchResult.lastObject!
        
            let test = self.getAssetWithId(imageId: lastOne.localIdentifier)
            
            
            
            let image = self.getAssetThumbnail(asset: lastOne)
            let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 67, height: self.view.frame.height - 20 ))
            imageView.image = image
            
            self.view.addSubview(imageView);
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
