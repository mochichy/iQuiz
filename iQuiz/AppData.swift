//
//  AppData.swift
//  iQuiz
//
//  Created by Christy Lu on 2/11/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class AppData: NSObject {
    static let shared = AppData()
    
    open var fromQuiz = false
    open var bingo = 0
    open var currentQIndex = 0
    open var currentQuestion = String()
    open var currentTopic = String()
    open var categories = [String]()//["Mathematics", "Marvel Super Heroes", "Science"]
    open var descriptions : [String] = [String]()//["TikTac your calculator is waiting!", "let's save the world together!", "BANG!BOOM!"]
    //open var questions = [ Question(topic: "Mathematics", questions: ["question1", "question2"]), Question(topic: "Marvel Super Heroes", questions: ["question1"]), Question(topic: "Science!", questions: ["Q1"])]
    
    open var questions : [String: [String]] = [String: [String]]()
        /*["Mathematics":["math question1", "math question2"],
         "Marvel Super Heroes":["hero question1"],
         "Science!":["science question1"]]*/
    
    open var potentialAns : [String: [String]] =
        [String: [String]]()
    open var correctAns : [String:String] =
        [String: String]()
    open var score: [String: Int] = [String: Int]()
    
    func makeHTTPGetRequest() {
        var this = categories
        let url = URL(string: "https://tednewardsandbox.site44.com/questions.json")
        let urlSession = URLSession(configuration: .default)
        let task = urlSession.dataTask(with: url!) {(data, response, error) in
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue))
            do {
            if let jsonObj = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSArray {
                //print(jsonObj)
                //print(jsonObj[0])
                for topic in jsonObj {
                    let topicDict = topic as? NSDictionary
                    print(topicDict!["title"] as! NSString)
                    this.append(topicDict!["title"] as! String)
                    print(this)
                }
            }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        task.resume()

    }


    

    
}
