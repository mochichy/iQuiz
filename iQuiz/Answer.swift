//
//  Answer.swift
//  iQuiz
//
//  Created by Christy Lu on 2/13/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import Foundation
class Answer {
    var question: String
    var potentialAnswers: [String]
    var correctAnswer: String
    init(question: String, potentialAnswers: [String], correctAnswer: String) {
        self.question = question
        self.potentialAnswers = potentialAnswers
        self.correctAnswer = correctAnswer
    }
}
