import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

protocol ButtonPressed {
    
}

class ViewController: UIViewController {
    
    
    var token = "" 
    
    var personData = PersonData()
    
    let urlSearch = "https://api.intra.42.fr/v2/"
    let urlToken = "https://api.intra.42.fr/oauth/token"
    let UID = "2aaff788d22c842cfa9d70a2aa97c1520d3610047c248871a07bf46ad35b4b3c"
    let victoriasSecret = "2ca24c7e848d8231f0460001a53c0df4a37bd879ad8fc735513a78a658de6874"
    var userData: [AnyObject] = []
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searhButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        searhButton.layer.cornerRadius = 5
        getToken()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searhButton.isEnabled = true
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        print("!!!!!!!!!!!!buttonPressed!!!!!!!!!!!!!!!!!!!!!!!!")
        searhButton.isEnabled = false
        getStudentData()
     
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destView: StudentInfoView = segue.destination as! StudentInfoView
        destView.text = textField.text!
        destView.personData = personData
    }
    
    func getStudentData(){
        let param: Parameters = ["access_token": token]
        Alamofire.request(urlSearch + "users/" + textField.text!, method: .get, parameters: param).responseJSON { (response) in
            if response.result.isSuccess {
                let userJson = JSON(response.result.value!)
//                print(userJson)
                self.parseData(userJson: userJson)
               
             
            }
        }
    }
    
    func parseData(userJson: JSON){
        personData.image_url = userJson["image_url"].stringValue
//        print(personData.image_url)
        if let user_id = userJson["id"].int{
            parseCoalition(user_id: user_id)
        }
        if let name = userJson["displayname"].string{
            personData.name = name
        }
        if let email = userJson["email"].string{
            personData.email = email
        }
        if let login = userJson["login"].string{
            personData.login = login
        }
        if let level = userJson["cursus_users"][0]["level"].double{
            print(level)
            personData.level = level
            print(personData.level)
        }
    
    }
    
    func parseCoalition(user_id: Int){
        let param: Parameters = ["access_token": token]
        Alamofire.request(urlSearch + "users/" + "\(user_id)" + "/coalitions" , method: .get, parameters: param).responseJSON { (response) in
            if response.result.isSuccess{
                let coalitionData = JSON(response.result.value!)
//                print(coalitionData)
                self.personData.backgroundColour = coalitionData[0]["cover_url"].stringValue
                self.personData.textColor = coalitionData[0]["color"].stringValue
                 self.performSegue(withIdentifier: "studentInfoView", sender: nil)
            }
            else{
                
                print("ERRRRRRRROOOOOOOOOOORRRRRRRRRRR")
            }

        }
        
        
        
        
        
    }
    
    func getToken() {
        let param: Parameters = ["grant_type": "client_credentials", "client_id": UID, "client_secret": victoriasSecret]
        Alamofire.request(urlToken, method: .post, parameters: param).responseJSON { (response) in
            if response.result.isSuccess {
                let tokenJson = JSON(response.result.value!)
                if let token = tokenJson["access_token"].string {
                    self.token = token
                    print("get token \(self.token)")
                }else{
                    print("Error\(response.result.error!)")
                }
            }
        }
    }
    
}


