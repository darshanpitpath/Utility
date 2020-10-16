//
//  CountryCodePickerViewController.swift
//  UserUtility
//
//  Created by IPS on 14/10/20.
//  Copyright © 2020 IPS. All rights reserved.
//

import UIKit

protocol CountryCodePickerDelegate {
    func didSelectCountryCodePicker(countryCode:Country)
}
class CountryCodePickerViewController: UIViewController {

    @IBOutlet weak var objContainerView:UIView!
    @IBOutlet weak var objTableView:UITableView!
    @IBOutlet weak var buttonSave:CornorButton!
    @IBOutlet weak var buttonCancel:CornorButton!
    @IBOutlet weak var txtSearchbar:UISearchBar!
    
    @IBOutlet weak var tableViewBottomBarConstraint:NSLayoutConstraint!
    
    var delegate:CountryCodePickerDelegate?
    
    var selectedCountry:Country?
    var arrayOfCountry:[Country] = []
    var arrayOfFilterArray:[Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //setup
        self.setup()
        
         
    }
    // MARK: - Setup
    func setup(){
        //add cornor radius to container view
        self.objContainerView.clipsToBounds = true
        self.objContainerView.layer.cornerRadius = 6.0
        
        //setup countrycode list tableview
        self.setupTableView()
        
        self.arrayOfFilterArray = self.arrayOfCountry

        //SETUP UISEARCH BAR
        self.setupUISearchBar()
        
        //SELECTED COUNTRY CONIGURATION
        guard let currentSelectedCountry = self.selectedCountry else {
            
            return
        }
        if self.arrayOfCountry.count > 0{
            DispatchQueue.main.async {
                
                
                
                if let obj = self.arrayOfFilterArray.firstIndex(where: {$0.name == currentSelectedCountry.name}){
                    let objIndexPath = IndexPath.init(row: obj, section: 0)
                    
                    print(self.objTableView.numberOfRows(inSection: 0))
                    
                    if let objCell = self.objTableView.cellForRow(at: objIndexPath){
                        print(objCell)
                    }else{
                        print("No Cell")
                    }
                    //self.objTableView.scrollToRow(at: IndexPath.init(row: obj, section: 0), at: .none, animated: true)
                }
                
                
            }
            //self.selectedCountry = self.arrayOfCountry.first!
        }
        //ADD OBSERVER FOR KEYBOARD
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    //UITableView Configuration
    func setupTableView(){
        let objCountryTableViewCellNib = UINib.init(nibName:"CountryTableViewCell", bundle: nil)
        self.objTableView.register(objCountryTableViewCellNib, forCellReuseIdentifier: "CountryTableViewCell")
        self.objTableView.separatorStyle = .singleLine
        self.objTableView.delegate = self
        self.objTableView.dataSource = self
        self.objTableView.tableFooterView = UIView()
        self.objTableView.tableHeaderView = UIView()
        self.objTableView.estimatedRowHeight = 100.0
        self.objTableView.rowHeight = UITableView.automaticDimension
        self.objTableView.reloadData()
    }
    //UISearcbar Configuration
    func setupUISearchBar(){
        self.txtSearchbar.delegate = self
    }
    //KEYBOARD WILL SHOW
    @objc func keyboardWillShow(notification:NSNotification){
        DispatchQueue.main.async {
            self.tableViewBottomBarConstraint.constant = 10.0
        }
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardRectValue.height
            DispatchQueue.main.async {
                
                self.tableViewBottomBarConstraint.constant = keyboardHeight - (50.0 + 34.0)
            }
        }
        
    }
    //KEYBOARD WILL HIDE
    @objc func keyboardWillHide(notification:NSNotification){
        DispatchQueue.main.async {
            self.tableViewBottomBarConstraint.constant = 10.0
        }
    }
    //MARK: - SELECTOR METHODS
    @IBAction func buttonSaveSelector(sender:UIButton){
        if let _ = self.selectedCountry{
            self.delegate?.didSelectCountryCodePicker(countryCode: self.selectedCountry!)
            //SAVE COUNTRY PICKER AND DISMISS POPUP CONTROLLER
            self.dismiss(animated: true, completion: nil)
        }else{
           //SHOW TOAST TO SELECT COUNTRY FROM LIST
            DispatchQueue.main.async {
                ShowToast.show(toatMessage: "Please select country to save")
            }
        }
    }
    @IBAction func buttonCancelSelector(sender:UIButton){
        //DISMISS COUNTRY PICKER POPUP CONTROLLER
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
extension CountryCodePickerViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell") as! CountryTableViewCell
        if self.arrayOfCountry.count > indexPath.row{
            
            let objCountry = self.arrayOfFilterArray[indexPath.item]
            objTableViewCell.lblCountryCode.text = "\(objCountry.dialcode)"
            objTableViewCell.lblCountryDetail.text = "\(objCountry.name)"
            objTableViewCell.imageCountry.image = UIImage.init(named: "\(objCountry.code)")
            if let currentSelectedCountry = self.selectedCountry {
                objTableViewCell.lblTick.isHidden = !(currentSelectedCountry.code == objCountry.code)
//                if {
//                    objTableViewCell.backgroundColor = UIColor.lightGray
//                }else{
//                    objTableViewCell.backgroundColor = UIColor.white
//                }
            }
        }
        
        return objTableViewCell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfFilterArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCountry = self.arrayOfFilterArray[indexPath.row]
        DispatchQueue.main.async {
            self.objTableView.reloadData()
        }
    
    }
}
extension CountryCodePickerViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            self.setupSearchToDefault()
            return
        }
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let typpedString = ((txtSearchbar.text)! as NSString).replacingCharacters(in: range, with: text)
        print(typpedString)
        print("shouldChangeTextIn")
        guard typpedString.count > 0 else {
            self.setupSearchToDefault()
            return true
        }
        self.filterCountryArrayOnSearch(searchText: typpedString)
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked \(searchBar.text)")
       DispatchQueue.main.async {
           self.txtSearchbar.resignFirstResponder()
       }
        if let objSearch = searchBar.text, objSearch.count > 0{
            self.filterCountryArrayOnSearch(searchText: "\(objSearch)")
        }else{
            self.setupSearchToDefault()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.txtSearchbar.resignFirstResponder()
        }
        searchBar.text = ""
        self.setupSearchToDefault()
        print("searchBarCancelButtonClicked")
    }
    
    func filterCountryArrayOnSearch(searchText:String){
        let objfliterarray = self.arrayOfCountry.filter{ $0.name.contains("\(searchText)") || $0.dialcode.contains("\(searchText)")}
        print(objfliterarray)
        self.arrayOfFilterArray = objfliterarray
        DispatchQueue.main.async {
            self.objTableView.reloadData()
        }
    }
    func setupSearchToDefault(){
        self.arrayOfFilterArray = self.arrayOfCountry
        DispatchQueue.main.async {
            self.objTableView.reloadData()
        }
    }
}
