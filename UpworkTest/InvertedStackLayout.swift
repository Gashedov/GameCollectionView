import Foundation
import UIKit

class InvertedStackLayout: UICollectionViewLayout {
    var cellSize: CGFloat = 100
    var sectionsInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    var sectionsOffset: CGFloat = 20
    var headerInsets = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
    var headerSize = CGSize(width: 320, height: 50)
    
    var itemsPerRow: Int {
        Int(collectionViewContentSize.width/cellSize)
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            var height: CGFloat = 0.0
            let bounds = collectionView?.bounds ?? .zero
            let itemsPerRow = Int(bounds.width/cellSize)

            if let collectionView = collectionView {
                for section in 0..<collectionView.numberOfSections {
                    var sectionHeight: CGFloat = 0
                    sectionHeight += headerSize.height + headerInsets.top + headerInsets.bottom
                    
                    if let numItems = numberOfItemsInSection(section) {
                        var numberOfRows = numItems/itemsPerRow
                        if numItems%itemsPerRow != 0 {
                            numberOfRows += 1
                        }
                        sectionHeight += CGFloat(numberOfRows) * cellSize
                    }
                    
                    sectionHeight += sectionsInsets.bottom + sectionsInsets.top
                    sectionHeight += sectionsOffset
                    
                    height += sectionHeight
                }
            }
            return CGSize(
                width: CGFloat(itemsPerRow)*cellSize,
                height: max(height, bounds.height)
            )
        }
    }
    
    override init() {
        super.init()
        register(RoundedCollectionBackgroundView.self, forDecorationViewOfKind: RoundedCollectionBackgroundView.reuseId)
        register(RoundedCollectionBorderView.self, forDecorationViewOfKind: RoundedCollectionBorderView.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs: [UICollectionViewLayoutAttributes] = []

        guard let collectionView else { return layoutAttrs }
        for section in 0 ..< collectionView.numberOfSections {
            if let headerAttr = layoutAttributesForSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                at: IndexPath(item: 0, section: section)
            ) {
                layoutAttrs.append(headerAttr)
            }
            
            if let numberOfSectionItems = numberOfItemsInSection(section) {
                for item in 0 ..< numberOfSectionItems {
                    let indexPath = IndexPath(item: item, section: section)
                    let layoutAttr = layoutAttributesForItem(at: indexPath)
                    
                    if let layoutAttr = layoutAttr, layoutAttr.frame.intersects(rect) {
                        layoutAttrs.append(layoutAttr)
                    }
                }
            }
            
            if let decorationAtts = layoutAttributesForDecorationView(
                ofKind: RoundedCollectionBackgroundView.reuseId,
                at: IndexPath(item: 0, section: section)
            ) {
                if rect.intersects(decorationAtts.frame) {
                    layoutAttrs.append(decorationAtts)
                }
            }
            
            if let decorationAtts = layoutAttributesForDecorationView(
                ofKind: RoundedCollectionBorderView.reuseId,
                at: IndexPath(item: 0, section: section)
            ) {
                if rect.intersects(decorationAtts.frame) {
                    layoutAttrs.append(decorationAtts)
                }
            }
        }
        return layoutAttrs
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let contentSize = self.collectionViewContentSize
    
        let row = indexPath.item/itemsPerRow
        let rowPosition = indexPath.item - row*itemsPerRow
        
        var xPosition = sectionsInsets.left + CGFloat(rowPosition) * cellSize
        if row%2 != 0 {
            xPosition = contentSize.width - xPosition + sectionsInsets.left + sectionsInsets.right - cellSize
        }
        
        var sectionStartY = yPositionForSection(indexPath.section)
        sectionStartY += headerSize.height + headerInsets.bottom

        layoutAttr.frame = CGRect(
            x: xPosition,
            y: sectionStartY + CGFloat(row) * cellSize,
            width: cellSize,
            height: cellSize
        )

        return layoutAttr
    }
    
    override func layoutAttributesForSupplementaryView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let sectionStartY = yPositionForSection(indexPath.section)
        
        let headerY = sectionStartY - headerInsets.top
        let headerX = (collectionView?.bounds.width ?? 0)/2 - headerSize.width/2 // add insets
        
        attributes.frame = CGRect(
            origin: .init(x: headerX, y: headerY),
            size: headerSize
        )

        return attributes
    }
    
    override func layoutAttributesForDecorationView(
        ofKind elementKind: String,
        at indexPath: IndexPath
    ) -> UICollectionViewLayoutAttributes? {
        var height: CGFloat = 0
        if let numItems = numberOfItemsInSection(indexPath.section) {
            var numberOfRows = numItems/itemsPerRow
            if numItems%itemsPerRow != 0 {
                numberOfRows += 1
            }
            height += CGFloat(numberOfRows) * cellSize
        }
        
        let width = CGFloat(itemsPerRow)*cellSize
        
        let sectionStartY = yPositionForSection(indexPath.section)
        
        let decorationY = sectionStartY + headerSize.height + headerInsets.bottom
        let decorationX: CGFloat = sectionsInsets.left
        
        let attributesFrame = CGRect(
            origin: .init(x: decorationX, y: decorationY),
            size: .init(width: width, height: height)
        )
        
        if elementKind == RoundedCollectionBackgroundView.reuseId {
            let atts = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: RoundedCollectionBackgroundView.reuseId,
                with: indexPath
            )
            
            atts.zIndex = -2
            atts.frame = attributesFrame
            return atts
        }
        
        if elementKind == RoundedCollectionBorderView.reuseId {
            let atts = UICollectionViewLayoutAttributes(
                forDecorationViewOfKind: RoundedCollectionBorderView.reuseId,
                with: indexPath
            )
            
            atts.zIndex = -1
            atts.frame = attributesFrame
            return atts
        }
        
        return nil
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let oldBounds = self.collectionView?.bounds,
            oldBounds.width != newBounds.width || oldBounds.height != newBounds.height
        {
            return true
        }

        return false
    }
}

extension InvertedStackLayout {
    private func yPositionForSection(_ section: Int) -> CGFloat {
        var yPosition: CGFloat = 0
        for index in 0..<section {
            yPosition += fullHeightOfSection(index)
        }
        return yPosition
    }
    
    private func numberOfItemsInSection(_ section: Int) -> Int? {
        guard let collectionView = self.collectionView,
              let numSectionItems = collectionView.dataSource?.collectionView(
                collectionView,
                numberOfItemsInSection: section
              ) else { return 0 }
        return numSectionItems
    }
    
    private func fullHeightOfSection(_ section: Int) -> CGFloat {
        var height: CGFloat = 0
        if let headerAttr = layoutAttributesForSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: section)
        ) {
            height += headerAttr.frame.height
            height += headerInsets.top + headerInsets.bottom
        }
        if let numItems = numberOfItemsInSection(section) {
            var numberOfRows = numItems/itemsPerRow
            if numItems%itemsPerRow != 0 {
                numberOfRows += 1
            }
            height += CGFloat(numberOfRows) * cellSize
        }
        
        height += sectionsInsets.bottom + sectionsInsets.top
        height += sectionsOffset
        
        return height
    }
}

