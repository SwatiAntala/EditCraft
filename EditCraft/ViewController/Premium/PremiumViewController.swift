//
//  PremiumViewController.swift
//  EditCraft
//
//  Created by swati on 09/09/24.
//

import UIKit
import MBProgressHUD
import Alamofire
import StoreKit

class PremiumViewController: BaseVC {

    @IBOutlet weak var imgPremium: UIImageView!
    @IBOutlet weak var lblEditCraft: UILabel!
    @IBOutlet weak var lblUnlock: UILabel!
    @IBOutlet weak var imgAds: UIImageView!
    @IBOutlet weak var lblRemoveAds: UILabel!
    @IBOutlet weak var imgSeperator: UIImageView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblYouCanCancelAnyTime: UILabel!
    @IBOutlet weak var btnSubscribeNow: ECButton!
    @IBOutlet weak var btnTerm: UIButton!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    var selectedIndexPath: IndexPath? {
        didSet {
            let indexPaths = [oldValue, selectedIndexPath].compactMap({$0})
            UIView.performWithoutAnimation {
                self.collView.reloadItems(at: indexPaths)
            }
        }
    }
    
    var isFromInitial: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setUI() {
        setLayout()
        setImage()
        setData()
        setColor()
        setFont()
        btnSubscribeNow.setAsPrimary()
    }
    
    func setLayout() {
        collView.register(R.nib.premiumCollectionViewCell)
        collView.setCollectionViewLayout(createCompositionalLayout(), animated: true)
        selectedIndexPath = IndexPath(item: setPremiumOption().rawValue,
                                      section: 0)
    }
    
    func setImage() {
        imgPremium.image = R.image.img_premium()
        imgAds.image = R.image.img_no_ads()
        imgSeperator.image = R.image.ic_border()
        btnClose.setImage(R.image.ic_close()?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnClose.tintColor = AppColor.white
    }
    
    func setFont() {
        lblEditCraft.font = AppFont.getFont(style: .largeTitle, weight: .bold)
        lblUnlock.font = AppFont.getFont(style: .largeTitle, weight: .bold)
        lblRemoveAds.font = AppFont.getFont(style: .largeTitle, weight: .bold)
        lblYouCanCancelAnyTime.font = AppFont.getFont(style: .title3, weight: .bold)
        [btnTerm, btnRestore, btnPrivacyPolicy].forEach { btn in
            btn?.titleLabel?.font = AppFont.getFont(style: .title3, weight: .bold)
        }
    }
    
    func setColor() {
        [btnTerm, btnPrivacyPolicy].forEach { btn in
            btn?.setTitleColor(AppColor.Text.secondary, for: .normal)
        }
        btnRestore.setTitleColor(AppColor.white, for: .normal)
        lblEditCraft.textColor = AppColor.white
        lblUnlock.textColor = AppColor.themeSecondary
        lblRemoveAds.textColor = AppColor.white
        lblYouCanCancelAnyTime.textColor = AppColor.white
    }
    
    func setData() {
        lblEditCraft.text = R.string.localizable.editCraft()
        lblUnlock.text = R.string.localizable.unlock()
        lblRemoveAds.text = R.string.localizable.removeAds()
        lblYouCanCancelAnyTime.text = R.string.localizable.youCanCancelAnytime()
        btnSubscribeNow.setTitle(R.string.localizable.subscribeNow(),
                                 for: .normal)
        
        btnTerm.setTitle(R.string.localizable.termsOfUse(),
                         for: .normal)
        
        btnRestore.setTitle(R.string.localizable.restore(),
                         for: .normal)
        
        btnPrivacyPolicy.setTitle(R.string.localizable.privacyPolicy(),
                         for: .normal)
    }
    
    func setPremiumOption() -> Premium {
        let offerType = AppData.sharedInstance.introInAppType.lowercased()
        
        if offerType == "w" {
            return .weekly
        } else if offerType == "m" {
            return .monthly
        } else if offerType == "y" {
            return .yearly
        } else {
            return .weekly
        }
    }
    
    @IBAction func btnSubscribeNowSelected(_ sender: UIButton) {
        handleContinue()
    }
    
    @IBAction func btnTermSelected(_ sender: UIButton) {
        coordinator?.redirectWebView(url: AppData.sharedInstance.strTermCondition,
                                     screenTitle: R.string.localizable.termsCondition())
    }
    
    @IBAction func btnRestoreSelected(_ sender: UIButton) {
        if InternetConnectionManager.isConnectedToNetwork() {
            if AppData.sharedInstance.strInAppWork == "YES" {
                MBProgressHUD.showAdded(to: self.view, animated: true)
                IAPManager.init().doRestore(self) { (success, error) in
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        if success {
                            let okAction = UIAlertAction(title: R.string.localizable.oK(), style: .default) { _ in
                                self.redirectionHandle()
                            }
                            self.showAlert(title: R.string.localizable.congrates().uppercased(),
                                           message: R.string.localizable.restoredSuccessfully(),
                                           actions: [okAction])
                        } else {
                            self.showAlert(title: R.string.localizable.error(),
                                      message: error)
                        }
                    })
                }
            } else {
                showAlert(title: R.string.localizable.underMaintanance().uppercased(),
                          message: R.string.localizable.weAreWorkingToFixItPleaseTryAgainLater())
            }
        } else {
            showAlert(title: "",
                      message: R.string.localizable.noInternetConnection())
        }
    }
    
    @IBAction func btnPrivacyPolicySelected(_ sender: UIButton) {
        coordinator?.redirectWebView(url: AppData.sharedInstance.strPrivacyPolicy,
                                     screenTitle: R.string.localizable.privacyPolicy())
    }
    
    @IBAction func btnCloseSelected(_ sender: UIButton) {
        if isFromInitial {
            updateOrContinue()
        } else {
            coordinator?.navigationController.popViewController(animated: true)
        }
    }
    
}

extension PremiumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Premium.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.premiumCollCell, for: indexPath)!
        cell.setUI()
        if let item = Premium(rawValue: indexPath.item) {
            cell.configData(data: item)
        }
        cell.updateUI(isSelected: selectedIndexPath == indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }
}

//MARK: layout
extension PremiumViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, environment) -> NSCollectionLayoutSection? in
            self.listLayoutSection()
        }
    }
    
    private func listLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                              heightDimension: .estimated(360))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        group.interItemSpacing = .fixed(16)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
}

extension PremiumViewController {
    func handleContinue() {
        if AppData.sharedInstance.inAppWork {
            if InternetConnectionManager.isConnectedToNetwork() {
                if AppData.sharedInstance.strInAppWork == "YES" {
                    
                    guard let selectedIndexPath else { return
                        showAlert(title: R.string.localizable.error(),
                                  message: R.string.localizable.pleseSelectPremiumPlan())
                    }
                    guard let selectedPlan = Premium(rawValue: selectedIndexPath.item) else { return }
                    
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                    
                    IAPManager.init().doPurchase(self, selectedPlan.getInAppID()) { (success, error) in
                        DispatchQueue.main.async(execute: {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            if success {
                                let okAction = UIAlertAction(title: R.string.localizable.oK(), style: .default) { _ in
                                    self.inAppApi()
                                    self.redirectionHandle()
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
                    showAlert(title: R.string.localizable.underMaintanance().uppercased(),
                              message: R.string.localizable.weAreWorkingToFixItPleaseTryAgainLater())
                }
            } else {
                showAlert(title: "",
                          message: R.string.localizable.noInternetConnection())
            }
        } else {
            showAlert(title: R.string.localizable.editCraft(),
                      message: R.string.localizable.weApologizeForTheInconvenience())
        }
    }
    
    func inAppApi() {
        
        guard let selectedIndexPath else { return }
        guard let selectedPlan = Premium(rawValue: selectedIndexPath.item) else { return }
        
        let para : Parameters = [
            "api_key": API_Key,
            "package_name" : APP_IDENTIFIER,
            "inapp_plan" : selectedPlan.getInAppType(),
            "inapp_amount" : selectedPlan.getInAppPrice()
        ]
        
        AF.request(updateInappService_URL,
                   method: .post,
                   parameters: para,
                   headers: nil).responseString { res in
        }
    }
    
    func redirectionHandle() {
        if self.isFromInitial {
            self.coordinator?.redirectTab()
        }
        else if let vcs = self.coordinator?.navigationController.viewControllers {
            if let tabVC = vcs.first(where: {$0 is TabbarViewController}) {
                self.coordinator?.navigationController.popToViewController(tabVC,
                                                                           animated: true)
            }
        }
    }
}

extension PremiumViewController {
    //MARK: Other Method
    func updateOrContinue() {
        showAds()
    }
    
    //MARK: INTRESTIAL AD METHOD
    func showAds() {
        if AppData.sharedInstance.isPaid == false && AppData.sharedInstance.isAdmobAd == "YES" && AppData.sharedInstance.strIntrestialShow == "YES" {
            AdmobManager.shared.showAds(vw: self, str: .premium)
        } else {
            coordinator?.redirectTab()
        }
    }
    
    func sendToAdmob(str : HomeNavigation) {
        if AppData.sharedInstance.isPaid == false && AppData.sharedInstance.isAdmobAd == "YES" && AppData.sharedInstance.strIntrestialShow == "YES" {
            AdmobManager.shared.requestAds()
        }
        switch str {
        case .premium:
            coordinator?.redirectTab()
        default:
            break
        }
    }
}
