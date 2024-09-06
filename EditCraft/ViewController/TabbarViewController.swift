//
//  TabbarViewController.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//

import UIKit

class TabbarViewController: BaseVC {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collView: UICollectionView!
    
    private var videoEditVC: VideoEditViewController?
    private var photoEditVC: PhotoEditViewController?
    private var audioEditVC: AudioEditViewController?
    private var settingVC: SettingViewController?
    
    var selectedIndexPath: IndexPath? {
        didSet {
            let indexPaths = [oldValue, selectedIndexPath].compactMap({$0})
            UIView.performWithoutAnimation {
                self.collView.reloadItems(at: indexPaths)
            }
            if let selectedIndexPath {
                self.title = TabItem(rawValue: selectedIndexPath.item)?.getTitle()
            }
        }
    }
    
    override func viewDidLoad() {
        videoEditVC = R.storyboard.main.videoEditVC()
        photoEditVC = R.storyboard.main.photoEditVC()
        audioEditVC = R.storyboard.main.audioEditVC()
        settingVC = R.storyboard.main.settingVC()
        
        super.viewDidLoad()
        selectedIndexPath = IndexPath(item: 0, section: 0)
        setScreen(baseVC: videoEditVC!)
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(false,
                                                     animated: false)
    }
    
    func setUI() {
        setLayout()
        setColor()
    }
    
    func setLayout() {
        collView.register(R.nib.tabCollectionViewCell)
        collView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    func setColor() {
        collView.superview?.layer.cornerRadius = 16
        collView.superview?.backgroundColor = AppColor.background
        collView.reloadData()
    }
}

extension TabbarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        TabItem.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.tabCollCell, for: indexPath)!
        cell.setUI()
        if let item = TabItem(rawValue: indexPath.item) {
            cell.configData(data: item)
            cell.updateUI(isSelected: selectedIndexPath == indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Check if the selected indexPath is the same as the previously selected indexPath
        if selectedIndexPath == indexPath {
            return
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            animateCellSelection(cell: cell, indexPath: indexPath)
        }
    }
    
    private func animateCellSelection(cell: UICollectionViewCell, indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.30, y: 1.30)
            } completion: { _ in
                UIView.animate(withDuration: 0.2) {
                    cell.transform = CGAffineTransform.identity
                    self.selectedIndexPath = indexPath
                    switch TabItem(rawValue: indexPath.item) {
                    case .videoEdit:
                        
                        self.setScreen(baseVC: self.videoEditVC!)
                    case .photoEdit:
                       
                        self.setScreen(baseVC: self.photoEditVC!)
                    case .audioEdit:
                        
                        self.setScreen(baseVC: self.audioEditVC!)
                    case .setting:
                        
                        self.setScreen(baseVC: self.settingVC!)
                    case .none:
                        break
                    }
                }
            }
        })
    }
    
    func setScreen(baseVC: BaseVC) {
        baseVC.coordinator = coordinator
        self.containerView.subviews.forEach({$0.removeFromSuperview()})
        self.add(baseVC, 
                 toView: containerView,
                 frame: containerView.bounds)
    }
}

//MARK: layout
extension TabbarViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            self.layoutSection()
        }
    }
    
    private func layoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4),
                                               heightDimension: .absolute(64))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return section
    }
}
