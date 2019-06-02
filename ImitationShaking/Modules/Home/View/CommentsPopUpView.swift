//
//  CommentsPopUpView.swift
//  ImitationShaking
//
//  Created by Lj on 2019/5/30.
//  Copyright © 2019 study. All rights reserved.
//

import UIKit

class CommentsPopUpView: PopUpContentView {
    
    fileprivate var keyboardH: CGFloat = 0
    
    fileprivate lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "333条评论"
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
        tableView.contentInsetAdjustmentBehavior = .never
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
    
    fileprivate var dataArray = [CommentListModel]()
    
    override func willShowView() {
        super.willShowView()
        addNotification()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifire)

        addSubview(commentInputView)
        addSubview(barView)
        rquestCommentsList()
    }
    
    // MARK:-
    fileprivate func replyComment(_ section: Int, isUser: Bool) {
        if isUser {
            print("点击头像")
            return
        }
        commentInputView.textView.becomeFirstResponder()
        let rect = tableView.rectForHeader(inSection: section)
        let y = rect.maxY + keyboardH - height + 100 + Constant.barHeight
        if y > 0 {
            tableView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
    }
    
    
    // MARK:- Notification
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:- Event
    @objc fileprivate func cancleButtonClick() {
        PopUpViewManager.sharedInstance.cancalContentView(self)
    }
    
    @objc fileprivate func keyMaskViewClick() {
        endEditing(true)
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
                self.tableView.height = self.height - 50 - Constant.barHeight - self.keyboardH
            })
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            let userInfo = notification.userInfo
            let duration: Double = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
            self.keyboardH = 0
            UIView.animate(withDuration: duration, animations: {
                self.commentInputView.y = self.height - 50 - Constant.barHeight
                self.keyMaskView.height = 0
                self.tableView.height = self.height - 100 - Constant.barHeight
            })
        }
    }
    
    // MARK:- request
    // 评论列表
    func rquestCommentsList() {
        var params: Dictionary = [String: Any]()
        params.updateValue("1", forKey: "sourceId")
        params.updateValue("1", forKey: "sourceType")
        params.updateValue("1", forKey: "pageNo")
        params.updateValue("10", forKey: "pageSize")

        Network.default.request(CommonTargetTypeApi.getRequest(RquestCommentsList, params), successClosure: { (response) in
            if let array = [CommentListModel].deserialize(from: response.arrayObject) as? [CommentListModel] {
                self.dataArray = array
            }
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    func requestCommentsReplyList() {
        var params: Dictionary = [String: Any]()
        params.updateValue(dataArray[0].id, forKey: "id")
        params.updateValue("1", forKey: "pageNo")
        params.updateValue("10", forKey: "pageSize")
        Network.default.request(CommonTargetTypeApi.getRequest(RequestCommentsReplyList, params), successClosure: { (response) in
            if let array = [CommentListModel].deserialize(from: response.arrayObject) as? [CommentListModel] {
                self.dataArray[0].childrenList += array
            }
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    // 提交评论回复
    fileprivate func requestCommentsSubmit(_ content: String) {
        var params: Dictionary = [String: Any]()
        params.updateValue("1", forKey: "sourceId")
        params.updateValue("4", forKey: "sourceType")
        params.updateValue(content, forKey: "content")
        params.updateValue(dataArray[0].childrenList[0].id, forKey: "parentId")
        params.updateValue(dataArray[0].id, forKey: "originId")

        Network.default.request(CommonTargetTypeApi.postRequest(RequestCommentsSubmit, params), successClosure: { (response) in
            self.endEditing(true)
            self.rquestCommentsList()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifire)
            cell?.textLabel?.text = "查看更多评论\(dataArray[indexPath.section].commentCount)"
            return cell!
        }
        let cell: CommentsReplyTableViewCell = tableView.dequeueReusableCell(withIdentifier: CommentsReplyTableViewCell.identifire) as! CommentsReplyTableViewCell
        cell.model = dataArray[indexPath.section].childrenList[indexPath.row]
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
        headerView.commentClick = { [weak self] isUser in
            self?.replyComment(section, isUser: isUser)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestCommentsReplyList()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
    }
    
    func publicInputView(_ inputView: PublicBottomInputView, sendText text: String) {
        requestCommentsSubmit(text)
    }
    
    func publicInputView(_ inputView: PublicBottomInputView, textChange text: String, height: CGFloat) {
        
    }
}
    

