//
//  CommentsPopUpView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/30.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit
import MJRefresh

class CommentsPopUpView: PopUpContentView {
    
    public var sourceId: String = ""
    
    fileprivate var keyboardH: CGFloat = 0
    
    public lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "0条评论"
        return label
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 50, width: Constant.screenWidth, height: height - 100 - Constant.barHeight), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    fileprivate lazy var commentInputView: PublicBottomInputView = {
        let view = PublicBottomInputView(frame: CGRect(x: 0, y: height - 50 - Constant.barHeight, width: Constant.screenWidth, height: 50))
        view.delegate = self
        return view
    }()
    
    fileprivate lazy var barView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: height - Constant.barHeight, width: Constant.screenWidth, height: Constant.barHeight))
        view.backgroundColor = .black
        return view
    }()
    
    fileprivate lazy var keyMaskView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 0))
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        return view
    }()
    
    fileprivate lazy var refreshFooter = MJRefreshBackNormalFooter()
    
    fileprivate lazy var page: Int = 1

    
    fileprivate var dataArray = [CommentListModel]()
    
    fileprivate var currentComment = CommentListModel()
    
    override func willShowView() {
        super.willShowView()
        addNotification()
        if dataArray.count == 0 {
            page = 1
            rquestCommentsList(page)
        }
    }
    
    override func didShwoView() {
        super.willShowView()
        App.keyWindow.addSubview(keyMaskView)
        keyMaskView.isUserInteractionEnabled = true
        let maskViewtap = UITapGestureRecognizer(target: self, action: #selector(keyMaskViewClick))
        keyMaskView.addGestureRecognizer(maskViewtap)
    }
    
    override func didCancelView() {
        super.didCancelView()
        keyMaskView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        viewController()?.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        commentInputView.removeObserver(self, forKeyPath: "frame")
    }
    
    public func removeData() {
        dataArray.removeAll()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        backgroundColor = UIColor.popUpColor_2F2F2F
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- layoutView
    fileprivate func layoutView() {
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15)
        }
        
        let cancleButton = UIButton()
        cancleButton.setImage(R.image.icon_fork(), for: .normal)
        cancleButton.addTarget(self, action: #selector(cancleButtonClick), for: .touchUpInside)
        cancleButton.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        addSubview(cancleButton)
        cancleButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.top.equalTo(15)
            make.right.equalToSuperview().offset(-15)
        }
        
        addSubview(tableView)
        tableView.register(CommentsReplyTableViewCell.self, forCellReuseIdentifier: CommentsReplyTableViewCell.identifire)
        tableView.register(CommentsReplyMoreTableViewCell.self, forCellReuseIdentifier: CommentsReplyMoreTableViewCell.identifire)
        refreshFooter = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(footerRefresh))
        refreshFooter.setTitle("没有更多数据了", for: .noMoreData)
        tableView.mj_footer = refreshFooter

        addSubview(commentInputView)
        commentInputView.addObserver(self, forKeyPath: "frame", options: [.new,.old], context: nil)
        addSubview(barView)
    }
    
    // MARK:- 点击评论
    fileprivate func commentClick(_ section: Int, clickType: CommentButtonClickType) {
        switch clickType {
        case .user: break
        case .conetnt:
            commentInputView.textView.becomeFirstResponder()
            let rect = tableView.rectForHeader(inSection: section)
            let y = rect.maxY + keyboardH - height + 100 + Constant.barHeight
            if y > 0 {
                tableView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            }
            currentComment.parentId = dataArray[section].id
            currentComment.originId = dataArray[section].id
            currentComment.currentIndex = IndexPath(row: -1, section: section)
            currentComment.parentUser = dataArray[section].submitUser
            currentComment.sourceType = 4
            commentInputView.textView.placeholder = "回复\(currentComment.parentUser.nickName)"
        case .praise:
            dataArray[section].isPraise == 0 ? (dataArray[section].isPraise = 1) : (dataArray[section].isPraise = 0)
            dataArray[section].isPraise == 0 ? (dataArray[section].praiseCount += 1) : (dataArray[section].praiseCount -= 1)

        }
    }
    
    // MARK: - 点击回复
    fileprivate func replyClick(_ index: IndexPath, clickType: CommentButtonClickType) {
        switch clickType {
        case .user:
            if let deleagte = UIApplication.shared.delegate as? AppDelegate {
                deleagte.loginView()
            }
        case .conetnt:
            commentInputView.textView.becomeFirstResponder()
            let rect = tableView.rectForRow(at: index)
            let y = rect.maxY + keyboardH - height + 100 + Constant.barHeight
            if y > 0 {
                tableView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
            }
            currentComment.parentId = dataArray[index.section].childrenList[index.row].id
            currentComment.originId = dataArray[index.section].id
            currentComment.currentIndex = index
            currentComment.sourceType = 4
            currentComment.parentUser = dataArray[index.section].childrenList[index.row].submitUser
            commentInputView.textView.placeholder = "回复\(currentComment.parentUser.nickName)"
        case .praise:
            dataArray[index.section].childrenList[index.row].isPraise == 0 ? (dataArray[index.section].childrenList[index.row].isPraise = 1) : (dataArray[index.section].childrenList[index.row].isPraise = 0)
            dataArray[index.section].childrenList[index.row].isPraise == 0 ? (dataArray[index.section].childrenList[index.row].praiseCount += 1) : (dataArray[index.section].childrenList[index.row].praiseCount -= 1)
        }
    }
    
    fileprivate func endRefreshingWithNoMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        }
    }
    
    // MARK:- Notification
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- Event
    @objc fileprivate func cancleButtonClick() {
//        PopUpViewManager.sharedInstance.cancalContentView(self)
        self.viewController()?.navigationController?.pushViewController(MineViewController(), animated: true)

    }
    
    @objc fileprivate func keyMaskViewClick() {
        endEditing(true)
    }
    
    // 上拉加载
    @objc fileprivate func footerRefresh() {
        page += 1
        rquestCommentsList(page)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        DispatchQueue.main.async {
            let userInfo = notification.userInfo
            let duration: Double = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
            let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            self.keyboardH = keyboardFrame?.cgRectValue.height ?? 0
            UIView.animate(withDuration: duration, animations: {
                self.commentInputView.y = self.height - self.commentInputView.height - (keyboardFrame?.cgRectValue.height ?? 0)
                self.keyMaskView.height = Constant.screenHeight - self.keyboardH - self.commentInputView.height
            })
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            let userInfo = notification.userInfo
            let duration: Double = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
            self.keyboardH = 0
            self.commentInputView.textView.placeholder = "写句神评论"
            UIView.animate(withDuration: duration, animations: {
                self.commentInputView.y = self.height - 50 - Constant.barHeight
                self.keyMaskView.height = 0
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            tableView.height = commentInputView.y - 50
        }
    }
    
    // MARK:- request
    // 评论列表
    func rquestCommentsList(_ page: Int) {
        var params: Dictionary = [String: Any]()
        MBAlertUtil.alertManager.showLoadingMessage(in: tableView)
        params.updateValue(sourceId, forKey: "sourceId")
        params.updateValue("1", forKey: "sourceType")
        params.updateValue(page, forKey: "pageNo")
        params.updateValue("10", forKey: "pageSize")

        Network.default.request(CommonTargetTypeApi.getRequest(CommentsRequest.list, params), successClosure: { (response) in
            if page == 1 { self.dataArray.removeAll() }
            MBAlertUtil.alertManager.hiddenLoading()
            if let array = [CommentListModel].deserialize(from: response.arrayObject) as? [CommentListModel] {
                self.dataArray += array
                if array.count < 10 { self.endRefreshingWithNoMoreData() }
            }
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    // 回复列表
    func requestCommentsReplyList(_ index: IndexPath) {
        MBAlertUtil.alertManager.showLoadingMessage(in: tableView)
        var params: Dictionary = [String: Any]()
        params.updateValue(dataArray[index.section].id, forKey: "id")
        params.updateValue(dataArray[index.section].childrenPage, forKey: "pageNo")
        params.updateValue("10", forKey: "pageSize")
        Network.default.request(CommonTargetTypeApi.getRequest(CommentsRequest.replyList, params), successClosure: { (response) in
            MBAlertUtil.alertManager.hiddenLoading()
            if let array = [CommentListModel].deserialize(from: response.arrayObject) as? [CommentListModel] {
                if self.dataArray[index.section].childrenPage == 1 {
                    self.dataArray[index.section].childrenList = array
                }else {
                    self.dataArray[index.section].childrenList += array
                }
                self.dataArray[index.section].childrenPage += 1
            }
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    // 提交评论回复
    fileprivate func requestCommentsSubmit() {
        var params: Dictionary = [String: Any]()
        params.updateValue(sourceId, forKey: "sourceId")
        params.updateValue(currentComment.sourceType, forKey: "sourceType")
        params.updateValue(currentComment.content, forKey: "content")
        if !currentComment.originId.isEmpty {
            params.updateValue(currentComment.originId, forKey: "originId")
        }
        if !currentComment.parentId.isEmpty {
            params.updateValue(currentComment.parentId, forKey: "parentId")
        }
        Network.default.request(CommonTargetTypeApi.postRequest(CommentsRequest.submit, params,.query), successClosure: { (response) in
            self.endEditing(true)
            MBAlertUtil.alertManager.showPromptInfo("评论成功", in: self)
            guard let model = CommentListModel.deserialize(from: response.dictionaryObject) else { return }
            if model.parentId.isEmpty {
                self.page = 1
                self.rquestCommentsList(self.page)
            }else {
                self.dataArray[self.currentComment.currentIndex.section].childrenList.append(model)
                self.tableView.reloadData()
            }
            self.currentComment = CommentListModel()
            self.currentComment.sourceType = 1
            self.commentInputView.textView.text = ""
            self.commentInputView.textView.placeholder = "写句神评论吧"
        }) { (error) in
            
        }
    }
}


extension CommentsPopUpView: UITableViewDelegate, UITableViewDataSource, PublicInputDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataArray[section].childrenList.count < dataArray[section].commentCount) ? (dataArray[section].childrenList.count + 1) : dataArray[section].childrenList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArray[indexPath.section].childrenList.count < dataArray[indexPath.section].commentCount && indexPath.row == dataArray[indexPath.section].childrenList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentsReplyMoreTableViewCell.identifire) as! CommentsReplyMoreTableViewCell
            cell.numberLabel.text = "展开更多回复（\(dataArray[indexPath.section].commentCount - dataArray[indexPath.section].childrenList.count)）"
            return cell
        }
        let cell: CommentsReplyTableViewCell = tableView.dequeueReusableCell(withIdentifier: CommentsReplyTableViewCell.identifire) as! CommentsReplyTableViewCell
        cell.model = dataArray[indexPath.section].childrenList[indexPath.row]
        cell.commentClick = { [weak self] type in
            self?.replyClick(indexPath, clickType: type)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataArray[section].contentHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CommentsHeaderView()
        headerView.model = dataArray[section]
        headerView.commentClick = { [weak self] type in
            self?.commentClick(section, clickType: type)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataArray[indexPath.section].childrenList.count < dataArray[indexPath.section].commentCount && indexPath.row == dataArray[indexPath.section].childrenList.count {
            requestCommentsReplyList(indexPath)
        }else {
            self.viewController()?.navigationController?.pushViewController(MineViewController(), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
    }
    
    func publicInputView(_ inputView: PublicBottomInputView, sendText text: String) {
        currentComment.content = text
        requestCommentsSubmit()
    }
    
    func publicInputView(_ inputView: PublicBottomInputView, textChange text: String, height: CGFloat) {
        
    }
}
    

