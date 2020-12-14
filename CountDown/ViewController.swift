//
//  ViewController.swift
//  CountDown
//
//  Created by Rodrigo Hernández Gómez on 02/12/2020.
//

import UIKit

class ViewController: UIViewController {
    
    let COUNTDOWN = 3
    var running = false
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        displayLabel.text = String(COUNTDOWN)
        
        Network.shared.getPet()
                
    }
    
    
    @IBAction func startStop(_ sender: UIButton) {
        
        if(running){
            sender.titleLabel?.text = "START"
            running = false
            stopCount()
        }else{
            sender.titleLabel?.text = "STOP"
            running = true
            startCount()
        }
        
        
    }
    
    //This function
    func startCount(){
        
        //Con cada segundo que pase
        //If count == 0 Alert
        var countDown = COUNTDOWN
        
        while(countDown >= 0 && running){
            self.displayLabel.text = String(countDown)
            sleep(1)
            countDown -= 1
        }
        
        displayLabel.text = String(0)
        
        //TODO show the alert
        if(countDown < 0){
            
            let alert = UIAlertController.init(title: "BOOM!", message: "Acabó la cuenta atrás", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            restartCountDown()
            
        }
    
    }
    
    //This function stop the countwond
    func stopCount(){
        
        if(running){
            running = false
        }
        
    }
    
    //This function restart the timer
    func restartCountDown(){
        
        let countDown = COUNTDOWN
        displayLabel.text = String(countDown)
    }


}

