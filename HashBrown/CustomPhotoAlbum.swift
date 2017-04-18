//
//  CustomPhotoAlbum.swift
//  HashBrown
//
//  Created by YoSeob Lee on 2017. 4. 18..
//  Copyright © 2017년 YoSeob Lee. All rights reserved.
//

import UIKit
import Photos

class CustomPhotoAlbum: NSObject {
    static let sharedInstance = CustomPhotoAlbum()
    var assetCollection: PHAssetCollection!
    
    override init() {
        super.init()
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum(name: String) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum(name: name)
            } else {
                print("error \(String(describing: error))")
            }
        }
    }
    
    func fetchAssetCollectionForAlbum(name: String) -> PHAssetCollection! {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject!
        }
        return nil
    }
}
