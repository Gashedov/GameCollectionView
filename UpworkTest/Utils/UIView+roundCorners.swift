import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        let containerLayer = CALayer()
        
        containerLayer.backgroundColor = layer.backgroundColor
        containerLayer.frame = bounds
        containerLayer.mask = maskLayer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.insertSublayer(containerLayer, at: 0)
    }
}
