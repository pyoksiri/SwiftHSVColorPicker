//
//  SwiftHSVColorPicker.swift
//  SwiftHSVColorPicker
//
//  Created by johankasperi on 2015-08-20.
//

import UIKit

open class SwiftHSVColorPicker: UIView, ColorWheelDelegate, BrightnessViewDelegate {
    var colorWheel: ColorWheel!
    var brightnessView: BrightnessView!
    var selectedColorView: SelectedColorView!

    open var color: UIColor!
    var hue: CGFloat = 1.0
    var saturation: CGFloat = 1.0
    var brightness: CGFloat = 1.0
    open var label: UILabel!
    open var iconBrightness: UIImageView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    open func setViewColor(_ color: UIColor) {
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        let ok: Bool = color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        if (!ok) {
            print("SwiftHSVColorPicker: exception <The color provided to SwiftHSVColorPicker is not convertible to HSV>")
        }
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        self.color = color
        setup()
    }
    
    func setup() {
        // Remove all subviews
        let views = self.subviews
        for view in views {
            view.removeFromSuperview()
        }
        
        let selectedColorViewHeight: CGFloat = 30.0
        let brightnessViewHeight: CGFloat = 24.0
        
        // let color wheel get the maximum size that is not overflow from the frame for both width and height
        let colorWheelSize = min(self.bounds.width, self.bounds.height - selectedColorViewHeight - brightnessViewHeight - 20)
        
        // let the all the subviews stay in the middle of universe horizontally
        let centeredX = (self.bounds.width - colorWheelSize) / 2.0
        
        // Init SelectedColorView subview
        selectedColorView = SelectedColorView(frame: CGRect(x: (self.bounds.width/2) - 100.0, y:0, width: 200.0, height: selectedColorViewHeight), color: self.color)
        // Add selectedColorView as a subview of this view
        self.addSubview(selectedColorView)
        
        // Init new ColorWheel subview
        colorWheel = ColorWheel(frame: CGRect(x: centeredX, y: selectedColorView.frame.maxY, width: colorWheelSize, height: colorWheelSize), color: self.color)
        colorWheel.delegate = self
        // Add colorWheel as a subview of this view
        self.addSubview(colorWheel)
        
        iconBrightness = UIImageView.init(frame: CGRect(x: 20.0, y: colorWheel.frame.maxY + 18, width: 24.0, height: 24.0))
        self.addSubview(iconBrightness)
        
        // Init new BrightnessView subview
        brightnessView = BrightnessView(frame: CGRect(x: iconBrightness.frame.size.width + iconBrightness.frame.origin.x + 10.0, y: colorWheel.frame.maxY + 20, width: self.bounds.width - (iconBrightness.frame.size.width + iconBrightness.frame.origin.x + 10.0) - 20.0, height: brightnessViewHeight), color: self.color)
        brightnessView.delegate = self
        // Add brightnessView as a subview of this view
        self.addSubview(brightnessView)
        
        label = UILabel.init(frame: CGRect(x: iconBrightness.frame.origin.x, y: iconBrightness.frame.origin.y - 24.0, width: 200.0, height: 20.0))
        label.text = "BRIGHTNESS"
        self.addSubview(label)
    }
    
    func hueAndSaturationSelected(_ hue: CGFloat, saturation: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        brightnessView.setViewColor(self.color)
        selectedColorView.setViewColor(self.color)
    }
    
    func brightnessSelected(_ brightness: CGFloat) {
        self.brightness = brightness
        self.color = UIColor(hue: self.hue, saturation: self.saturation, brightness: self.brightness, alpha: 1.0)
        colorWheel.setViewBrightness(brightness)
        selectedColorView.setViewColor(self.color)
    }
}
