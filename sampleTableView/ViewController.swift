//
//  ViewController.swift
//  sampleTableView
//
//  Created by 이유승 on 12/03/2020.
//  Copyright © 2020 이유승. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var newsData : Array<Dictionary<String, Any>>?
    
    // 1. http 통신 방법
    // 2. Json 데이터 형태
    // 3. 테이블뷰에 데이터 매칭 <- 통보
    // !!! network 통신시 background애서 처리 / UI 처리는: Main
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "http://newsapi.org/v2/top-headlines?country=kr&apiKey=c5a98da5c5244b54b2752aee5c3c6b6c")!) { (data, response, error) in
            
            if let dataJson = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    // Dictionary : Swift Json
                    
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
                    self.newsData = articles
                    
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData() // Main 처리
                    }
                }
                catch {}
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 데이터의 갯수
        
        if let news = newsData {
            return news.count
        }
        else {
            return 0
        }
    }
    
    // 데이터의 정의
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        let idx = indexPath.row
        if let news = newsData {
            let row = news[idx]
            
            if let r = row as? Dictionary<String, Any> {
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                }
            }
        }
        return cell
    }
    
    // 1. Option - Click Observe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath.row
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        if let news = newsData {
            let row = news[indexPath.row]
            
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["imageUrl"] as? String {
                    controller.imageUrl = imageUrl
                }
                if let desc = r["desc"] as? String {
                    controller.desc = desc
                }
            }
        }
        // 화면 이동 - 수동
//        showDetailViewController(controller, sender: nil)
    }
    
    // 2. Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                if let news = newsData {
                    if let indexPath = TableViewMain.indexPathForSelectedRow {
                        let row = news[indexPath.row]
                        
                        if let r = row as? Dictionary<String, Any> {
                            if let imageUrl = r["imageUrl"] as? String {
                                controller.imageUrl = imageUrl
                            }
                            if let desc = r["desc"] as? String {
                                controller.desc = desc
                            }
                        }
                    }
                }
            }
        }
        // 화면 이동 - 자동
    }
    
    // 1. 상세 화면 만들기
    // 2. 화면으로 값 넘기기 2가지
    // 1) tableView delegate  2) storyBoard (segue)
    
    // 3. 화면 이동 (화면 이동 전 미리 데이터 세팅 필수)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }
    // TableView - 여러개의 행이 모여있는 목록 뷰
}
