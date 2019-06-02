//
//  SwiftNetworkManager.swift
//  ImitationShaking
//
//  Created by study on 2019/6/1.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import SwiftyJSON
import RxSwift
import RxCocoa
import HandyJSON
import PromiseKit

public final class Network {
    
    // NetWork 单利对象
    public static let `default` = Network()
    
    // Mayo provider 类实例 Network.provider.rx.request() 或 Network.provider.request()
    public static let provider = MoyaProvider<MultiTarget>(requestClosure: Network.requestMapping, plugins: [Network.loggerPlugin, Network.activityPlugin, Network.reloginPlugin])

    // NetworkLoggerPlugin
    private static var loggerPlugin: NetworkLoggerPlugin = {
        #if DEBUG
        return NetworkLoggerPlugin(verbose: true)
        #else
        return NetworkLoggerPlugin(verbose: false)
        #endif
    }()
    
    /// NetworkActivityPlugin
    private static var activityPlugin: NetworkActivityPlugin = {
        return NetworkActivityPlugin { (changeType, target) in
            switch changeType {
            case .began:
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended:
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }()
    
    private static var reloginPlugin: ReLoginPlugin = ReLoginPlugin()

    /// requestClosure
    private static var requestMapping: (Endpoint, MoyaProvider.RequestResultClosure) -> Void = { (endpoint, closure) in
        do {
            var urlRequest = try endpoint.urlRequest()
            //            let param = urlRequest.
            urlRequest.timeoutInterval = 35  // 超时时间
            closure(.success(urlRequest))
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    fileprivate let dispose = DisposeBag()

    /// 请求 JSON (SwiftyJSON) 格式数据
    ///
    /// - Parameters:
    ///   - target: TargetType
    ///   - success: 成功返回 JSON
    ///   - failure: 失败返回 Error
    public func request(_ target: TargetType, successClosure: @escaping (JSON) -> Void, failureClosure: @escaping (Error) -> Void) {
        Network.provider.rx.request(MultiTarget(target))
            .mapJSON()
            .subscribe { (event) in
                switch event {
                case let .success(response):
                    let json = JSON(response)
                    let appCode = json["code"].stringValue
                    if appCode == RelustCode.success.rawValue {
                        successClosure(json["data"])
                    }
                case let .error(_): break
                }
            }
            .disposed(by: dispose)
    }
    
    
    /// 发送带进度条的请求
    ///
    /// - Parameters:
    ///   - target: TargetType
    ///   - progress: 进度条回调
    ///   - success: 成功回调
    ///   - failure: 失败回调
    public func requestProgress(_ target: TargetType, progressClosure: ((Double) -> Void)? = .none, successClosure: @escaping (JSON) -> Void, failureClosure: @escaping (Error) -> Void) {
        
        let resObserver = Network.provider.rx.requestWithProgress(MultiTarget(target))
        resObserver.subscribe { (event) in
            switch event {
            case let .next(proRes):
                if let response = proRes.response {
                    do {
                        let data = try response.mapJSON()
                        let json = JSON(data)
                        if json["code"] == 200 {
                            successClosure(json)
                        }
                        else {
                            failureClosure(FLError.responseCodeNot200(json["code"].stringValue, json["msg"].stringValue))
                        }
                    }
                    catch let err {
                        failureClosure(err)
                    }
                }
                else {
                    progressClosure?(proRes.progress)
                }
                break
            case let .error(err):
                failureClosure(err)
                break
            case .completed:
                progressClosure?(1.0)
                break
            }
            }.disposed(by: dispose)
    }
    
    
    // MARK: PromiseKit
    
    /// 发送请求，返回 Promise<JSON>
    ///
    /// - Parameter target: api target
    /// - Returns: Promise<JSON>
    public func request(_ target: TargetType) -> Promise<JSON> {
        return Promise { seal in
            Network.provider.rx.request(MultiTarget(target))
                .mapJSON()
                .subscribe(onSuccess: { (data) in
                    let json = JSON(data)
                    if json["code"] == "200" {
                        seal.fulfill(json)
                    }
                    else {
                        seal.reject(FLError.responseCodeNot200(json["code"].stringValue, json["msg"].stringValue))
                    }
                }, onError: { (err) in
                    seal.reject(err)
                })
                .disposed(by: dispose)
        }
    }

}

extension Network {
    
    
    /// 通用 get 请求
    ///
    /// - Parameters:
    ///   - urlPath: url的path
    ///   - parameters: 参数
    ///   - successClosure: 成功回调
    ///   - failureClosure: 失败回调
    public func get(_ urlPath: String, parameters: [String: Any]? = nil, successClosure: @escaping (JSON) -> Void, failureClosure: @escaping (Error) -> Void) -> Void {
        Network.default.request(CommonTargetTypeApi.getRequest(urlPath, parameters), successClosure: successClosure, failureClosure: failureClosure)
    }
    
    /// 通用 post 请求
    ///
    /// - Parameters:
    ///   - urlPath: url的path
    ///   - parameters: 参数
    ///   - successClosure: 成功回调
    ///   - failureClosure: 失败回调
    public func post(_ urlPath: String, parameters: [String: Any]? = nil, successClosure: @escaping (JSON) -> Void, failureClosure: @escaping (Error) -> Void) -> Void {
        Network.default.request(CommonTargetTypeApi.postRequest(urlPath, parameters), successClosure: successClosure, failureClosure: failureClosure)
    }
    
    // MARK: PromiseKit 方式
    //    demo：
    //    Network.default.get("homelist")
    //    .done { (json) in
    //        debugPrint(json)
    //    }.catch { (err) in
    //        debugPrint(err.localizedDescription)
    //    }
    //
    //    Network.default.get("homelist")
    //        .compactMap { (json) -> HomeRecommendBaseModel? in
    //            return HomeRecommendBaseModel.deserialize(from: json.dictionaryObject)
    //        }.done { (model) in
    //            // to do
    //        }.catch { (err) in
    //            // err
    //    }
    /// 发送GET请求，返回Promise对象
    ///
    /// - Parameters:
    ///   - urlPath: url path
    ///   - parameters: 参数
    /// - Returns: Promise<JSON>
    public func get(_ urlPath: String, parameters: [String: Any]? = nil) -> Promise<JSON> {
        return Promise { seal in
            Network.default.request(CommonTargetTypeApi.getRequest(urlPath, parameters), successClosure: { (json) in
                seal.fulfill(json)
            }, failureClosure: { (err) in
                seal.reject(err)
            })
        }
    }
    
    /// 发送POST请求，返回Promise对象
    ///
    /// - Parameters:
    ///   - urlPath: url path
    ///   - parameters: 参数
    /// - Returns: Promise<JSON>
    public func post(_ urlPath: String, parameters: [String: Any]? = nil) -> Promise<JSON> {
        return Promise { seal in
            Network.default.request(CommonTargetTypeApi.postRequest(urlPath, parameters), successClosure: { (json) in
                seal.fulfill(json)
            }, failureClosure: { (err) in
                seal.reject(err)
            })
        }
    }
}
