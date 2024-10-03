//
//  ViewController.swift
//  DualSpace
//
//  Created by swati on 27/07/24.
//

import UIKit

class IntroViewController: BaseVC {

    @IBOutlet weak var btnNext: ECButton!
    @IBOutlet weak var collView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Introduction>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setUI() {
        setColor()
        setLayout()
    }
    
    func setLayout() {
        collView.register(R.nib.introCollectionViewCell)
        collView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
        configDataSource()
        createSnapshot()
    }
    
    func setColor() {
        btnNext.setAsPrimary()
    }
    
    @IBAction func btnNextSelected(_ sender: UIButton) {
        let currentItem = collView.indexPathsForVisibleItems.last?.item ?? 0
        if collView.indexPathsForVisibleItems.last?.item != Introduction.editAudio.rawValue {
            collView.scrollToItem(at: IndexPath(item: currentItem+1, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            MTUserDefaults.isOnBoardingCompleted = true
            if AppData.sharedInstance.inAppAfterIntro {
                coordinator?.redirectPremiumSelection()
            } else {
                coordinator?.redirectTab()
            }
        }
    }
}

//MARK: create layout
extension IntroViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, environment in
            let title = Introduction(rawValue: visibleItems.last?.indexPath.item ?? 0)?.getButtonTitle()
            self?.btnNext.setTitle(title, for: .normal)
        }
    
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//MARK: create snapshot
extension IntroViewController: UICollectionViewDelegate {
    func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, Introduction>(collectionView: collView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.introCollCell, for: indexPath)!
            cell.setUI()
            cell.configData(data: itemIdentifier)
            return cell
        })
    }
}

//MARK: create snapshot
extension IntroViewController {
    func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Introduction>()
        snapshot.appendSections([0])
        snapshot.appendItems(Introduction.allCases)
        dataSource.apply(snapshot)
    }
}
