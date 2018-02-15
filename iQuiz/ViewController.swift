//
//  ViewController.swift
//  iQuiz
//
//  Created by Christy Lu on 2/11/18.
//  Copyright © 2018 Christy Lu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var appdata = AppData.shared
    
    @IBOutlet weak var score: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let all = appdata.questions[appdata.currentTopic]?.count
        score.text = "\(appdata.bingo) of \(all ?? 0) correct!"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

