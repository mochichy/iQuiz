//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/14/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    var userAnswer = String()
    //var currentQuestion = String()
    var appdata = AppData.shared
    
    @IBOutlet weak var correctAnswer: UILabel!
    
    @IBOutlet weak var yesNo: UILabel!
    
    @IBAction func btnNext(_ sender: Any) {
        if appdata.currentQIndex >= (appdata.questions[appdata.currentTopic]?.count)! {
            performSegue(withIdentifier: "toFinished", sender: self)
        } else {
            performSegue(withIdentifier: "toNextQuestion", sender: self)
        }
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        performSegue(withIdentifier: "back", sender: self)
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        if appdata.currentQIndex >= (appdata.questions[appdata.currentTopic]?.count)! {
            performSegue(withIdentifier: "toFinished", sender: self)
        } else {
            performSegue(withIdentifier: "toNextQuestion", sender: self)
        }
    }
    //@IBOutlet var swipeRight: UISwipeGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        correctAnswer.text = "The Correct Answer is: " + appdata.correctAns[appdata.currentQuestion]!
        
        if userAnswer == appdata.correctAns[appdata.currentQuestion] {
            yesNo.text = "BINGO!"
            appdata.bingo = appdata.bingo + 1
        } else {
            yesNo.text = "UHOH..."
        }
        appdata.currentQIndex = appdata.currentQIndex + 1
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
