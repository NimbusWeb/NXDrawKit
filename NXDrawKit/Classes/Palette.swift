//
//  Palette.swift
//  NXDrawKit
//
//  Created by Nicejinux on 2016. 7. 12..
//  Copyright © 2016년 Nicejinux. All rights reserved.
//

import UIKit


@objc public protocol PaletteDelegate {
    @objc optional func didChangeBrushAlpha(_ alpha:CGFloat)
    @objc optional func didChangeBrushWidth(_ width:CGFloat)
    @objc optional func didChangeBrushColor(_ color:UIColor)
    
    @objc optional func colorWithTag(_ tag: NSInteger) -> UIColor?
    @objc optional func alphaWithTag(_ tag: NSInteger) -> CGFloat
    @objc optional func widthWithTag(_ tag: NSInteger) -> CGFloat
}


open class Palette: UIView {
    @objc open weak var delegate: PaletteDelegate?
    private var brush: Brush = Brush()

    private let buttonDiameter = UIScreen.main.bounds.width / 10.0
    private let buttonPadding = UIScreen.main.bounds.width / 25.0
    private let columnCount = 4
    
    private var colorButtonList = [CircleButton]()
    private var alphaButtonList = [CircleButton]()
    private var widthButtonList = [CircleButton]()
    
    private var totalHeight: CGFloat = 0.0;
    
    private weak var colorPaletteView: UIView?
    private weak var alphaPaletteView: UIView?
    private weak var widthPaletteView: UIView?
    
    
    // MARK: - Initializer
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc open func currentBrush() -> Brush {
        return self.brush
    }
    

    // MARK: - Private Methods
    override open var intrinsicContentSize : CGSize {
        let size: CGSize = CGSize(width: UIScreen().bounds.size.width, height: self.totalHeight)
        return size;
    }
    
    @objc open func setup() {
        self.backgroundColor = UIColor(red: 239/255, green: 240/255, blue: 242/255, alpha: 1.0)
        self.setupColorView()
        self.setupAlphaView()
        self.setupWidthView()
        self.setupDefaultValues()
    }
    
    @objc open func paletteHeight() -> CGFloat {
        return self.totalHeight
    }
    
    private func setupColorView() {
        let view = UIView()
        self.addSubview(view)
        self.colorPaletteView = view
        
        var button: CircleButton?
        for index in 1...12 {
            let color: UIColor = self.color(index)
            button = CircleButton(diameter: self.buttonDiameter, color: color, opacity: 1.0)
            button?.frame = self.colorButtonRect(index: index, diameter: self.buttonDiameter, padding: self.buttonPadding)
            button?.addTarget(self, action:#selector(Palette.onClickColorPicker(_:)), for: .touchUpInside)
            self.colorPaletteView!.addSubview(button!)
            self.colorButtonList.append(button!)
        }
        
        self.totalHeight = button!.frame.maxY + self.buttonPadding;
        self.colorPaletteView?.frame = CGRect(x: 0, y: 0, width: button!.frame.maxX + self.buttonPadding, height: self.totalHeight)
    }
    
    private func colorButtonRect(index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRect.zero
        let indexValue = index - 1
        let count = self.columnCount
        rect.origin.x = (CGFloat(indexValue % count) * diameter) + padding + (CGFloat(indexValue % count) * padding)
        rect.origin.y = (CGFloat(indexValue / count) * diameter) + padding + (CGFloat(indexValue / count) * padding)
        rect.size = CGSize(width: diameter, height: diameter)
        
        return rect
    }
    
    private func setupAlphaView() {
        let view = UIView()
        self.addSubview(view)
        self.alphaPaletteView = view
        
        var button: CircleButton?
        for index in (1...3).reversed() {
            let opacity = self.opacity(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.black, opacity: opacity)
            button?.frame = self.alphaButtonRect(index: index, diameter: self.buttonDiameter, padding: self.buttonPadding)
            self.alphaPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickAlphaPicker(_:)), for: .touchUpInside)
            self.alphaButtonList.append(button!)
        }
        
        let startX = (self.colorPaletteView?.frame)!.maxX
        self.alphaPaletteView?.frame = CGRect(x: startX, y: 0, width: button!.frame.maxX + self.buttonPadding, height: self.totalHeight)
    }
    
    private func alphaButtonRect(index: NSInteger, diameter: CGFloat, padding: CGFloat) -> CGRect {
        var rect: CGRect = CGRect.zero
        let indexValue = index - 1
        rect.origin.x = padding
        rect.origin.y = CGFloat(indexValue) * diameter + padding + (CGFloat(indexValue) * padding)
        rect.size = CGSize(width: diameter, height: diameter)
        
        return rect
    }
    
    private func setupWidthView() {
        let view = UIView()
        self.addSubview(view)
        self.widthPaletteView = view
        
        var button: CircleButton?
        var lastY: CGFloat = 0
        for index in 1...4 {
            let buttonDiameter = self.brushWidth(index)
            button = CircleButton(diameter: buttonDiameter, color: UIColor.black, opacity: 1)
            button?.frame = self.widthButtonRect(buttonDiameter, padding: self.buttonPadding, lastY: lastY)
            self.widthPaletteView!.addSubview(button!)
            button?.addTarget(self, action: #selector(Palette.onClickWidthPicker(_:)), for: .touchUpInside)

            lastY = (button?.frame)!.maxY
            self.widthButtonList.append(button!)
        }
        
        let startX = (self.alphaPaletteView?.frame)!.maxX
        self.widthPaletteView?.frame = CGRect(x: startX, y: 0, width: button!.frame.maxX + self.buttonPadding, height: self.totalHeight)
    }
    
    private func widthButtonRect(_ diameter: CGFloat, padding: CGFloat, lastY: CGFloat) -> CGRect {
        var rect: CGRect = CGRect.zero
        rect.origin.x = padding + ((self.buttonDiameter - diameter) / 2)
        rect.origin.y = lastY + padding
        rect.size = CGSize(width: diameter, height: diameter)
        
        return rect
    }

    private func setupDefaultValues() {
        var button: CircleButton = self.colorButtonList.first!
        button.isSelected = true
        self.brush.color = button.color!
        
        button = self.alphaButtonList.first!
        button.isSelected = true
        self.brush.alpha = button.opacity!
        
        button = self.widthButtonList.last!
        button.isSelected = true
        self.brush.width = button.diameter!
    }
    
    @objc private func onClickColorPicker(_ button: CircleButton) {
        self.brush.color = button.color!;
        let shouldEnable = !self.brush.color.isEqual(UIColor.clear)

        self.resetButtonSelected(self.colorButtonList, button: button)
        //self.updateColorOfButtons(self.widthButtonList, color: button.color!)
        self.updateColorOfButtons(self.alphaButtonList, color: button.color!, enable: shouldEnable)
        
        self.delegate?.didChangeBrushColor?(self.brush.color)
    }

    @objc private func onClickAlphaPicker(_ button: CircleButton) {
        self.brush.alpha = button.opacity!
        self.resetButtonSelected(self.alphaButtonList, button: button)
        
        self.delegate?.didChangeBrushAlpha?(self.brush.alpha)
    }

    @objc private func onClickWidthPicker(_ button: CircleButton) {
        self.brush.width = button.diameter!;
        self.resetButtonSelected(self.widthButtonList, button: button)
        
        self.delegate?.didChangeBrushWidth?(self.brush.width)
    }
    
    private func resetButtonSelected(_ list: [CircleButton], button: CircleButton) {
        for aButton: CircleButton in list {
            aButton.isSelected = aButton.isEqual(button)
        }
    }
    
    private func updateColorOfButtons(_ list: [CircleButton], color: UIColor, enable: Bool = true) {
        for aButton: CircleButton in list {
            aButton.update(color)
            aButton.isEnabled = enable
        }
    }
    
    private func color(_ tag: NSInteger) -> UIColor {
        if let color = self.delegate?.colorWithTag?(tag)  {
            return color
        }

        return self.colorWithTag(tag)
    }
    
    private func colorWithTag(_ tag: NSInteger) -> UIColor {
        switch(tag) {
            case 1:
                return UIColor(rgb: 0x000000)
            case 2:
                return UIColor(rgb: 0x555555)
            case 3:
                return UIColor(rgb: 0xAAAAAA)
            case 4:                
                return UIColor(rgb: 0xFFFFFF)
            case 5:
                return UIColor(rgb: 0x42A5F5)
            case 6:
                return UIColor(rgb: 0x009FB7)
            case 7:
                return UIColor(rgb: 0xB39DDB)
            case 8:
                return UIColor(rgb: 0x5573A7)
            case 9:
                return UIColor(rgb: 0x8BC34A)
            case 10:
                return UIColor(rgb: 0xFAC92F)
            case 11:
                return UIColor(rgb: 0xFDA639)
            case 12:
                return UIColor(rgb: 0xED5454)
            default:
                return UIColor.black
        }
    }
    
    private func opacity(_ tag: NSInteger) -> CGFloat {
        if let opacity = self.delegate?.alphaWithTag?(tag) {
            if 0 > opacity || opacity > 1 {
                return CGFloat(tag) / 3.0
            }
            return opacity
        }

        return CGFloat(tag) / 3.0
    }

    private func brushWidth(_ tag: NSInteger) -> CGFloat {
        if let width = self.delegate?.widthWithTag?(tag) {
            if 0 > width || width > self.buttonDiameter {
                return self.buttonDiameter * (CGFloat(tag) / 4.0)
            }
            return width
        }
        return self.buttonDiameter * (CGFloat(5-tag) / 4.0)
    }
}

public extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
