//
//  ZLEditToolCells.swift
//  ZLImageEditor
//
//  Created by long on 2021/12/21.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

// MARK: Edit tool cell

class ZLEditToolCell: UICollectionViewCell {
    var toolType: ZLImageEditorConfiguration.EditTool = .draw {
        didSet {
            switch toolType {
            case .draw:
                icon.image = .zl.getImage("zl_drawLine")
                icon.highlightedImage = .zl.getImage("zl_drawLine_selected")
            case .clip:
                icon.image = .zl.getImage("zl_clip")
                icon.highlightedImage = .zl.getImage("zl_clip")
            case .imageSticker:
                icon.image = .zl.getImage("zl_imageSticker")
                icon.highlightedImage = .zl.getImage("zl_imageSticker")
            case .textSticker:
                icon.image = .zl.getImage("zl_textSticker")
                icon.highlightedImage = .zl.getImage("zl_textSticker")
            case .mosaic:
                icon.image = .zl.getImage("zl_mosaic")
                icon.highlightedImage = .zl.getImage("zl_mosaic_selected")
            case .filter:
                icon.image = .zl.getImage("zl_filter")
                icon.highlightedImage = .zl.getImage("zl_filter_selected")
            case .adjust:
                icon.image = .zl.getImage("zl_adjust")
                icon.highlightedImage = .zl.getImage("zl_adjust_selected")
            }
            if let color = UIColor.zl.toolIconHighlightedColor {
                icon.highlightedImage = icon.highlightedImage?
                    .zl.fillColor(color)
            }
        }
    }
    
    lazy var icon = UIImageView(frame: contentView.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: draw color cell

class ZLDrawColorCell: UICollectionViewCell {
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 22.5
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return view
    }()
    
    lazy var bgWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        return view
    }()
    
    var color: UIColor = .clear {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bgWhiteView)
        contentView.addSubview(colorView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.center = contentView.center
        bgWhiteView.center = contentView.center
    }
}

// MARK: filter cell

class ZLFilterImageCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: adjust tool cell

class ZLAdjustToolCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: bounds.height - 30, width: 100, height: 30)
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: (bounds.width - 30) / 2, y: 0, width: 30, height: 30)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var adjustTool: ZLImageEditorConfiguration.AdjustTool = .brightness {
        didSet {
            switch adjustTool {
            case .brightness:
                imageView.image = .zl.getImage("zl_brightness")
                imageView.highlightedImage = .zl.getImage("zl_brightness_selected")
                nameLabel.text = localLanguageTextValue(.brightness)
            case .contrast:
                imageView.image = .zl.getImage("zl_contrast")
                imageView.highlightedImage = .zl.getImage("zl_contrast_selected")
                nameLabel.text = localLanguageTextValue(.contrast)
            case .saturation:
                imageView.image = .zl.getImage("zl_saturation")
                imageView.highlightedImage = .zl.getImage("zl_saturation_selected")
                nameLabel.text = localLanguageTextValue(.saturation)
            }
            if let color = UIColor.zl.toolIconHighlightedColor {
                imageView.highlightedImage = imageView.highlightedImage?
                    .zl.fillColor(color)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Create a stack view
           let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel])
           stackView.axis = .vertical // You can also set it to .horizontal if you want side-by-side layout
           stackView.distribution = .fill // Adjust this based on how you want the space to be distributed
           stackView.alignment = .center // Aligns the elements in the center
           stackView.spacing = 8 // Space between imageView and nameLabel

           // Add stack view to contentView
           contentView.addSubview(stackView)

           // Set up constraints for the stack view
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
               stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
               stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
               stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
           ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
