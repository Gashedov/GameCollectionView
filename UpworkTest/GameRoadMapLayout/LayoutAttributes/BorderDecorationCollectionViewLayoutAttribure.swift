import UIKit

class BorderDecorationCollectionViewLayoutAttribute: UICollectionViewLayoutAttributes {
    var color: UIColor? = .white
    var borderWidth: CGFloat = 4
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as? BorderDecorationCollectionViewLayoutAttribute
        copy?.color = self.color
        copy?.borderWidth = self.borderWidth
        return copy as Any
    }
}
