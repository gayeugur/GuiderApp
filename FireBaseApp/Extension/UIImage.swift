//
//  UIImage.swift
//  FireBaseApp
//
//  Created by gayeugur on 14.01.2024.
//

import Foundation
import UIKit

extension UIImage {
    func mask(withColor color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext(), let _ = cgImage else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        draw(in: rect)
        context.setBlendMode(.sourceIn)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}
