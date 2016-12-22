//
//  BusAnnotation.swift
//  TreBus
//
//  Created by Mikko Riihimäki on 31.8.2016.
//  Copyright © 2016 Mikko Riihimäki. All rights reserved.
//

import MapKit

class BusAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    dynamic var coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let vehicleRef: String?
    
    init(lineRef: String, vehicleRef: String, location: CLLocationCoordinate2D, origin: String, destination: String) {
        self.title = lineRef
        self.subtitle = origin + " \u{279D} " + destination
        self.coordinate = location
        self.image = BusAnnotation.drawAnnotationNumber(size: CGSize(width: 38, height: 38), text: lineRef)
        self.vehicleRef = vehicleRef
        
        super.init()
    }

    class func drawAnnotationNumber(size: CGSize, text: String) -> UIImage? {

        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0

        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }

        let lineWidth: CGFloat = 2.0
        let shadowWidth: CGFloat = 1.0

        // Draw small shadow around circle
        let circleRect = bounds.insetBy(dx: lineWidth+shadowWidth, dy: lineWidth+shadowWidth)
        context.setLineWidth(shadowWidth)
        context.setStrokeColor(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor)
        context.addEllipse(in: bounds.insetBy(dx: shadowWidth, dy: shadowWidth))
        context.strokePath()

        // Blue fill
        context.setLineWidth(lineWidth)
        context.setFillColor(UIColor.blue.cgColor)
        context.fillEllipse(in: circleRect)

        // White border
        context.setStrokeColor(UIColor.white.cgColor)
        context.addEllipse(in: circleRect)
        context.strokePath()

        // Draw text
        let fieldColor: UIColor = UIColor.white
        let fieldFont = UIFont(name: "AvenirNextCondensed-DemiBold", size: 16)

        // Line spacing
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 2.0

        let attributes: [String: Any] = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSFontAttributeName: fieldFont!
        ]

        let textString: NSString = NSString(string: text)
        let textSize = textString.size(attributes: attributes)
        let textOrigin = CGPoint(x: bounds.minX + (bounds.width-textSize.width)/2, y: bounds.minY + (bounds.height-textSize.height)/2)

        textString.draw(at: textOrigin, withAttributes: attributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
