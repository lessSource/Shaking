//
//  MoyaNetworkConfig.swift
//  ImitationShaking
//
//  Created by study on 2019/6/1.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Moya
import Result
import SwiftyJSON

enum RelustCode: String {
    case success = "0"
}


// 五条 Error
///
/// - mapHandyJSON: response 转 HandyJSON 失败
/// - responseCodeNot200: response 返回状态码不为 200   (code, msg)
enum FLError {
    case mapHandyJSON
    case responseCodeNot200(String, String)
}

extension FLError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .mapHandyJSON:
            return "json 转 HandyJSON 协议对象失败"
        case .responseCodeNot200(_, let errMsg):
            return "接口调用失败，Error：\(errMsg)"
        }
    }
}

public class ReLoginPlugin: PluginType {
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success( _):
            //            let json = JSON(res.data)
            //            let code = json["code"].intValue
            //            let errmsg = json["msg"].string
            
            // error code 800n 998 need repeat login
            break
        default: break
        }
    }
}

