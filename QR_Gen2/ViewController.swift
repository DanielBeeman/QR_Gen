//
//  ViewController.swift
//  QR_Gen
//
//  Created by Daniel Beeman on 7/31/19.
//  Copyright © 2019 Daniel Beeman. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //array to store picker view information
    var prevCodes:[String] = ["---", "Cascadia Carbon"]
    
    
    
    //References to stuff in the main storyboard
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBAction func button(_ sender: Any) {
        
        if myTextField.text != ""
        {
            
            performSegue(withIdentifier: "segue", sender: self)
            
            prevCodes.append(myTextField.text!)
            print (prevCodes)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //enables us to access and interact with core data
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Codes")
            
            request.returnsObjectsAsFaults = false
            
            
            //to delete
            if prevCodes.count > 11 {
                do {
                    let test = try context.fetch(request)
                    
                    let objectToDelete = test[0] as! NSManagedObject
                    context.delete(objectToDelete)
                    
                    do {
                        try context.save()
                    }
                    catch{
                        print(error)
                    }
                    
                }
                catch {
                    print(error)
                }
            }
            
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Codes", into: context)
            
                    newUser.setValue(myTextField.text, forKey: "prevCodes")
            
            
                    do
                    {
                        try context.save()
                        print ("SAVED")
                    }
                    catch
                    {
                        //PROCESS ERROR
                    }
        }
        
    }
    
    //prepare data to send to second view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondController = segue.destination as! SecondViewController //Allows us to access second view controller
        
        if let myString = myTextField.text{
            let data = myString.data(using: .ascii, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            
            let img = UIImage(ciImage: ((filter?.outputImage)!))
            secondController.img2 = img
            
        }
        //sets text attribute in other scene to the text inputted in this scene
        secondController.myString2 = myTextField.text!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for pickerview
        pickerView.dataSource = self
        pickerView.delegate = self
        
        //Storing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //enables us to access and interact with core data
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Codes")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
        
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                     if let username = result.value(forKey: "prevCodes") as? String
                    {
                        prevCodes.append(username)
                    }
                    
                    
                }
                print (prevCodes)
            }
        } catch
        {
            //PROCESS ERROR
        }
        
        
    }
    
    
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //specifies how many components can be selected at once (columns)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //specifies how many total options in pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return prevCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        if prevCodes[row] != "---"{
            myTextField.text = prevCodes[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return prevCodes[row]
    }
}
