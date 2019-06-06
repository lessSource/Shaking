//
//  UserCacheModel.swift
//  ImitationShaking
//
//  Created by less on 2019/6/6.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

final class LCacheModel: NSObject, NSCoding {
    
    static let shareInstance = LCacheModel()
    
    private override init() {
        super.init()
    }
    
    fileprivate var userModel = UserCacheModel()
    
    fileprivate func getPath() -> String {
        let pathArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let path = pathArray[0]
        let disPath = "\(path)/CacheData.data"
        return disPath
    }
    
    public func save(_ userModel: UserCacheModel = UserCacheModel()) {
        self.userModel = userModel
        NSKeyedArchiver.archiveRootObject(userModel, toFile: getPath())
    }
    
    public func reset() {
        save()
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: getPath())
        } catch  {
            print("移除失败")
        }
    }
    
    public func getData() -> UserCacheModel {
        guard let model = NSKeyedUnarchiver.unarchiveObject(withFile: getPath()) as? UserCacheModel else {
            return UserCacheModel()
        }
         return model
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userModel, forKey: "userModel")
    }
    
    init?(coder aDecoder: NSCoder) {
        super.init()
        guard let model = aDecoder.decodeObject(forKey: "userModel") as? UserCacheModel else {
            return
        }
        userModel = model
    }
    
}




class UserCacheModel: NSObject, HandyJSON, NSCoding {

    /** 用户token */
    var token: String = ""
    /** 用户信息 */
    var user: PublicUserClass = PublicUserClass()
    
    required override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        user = aDecoder.decodeObject(forKey: "user") as? PublicUserClass ?? PublicUserClass()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
        aCoder.encode(user, forKey: "user")
    }
}


class PublicUserClass: NSObject, HandyJSON, NSCoding {
    /** 用户ID */
    var id: String = ""
    /** 用户头像 */
    var headImg: String = ""
    /** 用户昵称 */
    var nickName: String = ""
    /** 用户性别 */
    var sex: String = ""
    /** 生日 */
    var birthday: String = ""
    /** 地区 */
    var region: String = ""
    /** 介绍 */
    var introduction: String = ""
    /** 抖腿号 */
    var shakelegsName: String = ""
    /** 是否关注 */
    var isFollewed: Int = 0
    
    required override init() { }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String ?? ""
        headImg = aDecoder.decodeObject(forKey: "headImg") as? String ?? ""
        nickName = aDecoder.decodeObject(forKey: "nickName") as? String ?? ""
        sex = aDecoder.decodeObject(forKey: "sex") as? String ?? ""
        birthday = aDecoder.decodeObject(forKey: "birthday") as? String ?? ""
        region = aDecoder.decodeObject(forKey: "region") as? String ?? ""
        introduction = aDecoder.decodeObject(forKey: "introduction") as? String ?? ""
        shakelegsName = aDecoder.decodeObject(forKey: "shakelegsName") as? String ?? ""
        isFollewed = aDecoder.decodeObject(forKey: "isFollewed") as? Int ?? 0

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(headImg, forKey: "headImg")
        aCoder.encode(nickName, forKey: "nickName")
        aCoder.encode(sex, forKey: "sex")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(region, forKey: "region")
        aCoder.encode(introduction, forKey: "introduction")
        aCoder.encode(shakelegsName, forKey: "shakelegsName")
        aCoder.encode(isFollewed, forKey: "isFollewed")
    }
}
