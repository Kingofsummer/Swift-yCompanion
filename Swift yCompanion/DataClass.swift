//
//  DataClass.swift
//  Swift yCompanion
//
//  Created by Alex FEDORENKO on 9/2/19.
//  Copyright © 2019 Alex FEDORENKO. All rights reserved.
//

import Foundation


import Foundation
import SwiftyJSON

class PersonData {
    
    var name: String = ""
    var image_url = ""
    var user_id: Int = 0
    var backgroundColour: String = ""
    var textColor: String = ""
    var login: String = ""
    var email: String = ""
    var skills: [JSON]  = []
    var level: Double = 0.0
    var wallet: Int = 0
    var points: Int = 0
    var grade: String = ""
    var locationAvail: String = ""
    var locationUnaval: String = ""
    var check: Int = 0
    var campus: String = ""
    var projects: [JSON] = []
}
