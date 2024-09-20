//
//  VICustomView.swift
//  VideoIt
//
//  Created by swati on 26/04/24.
//

import Foundation
import UIKit

class VICustomView: UIView {
    
    @IBOutlet weak var ancContainerView: UIView!
    var hasData: Bool = false
    var totalHieght: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubViews()
        commonInit()
    }
    
    private func initSubViews() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        assert(ancContainerView != nil, "ContainerView not set")
        ancContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(ancContainerView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: ancContainerView.topAnchor),
            leadingAnchor.constraint(equalTo: ancContainerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: ancContainerView.trailingAnchor),
            bottomAnchor.constraint(equalTo: ancContainerView.bottomAnchor),
        ])
    }
    
    public func removeView() {
        ancContainerView.removeFromSuperview()
    }
    
    public func addView() {
        addSubview(ancContainerView)
        addConstraints()
    }
    
    /// Use this method to write common code after initialization of View
    func commonInit() { }
    
    func applyShadowOffset(shouldSetShadow: Bool = false) {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        if shouldSetShadow == false{
            layer.shadowColor = UIColor.black.cgColor
        }
        else {
            layer.shadowColor = UIColor.clear.cgColor
        }
    }
}
