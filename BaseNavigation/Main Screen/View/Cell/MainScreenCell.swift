//
// Created by Pavel Guzenko on 14.12.2021.
//

import Foundation
import UIKit

class MainScreenCell: UICollectionViewCell {
    // String Identifier of cell, for use in tableview methods
    public static func cellIdentifier() -> String {
        String(describing: MainScreenCell.self)
    }

    // Entity model for cell
    public var entity: MainScreenViewEntityProtocol? {
        willSet {
            // If previously we already use cell, we must cancel image load
            if let url = entity?.imageUrl {
                imageView.cancelImageLoad(url)
            }
        }
        didSet {
            guard let entity = entity else {
                return
            }
            // Select cell background for better test
            imageView.backgroundColor = entity.backgroundColor
            // Download and set image by imageUrl
            imageView.setImageUrl(entity.imageUrl) { image, error in
                // if image was downloaded we notify about it
                if image != nil {
                    entity.delegate?.imageWasDownloadForEntity(entity)
                }
            }
        }
    }

    // MARK: User Interface

    // Default image offset
    private let defaultOffset: CGFloat = 10

    // Default imageView for showing image
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .yellow
        return image
    }()

    // Left(leading) constraint for imageView
    private var leftConstraint: NSLayoutConstraint?
    // Right(trailing) constraint for imageView
    private var rightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        updateDefaultConstraint()
    }

    // Add image to view and select constraints
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        leftConstraint = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultOffset)
        leftConstraint?.isActive = true
        rightConstraint = imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultOffset)
        rightConstraint?.isActive = true
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    // Update image left and right constraints to default state (10 offset)
    private func updateDefaultConstraint() {
        leftConstraint?.constant = defaultOffset
        rightConstraint?.constant = -defaultOffset
    }

    // Removes the imageview to the right, when used with animation,
    // there is a smooth departure towards the content in the cell
    public func hideContent() {
        leftConstraint?.constant = bounds.width
        rightConstraint?.constant = +bounds.width + 2 * defaultOffset
    }
}