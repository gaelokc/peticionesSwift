//
//  ImageViewController.swift
//  CountDown
//
//  Created by Rodrigo Hernández Gómez on 04/12/2020.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var bgImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //loadWithData()

        Network.shared.newPost()
        //loadWithURLSession()
        
    }
    
    func loadWithData(){
        
        let url = URL(string: "https://picsum.photos/300/200")
        
        do {
        
            let imageData = try Data(contentsOf: url!)
            let image = UIImage(data: imageData)
            self.bgImage.image = image
            
        }catch{
            print(error)
        }
        
    }
    
    func loadWithURLSession(){
        
        Network.shared.getPhoto(completionHandler: {
            imageData in
            
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.bgImage.image = image
            }
            
            return true
        })
        
    }
        
    @IBAction func updatePhoto(_ sender: Any) {
        
        loadWithURLSession()
        
    }
    
    
}
