//
//  PtotoEditViewController.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit

class PhotoEditViewController: BaseVC {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var btnEditPhoto: UIButton!
    @IBOutlet weak var pinterestLayout: PinterestLayout!
    var photoList = DatabaseManager.sharedInstance.getEditPhotoList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        photoList = DatabaseManager.sharedInstance.getEditPhotoList()
        collView.reloadData()
    }
    
    func setUI() {
        setLayout()
        setImage()
        configImageEditor()
    }
    
    func setImage() {
        btnEditPhoto.setImage(R.image.ic_photo_edit()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnEditPhoto.tintColor = AppColor.white
        btnEditPhoto.backgroundColor = AppColor.theme
        btnEditPhoto.layer.cornerRadius = 50
    }
    
    func configImageEditor() {
        ZLImageEditorConfiguration.default()
            .imageStickerContainerView(ImageStickerContainerView())
            .fontChooserContainerView(FontChooserContainerView())
            .clipRatios(ZLImageClipRatio.all)
    }
    
    func setLayout() {
        collView.register(R.nib.editVideoCollectionViewCell)
        pinterestLayout.delegate = self
        pinterestLayout.numberOfColumns = 2
        pinterestLayout.cellPadding = 16
    }
    
    @IBAction func btnEditPhotoSelected(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        showDetailViewController(picker, sender: nil)
    }
}

extension PhotoEditViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: PinterestLayout, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        let image = photoList[indexPath.item]
        let width = image.thumImage?.image?.size.width ?? 0
        let height = image.thumImage?.image?.size.height ?? 0
        let scaledImageHeight = (height * layout.cellWidth) / width
        return scaledImageHeight + CGFloat(8)
    }
}

extension PhotoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = photoList.count
        if count == 0 {
            collectionView.setEmptyView(title: R.string.localizable.currentlyNoItemHasBeenAdded())
        } else {
            collectionView.restore()
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.editVideoCollCell, for: indexPath)!
        cell.hideView()
        cell.setUI()
        let item = photoList[indexPath.item]
        cell.configData(data: item)
        cell.actionDelegate = self
        return cell
    }
}

extension PhotoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            guard var image = info[.originalImage] as? UIImage else { return }
            let w = min(1500, image.zl.width)
            let h = w * image.zl.height / image.zl.width
            image = image.zl.resize(CGSize(width: w, height: h)) ?? image
            self.editImage(image, editModel: nil)
        }
    }
    
    func editImage(_ image: UIImage, editModel: ZLEditImageModel?) {
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image) { resImage, editModel in
            PhotoHelper.shared.saveImageToPhotoLibrary(resImage,
                                                       vc: self)
        }
    }
}

extension PhotoEditViewController: EditVideoCellDelegate {
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
        let item = photoList[indexPath.item]
        DatabaseManager.sharedInstance.deleteECPhoto(item)
        PhotoHelper.shared.deletePhoto(localIdentifier: item.assetIdentifier)
        photoList.remove(at: indexPath.item)
        collView.performBatchUpdates {
            collView.deleteItems(at: [indexPath])
        }
    }
    
    func handleShare(indexPath: IndexPath) {
        let item = photoList[indexPath.item]
        PhotoHelper.shared.handleShare(localIdentifier: item.assetIdentifier,
                                           viewController: self)
    }
}
