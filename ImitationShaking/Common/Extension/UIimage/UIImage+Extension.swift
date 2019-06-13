//
//  UIImage+Extension.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/27.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Photos

extension UIImage {
    private func convertViewToImage(view: UIView) -> UIImage {
        let size = view.bounds.size
        //第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数屏幕密度
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        //把控制器的view的内容画到上下文中
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //从上下文中生成一张图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        return image!
    }
    
    public class func colorCreateImage(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let content: CGContext = UIGraphicsGetCurrentContext()!
        content.setFillColor(color.cgColor)
        content.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func imageByRemoveWhiteBg() -> UIImage? {
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking: colorMasking)
    }
    
    func transparentColor(colorMasking:[CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: CGRect(x:0, y:0, width:self.size.width,
                                                        height:self.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
    
    // CMSampleBufferRef -> UIImage
    static func imageConvert(_ sampleBuffer: CMSampleBuffer?) -> UIImage? {
        guard sampleBuffer != nil && CMSampleBufferIsValid(sampleBuffer!) == true  else {
            return nil
        }
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer!)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!)
        return UIImage(ciImage: ciImage)
    }
    
}


