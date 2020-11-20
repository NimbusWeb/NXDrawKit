//
//  ToolBar.swift
//  NXDrawKit
//
//  Created by Nicejinux on 7/13/16.
//  Copyright © 2016 Nicejinux. All rights reserved.
//

import UIKit


open class ToolBar: UIView {
    @objc open weak var undoButton: UIButton?
    @objc open weak var redoButton: UIButton?
//    @objc open weak var saveButton: UIButton?
//    @objc open weak var loadButton: UIButton?
    @objc open weak var clearButton: UIButton?
    
//    private weak var lineView: UIView?

    public struct Consts {
        public static let buttonHeight: CGFloat = UIScreen.main.bounds.width / 10.0
        public static let buttonPadding: CGFloat = UIScreen.main.bounds.width / 25.0
    }
    
    // MARK: - Initializer
    public init() {
        super.init(frame: CGRect.zero)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        self.setupViews()
        self.setupLayout()
    }
    
    
    // MARK: - LifeCycle Methods
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setupLayout()
    }
    

    // MARK: - Private Methods
    private func setupViews() {
        self.backgroundColor = UIColor(red: 239/255, green: 240/255, blue: 242/255, alpha: 1.0)
        
//        let lineView = UIView()
//        lineView.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
//        self.addSubview(lineView)
//        self.lineView = lineView
//        self.lineView?.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        
        var button: UIButton = self.button(iconName: "icon_clear")
        self.addSubview(button)
        self.clearButton = button
        
        button = self.button(iconName: "icon_undo")
        self.addSubview(button)
        self.undoButton = button
        
        button = self.button(iconName: "icon_redo")
        self.addSubview(button)
        self.redoButton = button
        
//        button = self.button("Save")
//        self.addSubview(button)
//        self.saveButton = button
        
//        button = self.button(iconName: "icon_camera")
//        self.addSubview(button)
//        self.loadButton = button
    }
    
    private func setupLayout() {
//        self.lineView?.frame = CGRect(x: 0, y: self.y - 1, width: self.width, height: 1)
        
        self.undoButton?.frame = CGRect(x: Consts.buttonPadding, y: 0, width: Consts.buttonHeight, height: Consts.buttonHeight)
        self.undoButton?.center = CGPoint(x: (self.undoButton?.center.x)!, y: Consts.buttonHeight / 2 + Consts.buttonPadding)

        self.redoButton?.frame = CGRect(x: (self.undoButton?.frame)!.maxX + Consts.buttonPadding, y: 0, width: Consts.buttonHeight, height: Consts.buttonHeight)
        self.redoButton?.center = CGPoint(x: (self.redoButton?.center.x)!, y: Consts.buttonHeight / 2 + Consts.buttonPadding)

//        self.saveButton?.frame = CGRect(x: self.width - (self.width * 0.1) - 15, y: 0, width: self.width * 0.1, height: self.width * 0.1)
//        self.saveButton?.center = CGPoint(x: (self.saveButton?.center.x)!, y: self.height / 2.0)

        self.clearButton?.frame = CGRect(x: Consts.buttonHeight * 5 + Consts.buttonPadding * 8, y: 0, width: Consts.buttonHeight, height: Consts.buttonHeight)
        self.clearButton?.center = CGPoint(x: (self.clearButton?.center.x)!, y: Consts.buttonHeight / 2 + Consts.buttonPadding)

//        self.loadButton?.frame = CGRect(x: 0, y: 0, width: self.width * 0.1, height: self.width * 0.1)
//        self.loadButton?.center = CGPoint(x: self.width / 2.0, y: self.height / 2.0)
    }
    
    private func button(_ title: String? = nil, iconName: String? = nil) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = Consts.buttonHeight / 2
        button.backgroundColor = UIColor.white
        
        if title != nil {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15 * self.multiflierForDevice())
            button.setTitle(title, for: UIControl.State())
            button.setTitleColor(UIColor.white, for: UIControl.State())
            button.setTitleColor(UIColor.gray, for: .disabled)
        }

        if iconName != nil {
            let podBundle = Bundle(for: self.classForCoder)
            if let bundleURL = podBundle.url(forResource: "NXDrawKit", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
                    let image = UIImage(named: iconName!, in: bundle, compatibleWith: nil)
                    button.setImage(image, for: UIControl.State())
                }
            }
        }
        
        button.isEnabled = false
        
        return button
    }
    
    private func multiflierForDevice() -> CGFloat {
        if UIScreen.main.bounds.size.width <= 320 {
            return 0.75
        } else if UIScreen.main.bounds.size.width > 375 {
            return 1.0
        } else {
            return 0.9
        }
    }
}
