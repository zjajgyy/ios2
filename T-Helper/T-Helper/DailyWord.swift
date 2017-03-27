//
//  DailyWord.swift
//  T-Helper
//
//  Created by 李鹏翔 on 2016/12/1.
//  Copyright © 2016年 thelper. All rights reserved.
//

import Foundation
import NotificationCenter
import UIKit

class DailyWord: NSObject {
    
    static let host = "http://bdxst.bjtu.edu.cn:8888/t-helper"
    
    var id: Int?
    var title: String?
    var desc: String?
    var imgUrl: String?
    var coverImgUrl: String?
    var author: String?
    
    var isFetched: Bool = false
    
    
    var imgData: Data?
    var image: UIImage? {
        get {
            if !isFetched {
                if var url = self.imgUrl {
                    if !url.contains("http:") {
                        url = DailyWord.host + url
                    }
                    fetchImgAsync(url: url)
                }
                return UIImage(named: "logo")
            } else {
                if let data = imgData {
                    return UIImage(data: data)
                } else {
                    return UIImage(named: "logo")
                }
            }
        }
    }
    
    var strData: Data?
    var isEntityFetched = false
    var entity: DailyWord {
        get {
            if !isEntityFetched {
                fetchEntityAsync(id: self.id!)
//                return DailyWord(id: 0, title: "", desc: "", imgUrl: "", coverImgUrl: "", author: "佚名")
                self.desc = "人生如戏，戏如人生。"
                self.author = "佚名"
            } else {
                //let str = String(data: strData!, encoding: String.Encoding.utf8)
                //print(str ?? "error")
                do {
                    let json : Any = try JSONSerialization.jsonObject(with: strData!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let dict = json as? [String: NSObject] {
                        self.title = dict["title"] as? String
                        self.author = dict["author"] as? String
                        self.desc = dict["desc"] as? String
                        self.imgUrl = dict["pic_url"] as? String
                        
                    }
                } catch {
                    print("json convert error.")
                }
                
            }
            return self
        }
    }
    
    func fetchEntityAsync(id: Int) {
        if !isEntityFetched {
            let url = "\(DailyWord.host)/dayword?token=\(id)"
            print("start feteching \(url)")
            isEntityFetched = true
            
            DispatchQueue.global(qos: .userInitiated).async() {
                [weak self] in
                do {
                    let entityData = try Data(contentsOf: URL(string: url)!)
                    print("received data \(url)")
                    
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.strData = entityData
                            NotificationCenter.default.post(
                                name: NSNotification.Name("WordsFetched"),
                                object: strongSelf)
                            
                            strongSelf.isEntityFetched = true
                        }
                    }
                    
                } catch {
                    print("error fetching image \(url) error: \(error)")
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.isEntityFetched = false
                        }
                    }
                }
            }
        }
    }
    
    
    func fetchImgAsync(url: String) -> Void {
        if !isFetched {
            
            print("start feteching image \(url)")
            isFetched = true
            
            DispatchQueue.global(qos: .userInitiated).async() {
                [weak self] in
                do {
                    let imageData = try Data(contentsOf: URL(string: url)!)
                    print("received data for image \(url)")
                    
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.imgData = imageData
                            NotificationCenter.default.post(
                                name: NSNotification.Name("ImageFetched"),
                                object: strongSelf)
                            
                            strongSelf.isFetched = true
                        }
                    }
                    
                } catch {
                    print("error fetching image \(url) error: \(error)")
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.isFetched = false
                        }
                    }
                }
            }
        }
    }
    
//    init(title: String, desc: String, imgUrl: String, coverImgUrl: String, author: String) {
//        
//    }
    
    init(id: Int, title: String, desc: String, imgUrl: String, coverImgUrl: String, author: String) {
        self.id = id
        self.title = title
        self.desc = desc
        self.imgUrl = imgUrl
        self.coverImgUrl = imgUrl
        self.author = author
        
        super.init()
    }
    
    override init() {
        super.init()
    }
}
