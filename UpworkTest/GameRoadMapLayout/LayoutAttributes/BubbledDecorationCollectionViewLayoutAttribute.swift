import UIKit

class BubbledDecorationCollectionViewLayoutAttribute: UICollectionViewLayoutAttributes {
    var color: UIColor? = .white
    var itemsPerRow: Int = 0
    var rowsCount: Int = 0
    var cellSize: CGFloat = 0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? BubbledDecorationCollectionViewLayoutAttribute
        copy?.color = self.color
        copy?.itemsPerRow = self.itemsPerRow
        copy?.rowsCount = self.rowsCount
        copy?.cellSize = self.cellSize
        return copy as Any
    }
}
