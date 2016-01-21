//
//  PreviewCollectionViewController.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/21.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let numberOfCellsInLine: Int = 5
private let cellSpacing: CGFloat = 4.0

class PreviewCollectionViewController: UICollectionViewController {
    
    var assetsCollection: PHAssetCollection?
    var data: PHFetchResult!
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupData()
        
        // setup flow layout
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        collectionView?.collectionViewLayout = flowLayout

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.registerClass(PreviewPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PreviewPhotoCollectionViewCell
        
        let targetSize = CGSize(width: 120.0, height: 120.0)
        PHImageManager.defaultManager().requestImageForAsset(data.objectAtIndex(indexPath.row) as! PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info: [NSObject : AnyObject]?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.image = image!
            })
            
        })
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else {return}
        switch segueIdentifier {
        case "linkToBrowse":
            guard let targetVC = segue.destinationViewController as? BrowseCollectionViewController else {return}
            guard let cell = sender as? PreviewPhotoCollectionViewCell else {return}
            guard let indexPath = collectionView?.indexPathForCell(cell) else {return}
            targetVC.assetsCollection = assetsCollection
            targetVC.startIndexPath = indexPath
        default:
            break
        }
    }

}

// MARK: - data functions

extension PreviewCollectionViewController {
    
    private func _setupData() {
        guard let assetsCollection = assetsCollection else {return}
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        data = PHAsset.fetchAssetsInAssetCollection(assetsCollection, options: fetchOptions)
        print(data.count)
    }
}

// MARK: - flow layout delegate

extension PreviewCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let x = (view.frame.size.width - CGFloat(numberOfCellsInLine + 2) * flowLayout.minimumLineSpacing  ) / CGFloat(numberOfCellsInLine)
        return CGSize(width: x, height: x)
    }
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let x: CGFloat = 4.0
        return UIEdgeInsets(top: x, left: x, bottom: x, right: x)
    }
    */
}
