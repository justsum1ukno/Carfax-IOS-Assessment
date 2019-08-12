//
//  ListViewController.swift
//  IOS Assessment
//
//  Created by Justin Edwards on 8/6/19.
//  Copyright © 2019 apps. All rights reserved.
//

import UIKit
//import PhoneNumberKit

class ListingViewController: UITableViewController {
   

    @IBOutlet var mTableView: UITableView!
    
   
    var listings = [Listing]()
    var phoneNumber = String()


    override func viewDidLoad() {
        super.viewDidLoad()
    getRequest()
    }
    
   
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
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
        
     
        if dataListing.images?.firstPhoto.large == nil{
            mTableView.scrollToRow(at: IndexPath(row: indexPath.row - 1, section: 0) , at: .none, animated: false)
        }else{
        
        cell.listingPhoto.load(urlString: (dataListing.images?.firstPhoto.large)!)
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
        }
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
                
                let decoder = try JSONDecoder()
                let decodedListings = try decoder.decode(Listings.self, from: dataResponse)
                self.listings = decodedListings.listings
           
                DispatchQueue.main.async{
                self.tableView.reloadData()
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
     
}
    
    @IBAction func callNumber(_ sender: UIButton) {
        print("phone1",sender.titleLabel?.text)
        let phone_Number = sender.titleLabel?.text?.undoFormating()
        guard let numberString = phone_Number , let phoneCallURL = URL(string: "telprompt://\(numberString)") else {
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

extension String {
    func undoFormating()-> String{
    let unFormattedPhone1 = self.replacingOccurrences(of: "(", with: "")
    let unFormattedPhone2 = unFormattedPhone1.replacingOccurrences(of: ")", with: "")
    let unFormattedPhone3 = unFormattedPhone2.replacingOccurrences(of: "-", with: "")
    let unFormattedPhoneFinal = unFormattedPhone3.replacingOccurrences(of: " ", with: "")
    print("uf",unFormattedPhoneFinal)
    return unFormattedPhoneFinal }}

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
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
       
    }
}

