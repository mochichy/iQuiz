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
    
    open var questions : [String: [String]] =
        ["Mathematics":["math question1", "math question2"],
        "Marvel Super Heroes":["hero question1"],
        "Science":["science question1"]]
    
    open var potentialAns : [String: [String]] =
        ["math question1": ["12", "0", "100", "83"],
        "math question2": ["0", "1", "2", "10"],
        "hero question1": ["hero1", "hero2", "hero3", "hero4"],
        "science question1": ["s1", "s2", "s3", "s4"]]
    open var correctAns : [String:String] =
        ["math question1": "0",
        "math question2": "1",
        "hero question1": "hero4",
        "science question1": "s3"]
}
