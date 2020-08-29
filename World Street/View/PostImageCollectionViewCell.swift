//
//  PostImageCollectionViewCell.swift
//  World Street
//
//  Created by 罗帅卿 on 6/25/20.
//  Copyright © 2020 Shuaiqing Luo. All rights reserved.
//

import UIKit

class PostImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    static let identifier = "PostImageCollectionViewCell"
    
    var delegate: myPostImageCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with image: UIImage) {
        imageView.isHidden = false
        imageView.image = image
        uploadButton.isHidden = true
    }
    
    public func configureLastCell() {
        imageView.isHidden = true
        uploadButton.isHidden = false
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PostImageCollectionViewCell", bundle: nil)
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        print("here")
        delegate?.uploadButtonPressed()
    }
    
}

protocol myPostImageCollectionViewCellDelegate {
    func uploadButtonPressed()
}
