//
//  MoyaTargetTypeEx.swift
//  ImitationShaking
//
//  Created by Lj on 2019/6/1.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import SwiftyJSON

public enum ParametersPositionType {
    case body
    case query
}


/// 通用请求TargetType
///
/// - getRequest: get请求   urlPath   Parameters
/// - postRequest: post请求   urlPath   Parameters
/// - delegateRequest: delete请求   urlPath   Parameters
/// - putRequest: delete请求   urlPath   Parameters
/// - uploadMultipart: 上传Multipart请求   urlPath   MultipartFormData
/// - uploadFile: 上传请求   urlPath   上传文件路径
/// - download: 下载请求   urlPath   下载完成后保存
/// - downloadWithParams: 带有参数的下载请求   urlPath   Parameters   下载完成后保存

enum CommonTargetTypeApi {
    case getRequest(String, [String: Any]?)
    case postRequest(String, [String: Any]?, ParametersPositionType)
    case deleteRequest(String, [String: Any]?)
    case putRequest(String, [String: Any]?)
    case uploadMultipart(String, [Moya.MultipartFormData], [String: Any]?)
    case uploadFile(String, URL)
    case download(String, Moya.DownloadDestination)
    case downloadWithParams(String, [String: Any], Moya.DownloadDestination)
}


extension CommonTargetTypeApi: TargetType {
    
    var baseURL: URL {
        let baseUrlStr : String = "http://47.93.30.220/"
        return URL.init(string: baseUrlStr)!
    }
    
    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    var path: String {
        switch self {
        case .getRequest(let urlPath, _):
            return urlPath
        case .postRequest(let urlPath, _, _):
            return urlPath
        case .deleteRequest(let urlPath, _):
            return urlPath
        case .putRequest(let urlPath, _):
            return urlPath
        case .uploadMultipart(let urlPath, _, _):
            return urlPath
        case .uploadFile(let urlPath, _):
            return urlPath
        case .download(let urlPath, _):
            return urlPath
        case .downloadWithParams(let urlPath, _, _):
            return urlPath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRequest(_, _):
            return .get
        case .postRequest(_, _, _):
            return .post
        case .deleteRequest(_, _):
            return .delete
        case .putRequest(_, _):
            return .put
        case .uploadMultipart(_, _, _):
            return .post
        case .uploadFile(_, _):
            return .post
        case .download(_, _):
            return .get
        case .downloadWithParams(_, _, _):
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getRequest(_, let param):
            if let param = param {
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            }
            return .requestPlain
        case .postRequest(_, let param, let requestWay):
            if let param = param {
                if requestWay == .body {
                    let jsonData = jsonToData(json: param)
                    return .requestData(jsonData!)
                }else {
                    return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
                }
            }
            return .requestPlain
        case .deleteRequest(_, let param):
            if let param = param {
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            }
            return .requestPlain
        case .putRequest(_, let param):
            if let param = param {
                return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            }
            return .requestPlain
        case .uploadMultipart(_, let datas, let param):
            if param?.isEmpty == true {
                return .uploadMultipart(datas)
            }
            return .uploadCompositeMultipart(datas, urlParameters: param!)
        case .uploadFile(_, let fileURL):
            return .uploadFile(fileURL)
        case .download(_, let destination):
            return .downloadDestination(destination)
        case .downloadWithParams(_, let params, let destination):
            return .downloadParameters(parameters: params, encoding: URLEncoding.default, destination: destination)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .uploadMultipart(_, _, _):
            return ["Content-type": "multipart/form-data","Auth-Token": LCacheModel.shareInstance.getData().token]
        default:
            return ["Content-Type": "application/json","Auth-Token": LCacheModel.shareInstance.getData().token]
        }
    }
    
    // json转data
    private func jsonToData(json: Any) -> Data? {
        if !JSONSerialization.isValidJSONObject(json) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            print("is not a valid json object")
            return nil
        }
        // Data转换成String打印输出
        let str = String(data: data , encoding: String.Encoding.utf8)
        // 输出json字符串
        print("Json Str:\(str ?? "")")
        return data
    }
}
