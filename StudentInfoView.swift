//
//  StudentInfoView.swift
//  Swift yCompanion
//
//  Created by Alex FEDORENKO on 9/4/19.
//  Copyright © 2019 Alex FEDORENKO. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class StudentInfoView: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    



    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var studentPhoto: UIImageView!
    @IBOutlet weak var skillView: UIView!
    @IBOutlet weak var backgroundColour: UIImageView!
  
   

    @IBOutlet weak var evaluationPoints: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var locations: UILabel!
    @IBOutlet weak var level: UIView!
    
  
    @IBOutlet weak var grade: UILabel!
    
    @IBOutlet weak var progressLevel: UIView!
    @IBOutlet weak var login: UILabel!
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var w: UILabel!
    @IBOutlet weak var p: UILabel!
    @IBOutlet weak var g: UILabel!
    
    @IBOutlet weak var campus: UILabel!
    
 @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var skillTableView: UITableView!
    @IBOutlet weak var projectTableView: UITableView!
    @IBOutlet weak var piscineTableView: UITableView!
    
    
    var text: String = ""
    var url_image: String = ""
    var personData = PersonData()
    var background: String = ""
    
    var nameSkillArr = [String]()
    var levelSkillArr = [String]()
    
    var piscineDays: [JSON] = []
    var unitProjects: [JSON] = []
   
    

    
    @IBAction func sweetHome(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue: Int = 1
        if tableView == skillTableView{
            returnValue = nameSkillArr.count

        }
        else if tableView == projectTableView{
            returnValue = unitProjects.count

        }
        else if tableView == piscineTableView{
            returnValue = piscineDays.count
           
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        var cell = UITableViewCell()
        
        if tableView == skillTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell",  for: indexPath) as! SkillCell
            cell.nameSkillLabel.textColor = hexStringToUIColor(hexString: personData.textColor)
            cell.levelSkillLabel.textColor = hexStringToUIColor(hexString: personData.textColor)
            cell.nameSkillLabel.text = nameSkillArr[indexPath.row]
            cell.levelSkillLabel.text = levelSkillArr[indexPath.row]
            return cell
        }
        else if tableView == projectTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell",  for: indexPath) as! ProjectCell
            cell.nameProject.textColor = hexStringToUIColor(hexString: "#009999")
            
           
            cell.nameProject.text = unitProjects[indexPath.row]["project"]["name"].string
            
            if let finalmrk = unitProjects[indexPath.row]["final_mark"].int{
                print("\(unitProjects[indexPath.row]["project"]["name"].stringValue) -- \(unitProjects[indexPath.row]["final_mark"]).int")
                if finalmrk >= 60{
                    cell.finalMark.textColor = hexStringToUIColor(hexString: "#009929")
                    cell.finalMark.text = "👍" + String(finalmrk)
                    
                }else{
                    cell.finalMark.textColor = UIColor.red
                    cell.finalMark.text = "👎" + String(finalmrk)
                }
            }
            else{
//                if unitProjects[indexPath.row]["status"].stringValue == "in_progress" || unitProjects[indexPath.row]["status"].stringValue == "searching_a_group"{
                    cell.nameProject.text = unitProjects[indexPath.row]["project"]["name"].string
                    cell.finalMark.text = "🕐"
//                }
            }
            return cell
        }
        else if tableView == piscineTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "piscineCell", for: indexPath) as! PiscineCell
            cell.nameDay.textColor = hexStringToUIColor(hexString: "#009999")
            cell.nameDay.text = piscineDays[indexPath.row]["project"]["slug"].string
            print()
            if let mrkDay = piscineDays[indexPath.row]["final_mark"].int{
                if mrkDay >= 27{
                    cell.markDay.textColor = hexStringToUIColor(hexString: "#009929")
                    cell.markDay.text = "👍" + String(mrkDay)
                }
                else{
                    cell.markDay.textColor = UIColor.red
                    cell.markDay.text = "👎" + String(mrkDay)
                }
                
            }
            return cell
        }
        else{
            print("error tableView")
            return cell
        }

        
    }
    
    override func viewDidLoad() {
        
        skillTableView.delegate = self
        projectTableView.delegate = self
        skillTableView.dataSource = self
        projectTableView.dataSource = self
        projectTableView.allowsSelection = false
        skillTableView.allowsSelection = false
        piscineTableView.dataSource = self
        piscineTableView.delegate = self

        setImages()
        setSkillView()
        fetchSkillData()
        fetchProjectData()
    }
    
    func fetchProjectData(){
        unitProjects.removeAll()
        piscineDays.removeAll()
        
        for item in personData.projects{
            var nameProject: String = ""
            if item["cursus_ids"][0] == 1{
                nameProject = item["project"].stringValue
                unitProjects.append(item)
            }
            else if item["cursus_ids"][0] == 4{
                nameProject = item["project"].stringValue
                piscineDays.append(item)
            }
            print(unitProjects)
        }
    }
    
    func fetchSkillData(){
        nameSkillArr.removeAll()
        levelSkillArr.removeAll()
        for item in personData.skills{
            let nameSkill = item["name"].stringValue
            let levelSkill = item["level"].stringValue
            nameSkillArr.append(nameSkill)
            levelSkillArr.append(levelSkill)
        }
        
    }
    
    func setSkillView(){
        
        levelLabel.text = "Level \(personData.level)"
        progressLevel.backgroundColor = hexStringToUIColor(hexString: personData.textColor)
        progressLevel.frame.size.width = view.frame.size.width / 100 * CGFloat(Int(personData.level*100) % 100)
        studentName.text = personData.name
        login.text = personData.login
        email.text = personData.email
        email.textColor = hexStringToUIColor(hexString: personData.textColor)
        campus.textColor = hexStringToUIColor(hexString: personData.textColor)
        wallet.textColor = hexStringToUIColor(hexString: personData.textColor)
        evaluationPoints.textColor = hexStringToUIColor(hexString: personData.textColor)
        grade.textColor = hexStringToUIColor(hexString: personData.textColor)
        w.textColor = hexStringToUIColor(hexString: personData.textColor)
        w.text = String(personData.wallet)
        p.textColor = hexStringToUIColor(hexString: personData.textColor)
        p.text = String(personData.points)
        g.textColor = hexStringToUIColor(hexString: personData.textColor)
        g.text = String(personData.grade)
        
        if personData.check == 0{
            locations.text = personData.locationAvail
        }
        else{
            personData.check = 0
            locations.text = personData.locationUnaval
        }
        campus.text = personData.campus
        
    }
    
    
    func setImages(){
        if let urll = URL(string: personData.backgroundColour){
            do{
                let data = try Data(contentsOf: urll)
                self.backgroundColour.image = UIImage(data: data)
            }
            catch let err{
                print("error")
            }
        }
        
        if let url = URL(string: personData.image_url){
            do{
                let data = try Data(contentsOf: url)
                self.studentPhoto.image = UIImage(data: data)
            }
            catch let err{
                print("error")
            }
        }
    }
    
    
    
    
    func hexStringToUIColor (hexString: String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

class SkillCell: UITableViewCell{
    
    @IBOutlet weak var nameSkillLabel: UILabel!
    @IBOutlet weak var levelSkillLabel: UILabel!
}

class ProjectCell: UITableViewCell{
    
    @IBOutlet weak var nameProject: UILabel!
    @IBOutlet weak var finalMark: UILabel!
}

class PiscineCell: UITableViewCell{
    @IBOutlet weak var nameDay: UILabel!
    @IBOutlet weak var markDay: UILabel!
    
}


































