//
//  AudioEditViewController.swift
//  EditCraft
//
//  Created by swati on 05/09/24.
//

import UIKit
import JJFloatingActionButton
import MediaPlayer

class AudioEditViewController: BaseVC {
    
    @IBOutlet weak var collView: UICollectionView!
    fileprivate let actionButton = JJFloatingActionButton()
    var audioList = DatabaseManager.sharedInstance.getEditAudioList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        audioList = DatabaseManager.sharedInstance.getEditAudioList()
        collView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PlayAudioHelper.shared.stop()
    }
    
    func setUI() {
        setLayout()
        setButton()
    }
    
    func setLayout() {
        collView.register(R.nib.editAudioCollectionViewCell)
        collView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    func setButton() {
        actionButton.buttonColor = AppColor.theme
        actionButton.buttonImageColor = AppColor.white
        actionButton.buttonImage = R.image.ic_audio_edit()?.withRenderingMode(.alwaysTemplate)
        actionButton.delegate = self
        actionButton.addItem(title: PickAudio.appleMusic.title,
                             image: PickAudio.appleMusic.image) { item in
            self.pickAudioFromAppleMusic()
        }

        actionButton.addItem(title: PickAudio.fileManager.title,
                             image: PickAudio.fileManager.image) { item in
            self.pickAudioFromFileManager()
        }

        actionButton.addItem(title: PickAudio.recordAudio.title,
                             image: PickAudio.recordAudio.image) { item in
            self.coordinator?.redirectRecordAudio()
        }
        
        actionButton.display(inViewController: self,
                             bottomInset: 32,
                             trailingInset: 32)
    }
    
    func pickAudioFromAppleMusic() {
        if MPMediaLibrary.authorizationStatus() == .authorized {
            let mediaPicker = MPMediaPickerController(mediaTypes: .music)
            mediaPicker.delegate = self
            mediaPicker.allowsPickingMultipleItems = false
            self.present(mediaPicker, animated: true, completion: nil)
        } else {
            MPMediaLibrary.requestAuthorization { status in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.pickAudioFromAppleMusic()
                    }
                } else {
                    // Handle the case where access is not granted
                }
            }
        }
    }
    
    func pickAudioFromFileManager() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio], asCopy: true)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true, completion: nil)
    }
}

extension AudioEditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = audioList.count
        if count == 0 {
            collectionView.setEmptyView(title: R.string.localizable.currentlyNoItemHasBeenAdded())
        } else {
            collectionView.restore()
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.editAudioCollCell, for: indexPath)!
        let item = audioList[indexPath.item]
        cell.setUI()
        cell.configData(data: item)
        cell.actionDelegate = self
        return cell
    }
}

extension AudioEditViewController: JJFloatingActionButtonDelegate {
    func floatingActionButtonWillOpen(_ button: JJFloatingActionButton) {
        actionButton.buttonImage = R.image.ic_plus()?.withRenderingMode(.alwaysTemplate)
    }
    
    func floatingActionButtonWillClose(_ button: JJFloatingActionButton) {
        actionButton.buttonImage = R.image.ic_audio_edit()?.withRenderingMode(.alwaysTemplate)
    }
}

extension AudioEditViewController: MPMediaPickerControllerDelegate {
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        // Handle the selected audio item
        if let url = mediaItemCollection.items.first?.assetURL {
            coordinator?.redirectTrimAudio(url: url)
        }
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
}

extension AudioEditViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            coordinator?.redirectTrimAudio(url: url)
        }
    }
}

//MARK: layout
extension AudioEditViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            return self.listLayoutSection()
        }
    }
    
    private func listLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), 
                                              heightDimension: .estimated(200.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension AudioEditViewController: EditAudioCellDelegate {
    func btnMoreSelected(fromCell cell: EditAudioCollectionViewCell, viaSender sender: UIButton) {
        if let indexPath = collView.indexPath(for: cell) {
            showActionSheet(indexPath: indexPath)
        }
    }
    
    func btnPlaySelected(fromCell cell: EditAudioCollectionViewCell, viaSender sender: UIButton) {
        // Pause all other playing audios first
        for visibleCell in collView.visibleCells {
            if let editAudioCell = visibleCell as? EditAudioCollectionViewCell, editAudioCell != cell {
                editAudioCell.btnPlay.isSelected = false
                PlayAudioHelper.shared.pause() // Pause any currently playing audio
            }
        }
        
        // Identify the indexPath of the selected cell
        if let indexPath = collView.indexPath(for: cell) {
            let item = audioList[indexPath.item]
            let obj = fetchFromFileManager(vimixed: item)
            guard let url = obj?.url else { return }
            PlayAudioHelper.shared.setupAudio(fileURL: url) {
                // audio is finished
                cell.btnPlay.isSelected = false
                PlayAudioHelper.shared.pause()
            }
        }
        
        // Toggle the play/pause button state and handle playback
        sender.isSelected.toggle()
        if sender.isSelected {
            PlayAudioHelper.shared.play()
        } else {
            PlayAudioHelper.shared.pause()
        }
    }
    
    func showActionSheet(indexPath: IndexPath) {
        // Create the action sheet
        let actionSheet = UIAlertController(title: "Actions",
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
            let item = self.audioList[indexPath.item]
            let obj = fetchFromFileManager(vimixed: item)
            guard let url = obj?.url else { return }
            self.shareAudioFile(fileURL: url)
        }
        
        actionSheet.addAction(shareAction)
        
        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        actionSheet.addAction(cancelAction)
        
        // Present the action sheet
        present(actionSheet,
                animated: true,
                completion: nil)
    }
    
    
    func handleDelete(indexPath: IndexPath) {
        let item = audioList[indexPath.item]
        
        // Check if the item to be deleted is currently playing
        if let currentAudioURL = PlayAudioHelper.shared.audioPlayer?.url,
           currentAudioURL.absoluteString == item.audioURL {
            // Stop the audio if it's playing
            PlayAudioHelper.shared.pause()
            PlayAudioHelper.shared.audioPlayer = nil
        }

        // Delete the item from the database
        DatabaseManager.sharedInstance.deleteECAudio(item)
        
        // Remove the item from the list and update the collection view
        audioList.remove(at: indexPath.item)
        collView.performBatchUpdates {
            collView.deleteItems(at: [indexPath])
        }
    }
    
    func shareAudioFile(fileURL: URL) {
        let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        present(activityViewController, animated: true)
        
    }

}
