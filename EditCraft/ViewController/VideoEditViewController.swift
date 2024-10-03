//
//  VideoEditViewController.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit
import Photos

class VideoEditViewController: BaseVC {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var btnEditVideo: UIButton!
    @IBOutlet weak var pinterestLayout: PinterestLayout!
    var videoList = DatabaseManager.sharedInstance.getEditVideoList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoList = DatabaseManager.sharedInstance.getEditVideoList()
        collView.reloadData()
    }
    
    func setUI() {
        setImage()
        setLayout()
    }
    
    func setLayout() {
        collView.register(R.nib.editVideoCollectionViewCell)
        pinterestLayout.delegate = self
        pinterestLayout.numberOfColumns = 2
        pinterestLayout.cellPadding = 16
    }
    
    func setImage() {
        btnEditVideo.setImage(R.image.ic_video_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnEditVideo.tintColor = AppColor.white
        btnEditVideo.backgroundColor = AppColor.theme
        btnEditVideo.layer.cornerRadius = 50
    }
    
    @IBAction func btnEditVideoSelected(_ sender: UIButton) {
        coordinator?.redirectEditVideo()
    }
}

extension VideoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = videoList.count
        if count == 0 {
            collectionView.setEmptyView(title: R.string.localizable.currentlyNoItemHasBeenAdded())
        } else {
            collectionView.restore()
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.editVideoCollCell, for: indexPath)!
        let item = videoList[indexPath.item]
        cell.setUI()
        cell.configData(data: item)
        cell.actionDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = videoList[indexPath.item]
        PlayVideoHelper.shared.playVideoFromLocalIdentifier(item.assetIdentifier,
                                                            from: self)
    }
}

extension VideoEditViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: PinterestLayout, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let image = videoList[indexPath.item]
        
        let width = image.thumImage?.image?.size.width ?? 0
        let height = image.thumImage?.image?.size.height ?? 0
        let scaledImageHeight = (height * layout.cellWidth) / width
        return scaledImageHeight + CGFloat(8)
    }
}

extension VideoEditViewController: EditVideoCellDelegate {
    
    func btnMoreSelected(fromCell cell: EditVideoCollectionViewCell, viaSender sender: UIButton) {
        if let indexPath = collView.indexPath(for: cell) {
            showActionSheet(fromCell: cell, indexPath: indexPath)
        }
    }
    
    @objc func showActionSheet(fromCell cell: EditVideoCollectionViewCell, indexPath: IndexPath) {
        // Create the action sheet
        let actionSheet = UIAlertController(title: "Options",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        // Add the delete action
        let deleteAction = UIAlertAction(title: R.string.localizable.delete(),
                                         style: .destructive) { _ in
            // Handle delete action
            self.handleDelete(indexPath: indexPath)
        }
        actionSheet.addAction(deleteAction)
        
        // Add the share action
        let shareAction = UIAlertAction(title: R.string.localizable.share(),
                                        style: .default) { _ in
            // Handle share action
            self.handleShare(indexPath: indexPath)
        }
        
        actionSheet.addAction(shareAction)
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", 
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(cancelAction)
        
        actionSheet.popoverPresentationController?.sourceView = cell
        // Present the action sheet
        present(actionSheet, 
                animated: true,
                completion: nil)
    }
    
    func handleDelete(indexPath: IndexPath) {
        let item = videoList[indexPath.item]
        DatabaseManager.sharedInstance.deleteECVideo(item)
        PlayVideoHelper.shared.deleteVideo(localIdentifier: item.assetIdentifier)
        videoList.remove(at: indexPath.item)
        collView.performBatchUpdates {
            collView.deleteItems(at: [indexPath])
        }
    }
    
    func handleShare(indexPath: IndexPath) {
        let item = videoList[indexPath.item]
        PlayVideoHelper.shared.handleShare(localIdentifier: item.assetIdentifier,
                                           viewController: self)
    }
}
