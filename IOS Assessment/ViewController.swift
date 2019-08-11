//
//  ViewController.swift
//  IOS Assessment
//
//  Created by Justin Edwards on 8/6/19.
//  Copyright © 2019 apps. All rights reserved.
//

import UIKit
//import PhoneNumberKit

class ViewController: UITableViewController {
   

    @IBOutlet var mTableView: UITableView!
    
   
    var listings = [Listing]()
    var phoneNumber = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        
 tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "listingTableViewCell")

    getRequest()
        print("height", self.tableView.frame.height )
    }
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return listings.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return listings.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Dequeue the cell with identifier
      guard  let cell = mTableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath)
            as? listingViewTableCell else {
                fatalError()
        }
       
        let dataListing = listings[indexPath.row]
        
        
        cell.listingPhoto.load(urlString: dataListing.images.firstPhoto.small)
        cell.listingYear_Label.text = String(dataListing.year)
        cell.listingYear_Label.font = UIFont.boldSystemFont(ofSize: 13)
        cell.listingMake_Label.text = dataListing.make
        cell.listingMake_Label.font = UIFont.boldSystemFont(ofSize: 13)
        cell.listingModel_Label.text = dataListing.model
        cell.listingModel_Label.font = UIFont.boldSystemFont(ofSize: 13)
        cell.listingPrice_Label.text = "$" + dataListing.currentPrice.withCommas()
        cell.listingPrice_Label.font = UIFont.boldSystemFont(ofSize: 13)
        cell.listingMileage_Label.text = dataListing.mileage.withCommas() + " Mi"
        cell.listingLocation_Label.text = dataListing.dealer.city + " , " + dataListing.dealer.state
        cell.phoneButton.setTitle(formatPhoneNumber(phoneNumber: dataListing.dealer.phone), for: UIControl.State.normal)
        cell.phoneButton.addTarget(self, action: #selector(callNumber), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height * 0.38  
    }
    
    func getRequest(){
        guard let url = URL(string: "https://carfax-for-consumers.firebaseio.com/assignment.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse) as? [String: Any]
                
                let decoder = try JSONDecoder()
                let decodedListings = try decoder.decode(Listings.self, from: dataResponse)
               // let decodedImages = try decoder.decode([Images].self, from: dataResponse)
                self.listings = decodedListings.listings
                print(self.listings.count)
               // self.images = decodedListings.images.firstPhoto.large
                
                
               
                DispatchQueue.main.async{
                self.tableView.reloadData()
                } //  print(jsonArray)
                //print(jsonResponse) //Response result
                //    let convertedString = String(data: dataResponse, encoding: String.Encoding.utf8) // the data will be converted to the string
                //    print(convertedString ?? "defaultvalue")
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
     //   self.myTableView.beginUpdates()
}
    
    @IBAction func callNumber(_ sender: UIButton) {
        print("phone1",sender.titleLabel?.text)
        guard let numberString = sender.titleLabel?.text, let phoneCallURL = URL(string: "telprompt://\(numberString)") else {
            return}
        print("phone2",phoneCallURL)
        UIApplication.shared.open(phoneCallURL)
    }

    func formatPhoneNumber(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
        
        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }
        
        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }
        
        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
            
        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }
        
        return number
    }
    
}
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}



extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
                //  print(jsonArray)
                //print(jsonResponse) //Response result
                //    let convertedString = String(data: dataResponse, encoding: String.Encoding.utf8) // the data will be converted to the string
                //    print(convertedString ?? "defaultvalue")
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        //   self.myTableView.beginUpdates()
    }
}

