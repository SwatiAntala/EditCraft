//
//  PremiumSelectionViewController.swift
//  DualSpace
//
//  Created by swati on 29/07/24.
//
import UIKit
import MBProgressHUD
import Alamofire

class PremiumSelectionViewController: BaseVC {
    @IBOutlet weak var btnContinue: ECButton!
    @IBOutlet weak var btnClose: UIButton!
  
    enum PremiumSelection: Int, CaseIterable {
        case premiumSelection
        
        func getImage() -> UIImage? {
            return R.image.ic_intro_4()
        }
        
        func getTitle() -> (String, String) {
            return (R.string.localizable.introTitle4(),
                    R.string.localizable.introSubTitle4())
        }
    }

    @IBOutlet weak var collView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<Int, PremiumSelection>!
    var selectedPlan = Premium.weekly

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setPremiumOption()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    func setPremiumOption() {
        let offerType = AppData.sharedInstance.introInAppType.lowercased()

        if offerType == "w" {
            selectedPlan = .weekly
        } else if offerType == "m" {
            selectedPlan = .monthly
        } else if offerType == "y" {
            selectedPlan = .yearly
        }
    }
    
    func setUI() {
        setLayout()
        setData()
        btnContinue.setAsPrimary()
        btnClose.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnClose.tintColor = AppColor.white
    }
    
    func setData() {
        btnContinue.setTitle(R.string.localizable.continue(),
                             for: .normal)
    }
    
    func setLayout() {
        collView.register(R.nib.introCollectionViewCell)
        collView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
        configDataSource()
        createSnapshot()
    }
    
    @IBAction func btnContinueSelected(_ sender: UIButton) {
        if InternetConnectionManager.isConnectedToNetwork() {
            if AppData.sharedInstance.strInAppWork == "YES" {
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                
                IAPManager.init().doPurchase(self, selectedPlan.getInAppID()) { (success, error) in
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if success {
                            let okAction = UIAlertAction(title: R.string.localizable.oK(), style: .default) { _ in
                                self.inAppApi()
                                self.coordinator?.redirectTab()
                            }
                            self.showAlert(title: R.string.localizable.congrates().uppercased(),
                                           message: R.string.localizable.upgradedSuccessfully(),
                                           actions: [okAction])
                        } else {
                            self.showAlert(title: R.string.localizable.error(),
                                           message: error)
                        }
                    })
                }
            } else {
                showAlert(title: R.string.localizable.underMaintanance(),
                          message: R.string.localizable.weAreWorkingToFixItPleaseTryAgainLater())
            }
        } else {
            showAlert(title: "",
                      message: R.string.localizable.noInternetConnection())
        }
    }
    
    @IBAction func btnCloseSelected( _ sender: UIButton) {
        coordinator?.redirectTab()
    }
}

//MARK: create layout
extension PremiumSelectionViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        return UICollectionViewCompositionalLayout(section: section)
    }
}

//MARK: create snapshot
extension PremiumSelectionViewController: UICollectionViewDelegate {
    func configDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Int, PremiumSelection>(collectionView: collView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.introCollCell, for: indexPath)!
            cell.setUI()
            cell.configData(data: itemIdentifier)
            return cell
        })
    }
}

//MARK: create snapshot
extension PremiumSelectionViewController {
    func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, PremiumSelection>()
        snapshot.appendSections([0])
        snapshot.appendItems(PremiumSelection.allCases)
        dataSource.apply(snapshot)
    }
}

extension PremiumSelectionViewController {
    func inAppApi() {
        
        let para : Parameters = [
            "api_key": API_Key,
            "package_name" : APP_IDENTIFIER,
            "inapp_plan" : selectedPlan.getInAppType(),
            "inapp_amount" : selectedPlan.getInAppPrice()
        ]
        
        //        print(para)
        
        AF.request(updateInappService_URL,
                   method: .post,
                   parameters: para,
                   headers: nil).responseString { res in
        }
    }
}
