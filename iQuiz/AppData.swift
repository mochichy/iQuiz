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
    open var categories : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
    open var descriptions : [String] = ["TikTac your calculator is waiting!", "let's save the world together!", "BANG!BOOM!"]
    //open var questions = [ Question(topic: "Mathematics", questions: ["question1", "question2"]), Question(topic: "Marvel Super Heroes", questions: ["question1"]), Question(topic: "Science", questions: ["Q1"])]
    
    open var questions : [String: [String]] = ["Mathematics":["math question1", "math question2"], "Marvel Super Heroes":["hero question1"], "Science":["science question1"]]
}
