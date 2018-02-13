//
//  questionTableViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/12/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class questionTableViewController: UIViewController {
    var stringPassed = String()
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var q: UILabel!
    
    var appdata = AppData.shared
    
    override func viewWillAppear(_ animated: Bool) {
        question.text = stringPassed
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        q.text = appdata.questions[stringPassed]?[0]
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
