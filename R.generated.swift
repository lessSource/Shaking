//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 10 files.
  struct file {
    /// Resource file `icon_album_nor@2x.png`.
    static let icon_album_nor2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_album_nor@2x", pathExtension: "png")
    /// Resource file `icon_album_sel@2x.png`.
    static let icon_album_sel2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_album_sel@2x", pathExtension: "png")
    /// Resource file `icon_close@2x.png`.
    static let icon_close2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_close@2x", pathExtension: "png")
    /// Resource file `icon_nav_back@2x.png`.
    static let icon_nav_back2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_nav_back@2x", pathExtension: "png")
    /// Resource file `icon_permissions@2x.png`.
    static let icon_permissions2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_permissions@2x", pathExtension: "png")
    /// Resource file `icon_permissions@3x.png`.
    static let icon_permissions3xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_permissions@3x", pathExtension: "png")
    /// Resource file `icon_video@2x.png`.
    static let icon_video2xPng = Rswift.FileResource(bundle: R.hostingBundle, name: "icon_video@2x", pathExtension: "png")
    /// Resource file `provincesData.json`.
    static let provincesDataJson = Rswift.FileResource(bundle: R.hostingBundle, name: "provincesData", pathExtension: "json")
    /// Resource file `schoolData.json`.
    static let schoolDataJson = Rswift.FileResource(bundle: R.hostingBundle, name: "schoolData", pathExtension: "json")
    /// Resource file `抖腿短视频.md`.
    static let 抖腿短视频Md = Rswift.FileResource(bundle: R.hostingBundle, name: "抖腿短视频", pathExtension: "md")
    
    /// `bundle.url(forResource: "icon_album_nor@2x", withExtension: "png")`
    static func icon_album_nor2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_album_nor2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icon_album_sel@2x", withExtension: "png")`
    static func icon_album_sel2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_album_sel2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icon_close@2x", withExtension: "png")`
    static func icon_close2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_close2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icon_nav_back@2x", withExtension: "png")`
    static func icon_nav_back2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_nav_back2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icon_permissions@2x", withExtension: "png")`
    static func icon_permissions2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_permissions2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icon_permissions@3x", withExtension: "png")`
    static func icon_permissions3xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_permissions3xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "icon_video@2x", withExtension: "png")`
    static func icon_video2xPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.icon_video2xPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "provincesData", withExtension: "json")`
    static func provincesDataJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.provincesDataJson
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "schoolData", withExtension: "json")`
    static func schoolDataJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.schoolDataJson
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "抖腿短视频", withExtension: "md")`
    static func 抖腿短视频Md(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.抖腿短视频Md
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 29 images.
  struct image {
    /// Image `IMG_4A7DFD335A96-1`.
    static let img_4A7DFD335A961 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_4A7DFD335A96-1")
    /// Image `icon_VideoDel`.
    static let icon_VideoDel = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_VideoDel")
    /// Image `icon_album_nor`.
    static let icon_album_nor = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_album_nor")
    /// Image `icon_album_sel`.
    static let icon_album_sel = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_album_sel")
    /// Image `icon_beautify`.
    static let icon_beautify = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_beautify")
    /// Image `icon_btn_add`.
    static let icon_btn_add = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_btn_add")
    /// Image `icon_camera`.
    static let icon_camera = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_camera")
    /// Image `icon_close`.
    static let icon_close = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_close")
    /// Image `icon_comments`.
    static let icon_comments = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_comments")
    /// Image `icon_countdown`.
    static let icon_countdown = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_countdown")
    /// Image `icon_expression`.
    static let icon_expression = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_expression")
    /// Image `icon_filter`.
    static let icon_filter = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_filter")
    /// Image `icon_flip`.
    static let icon_flip = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_flip")
    /// Image `icon_fork`.
    static let icon_fork = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_fork")
    /// Image `icon_giveLike_click`.
    static let icon_giveLike_click = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_giveLike_click")
    /// Image `icon_giveLike`.
    static let icon_giveLike = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_giveLike")
    /// Image `icon_more`.
    static let icon_more = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_more")
    /// Image `icon_music1`.
    static let icon_music1 = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_music1")
    /// Image `icon_music`.
    static let icon_music = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_music")
    /// Image `icon_nav_back`.
    static let icon_nav_back = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_nav_back")
    /// Image `icon_notes`.
    static let icon_notes = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_notes")
    /// Image `icon_permissions`.
    static let icon_permissions = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_permissions")
    /// Image `icon_pic_cancle`.
    static let icon_pic_cancle = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_pic_cancle")
    /// Image `icon_props`.
    static let icon_props = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_props")
    /// Image `icon_search`.
    static let icon_search = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_search")
    /// Image `icon_share`.
    static let icon_share = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_share")
    /// Image `icon_speed`.
    static let icon_speed = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_speed")
    /// Image `icon_tailoring`.
    static let icon_tailoring = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_tailoring")
    /// Image `icon_video`.
    static let icon_video = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_video")
    
    /// `UIImage(named: "IMG_4A7DFD335A96-1", bundle: ..., traitCollection: ...)`
    static func img_4A7DFD335A961(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_4A7DFD335A961, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_VideoDel", bundle: ..., traitCollection: ...)`
    static func icon_VideoDel(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_VideoDel, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_album_nor", bundle: ..., traitCollection: ...)`
    static func icon_album_nor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_album_nor, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_album_sel", bundle: ..., traitCollection: ...)`
    static func icon_album_sel(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_album_sel, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_beautify", bundle: ..., traitCollection: ...)`
    static func icon_beautify(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_beautify, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_btn_add", bundle: ..., traitCollection: ...)`
    static func icon_btn_add(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_btn_add, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_camera", bundle: ..., traitCollection: ...)`
    static func icon_camera(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_camera, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_close", bundle: ..., traitCollection: ...)`
    static func icon_close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_comments", bundle: ..., traitCollection: ...)`
    static func icon_comments(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_comments, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_countdown", bundle: ..., traitCollection: ...)`
    static func icon_countdown(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_countdown, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_expression", bundle: ..., traitCollection: ...)`
    static func icon_expression(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_expression, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_filter", bundle: ..., traitCollection: ...)`
    static func icon_filter(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_filter, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_flip", bundle: ..., traitCollection: ...)`
    static func icon_flip(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_flip, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_fork", bundle: ..., traitCollection: ...)`
    static func icon_fork(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_fork, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_giveLike", bundle: ..., traitCollection: ...)`
    static func icon_giveLike(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_giveLike, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_giveLike_click", bundle: ..., traitCollection: ...)`
    static func icon_giveLike_click(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_giveLike_click, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_more", bundle: ..., traitCollection: ...)`
    static func icon_more(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_more, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_music", bundle: ..., traitCollection: ...)`
    static func icon_music(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_music, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_music1", bundle: ..., traitCollection: ...)`
    static func icon_music1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_music1, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_nav_back", bundle: ..., traitCollection: ...)`
    static func icon_nav_back(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_nav_back, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_notes", bundle: ..., traitCollection: ...)`
    static func icon_notes(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_notes, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_permissions", bundle: ..., traitCollection: ...)`
    static func icon_permissions(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_permissions, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_pic_cancle", bundle: ..., traitCollection: ...)`
    static func icon_pic_cancle(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_pic_cancle, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_props", bundle: ..., traitCollection: ...)`
    static func icon_props(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_props, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_search", bundle: ..., traitCollection: ...)`
    static func icon_search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_search, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_share", bundle: ..., traitCollection: ...)`
    static func icon_share(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_share, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_speed", bundle: ..., traitCollection: ...)`
    static func icon_speed(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_speed, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_tailoring", bundle: ..., traitCollection: ...)`
    static func icon_tailoring(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_tailoring, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_video", bundle: ..., traitCollection: ...)`
    static func icon_video(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_video, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
