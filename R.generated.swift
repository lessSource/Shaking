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
  
  /// This `R.image` struct is generated, and contains static references to 9 images.
  struct image {
    /// Image `IMG_4A7DFD335A96-1`.
    static let img_4A7DFD335A961 = Rswift.ImageResource(bundle: R.hostingBundle, name: "IMG_4A7DFD335A96-1")
    /// Image `icon_camera`.
    static let icon_camera = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_camera")
    /// Image `icon_comments`.
    static let icon_comments = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_comments")
    /// Image `icon_fork`.
    static let icon_fork = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_fork")
    /// Image `icon_giveLike`.
    static let icon_giveLike = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_giveLike")
    /// Image `icon_notes`.
    static let icon_notes = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_notes")
    /// Image `icon_search`.
    static let icon_search = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_search")
    /// Image `icon_shar`.
    static let icon_shar = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_shar")
    /// Image `icon_share`.
    static let icon_share = Rswift.ImageResource(bundle: R.hostingBundle, name: "icon_share")
    
    /// `UIImage(named: "IMG_4A7DFD335A96-1", bundle: ..., traitCollection: ...)`
    static func img_4A7DFD335A961(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.img_4A7DFD335A961, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_camera", bundle: ..., traitCollection: ...)`
    static func icon_camera(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_camera, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_comments", bundle: ..., traitCollection: ...)`
    static func icon_comments(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_comments, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_fork", bundle: ..., traitCollection: ...)`
    static func icon_fork(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_fork, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_giveLike", bundle: ..., traitCollection: ...)`
    static func icon_giveLike(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_giveLike, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_notes", bundle: ..., traitCollection: ...)`
    static func icon_notes(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_notes, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_search", bundle: ..., traitCollection: ...)`
    static func icon_search(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_search, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_shar", bundle: ..., traitCollection: ...)`
    static func icon_shar(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_shar, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "icon_share", bundle: ..., traitCollection: ...)`
    static func icon_share(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.icon_share, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `TestTableViewCell`.
    static let testTableViewCell = _R.nib._TestTableViewCell()
    
    /// `UINib(name: "TestTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.testTableViewCell) instead")
    static func testTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.testTableViewCell)
    }
    
    static func testTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> TestTableViewCell? {
      return R.nib.testTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TestTableViewCell
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
  
  struct nib {
    struct _TestTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "TestTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> TestTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TestTableViewCell
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
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
