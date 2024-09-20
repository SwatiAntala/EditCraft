//
//  StarRatingView.swift
//  VideoIt
//
//  Created by swati on 16/06/24.
//

import Foundation

import Foundation
import UIKit

protocol StarRatingDelegate: AnyObject {
    func didChangeRating(_ rating: Int)
}

class StarRatingView: UIView {
    
    weak var delegate: StarRatingDelegate?
    
    var maxRating: Int = 5
    var currentRating: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var starSize: CGSize = CGSize(width: 44, height: 44)
    var spacing: CGFloat = 16.0
    var filledStarImage: UIImage = R.image.ic_star_fill()!
    var emptyStarImage: UIImage = R.image.ic_star_unfill()!
    private var ratingButtons: [UIButton] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRatingButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRatingButtons()
    }
    
    private func setupRatingButtons() {
        for _ in 0..<maxRating {
            let button = UIButton(type: .custom)
            button.setImage(emptyStarImage, for: .normal)
            button.setImage(filledStarImage, for: .selected)
            button.addTarget(self, action: #selector(ratingButtonTapped(_:)), for: .touchUpInside)
            addSubview(button)
            ratingButtons.append(button)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var starFrame = CGRect(x: 0, y: 0, width: starSize.width, height: starSize.height)
        
        for (index, button) in ratingButtons.enumerated() {
            starFrame.origin.x = CGFloat(index) * (starSize.width + spacing)
            button.frame = starFrame
            button.isSelected = index < currentRating
        }
    }
    
    @objc private func ratingButtonTapped(_ sender: UIButton) {
        guard let index = ratingButtons.firstIndex(of: sender) else { return }
        ratingButtons.forEach({$0.setImage(filledStarImage, for: .selected)})
        let newRating = index + 1
        if newRating == currentRating {
            currentRating = 0
        } else {
            currentRating = newRating
            sender.setImage(R.image.ic_star_last(), for: .selected)
        }
        delegate?.didChangeRating(currentRating)
    }
}
