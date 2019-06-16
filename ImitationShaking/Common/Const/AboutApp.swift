//
//  AboutApp.swift
//  NotesStudy
//
//  Created by Lj on 2018/2/27.
//  Copyright © 2018年 lj. All rights reserved.
//

import UIKit
import AdSupport

public struct App {
    
    private static var info: Dictionary<String, Any> {
        return Bundle.main.infoDictionary ?? [String: Any]()
    }
    
    /** 名称 */
    public static var appName: String {
        return info["CFBundleDisplayName"] as? String ?? ""
    }
    
    /** 版本 */
    public static var appVersion: String {
        return info["CFBundleShortVersionString"] as? String ?? ""
    }
    
    /** build */
    public static var appBuild: String {
        return info["kCFBundleVersionKey"] as? String ?? ""
    }
    
    /** bundle id */
    public static var bundleIdentifier: String {
        return info["CFBundleIdentifier"] as? String ?? ""
    }
    
    /** bundel Name */
    public static var bundelName: String {
        return info["CFBundleName"] as? String ?? ""
    }
    
    /** appStore地址 */
    public static var appStoreURL: String {
        return "https://itunes.apple.com/cn/app//id1455050254?mt=8"
    }
    
    public static var documentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    }
    
    /** IDFA */
    public static var IDFA: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    /** IDFV */
    public static var IDFV: String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /** keyWindow */
    public static var keyWindow: UIView {
        return UIApplication.shared.keyWindow ?? UIView()
    }
    
    public static var rootView: UIView {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.window?.rootViewController?.view ?? UIView()
        }
        return keyWindow
    }
}


