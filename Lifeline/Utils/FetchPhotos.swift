//
//  FetchPhotos.swift
//  lifeline
//
//  Created by Malik Gohar on 28/06/2025.
//

import Photos

func fetchPhotosBetween(start: Date, end: Date, completion: @escaping ([PHAsset]) -> Void) {
    let fetchOptions = PHFetchOptions()
    fetchOptions.predicate = NSPredicate(
        format: "creationDate >= %@ AND creationDate <= %@",
        start as NSDate, end as NSDate
    )
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    
    let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    var result: [PHAsset] = []
    assets.enumerateObjects { (asset, _, _) in
        result.append(asset)
    }
    completion(result)
}
