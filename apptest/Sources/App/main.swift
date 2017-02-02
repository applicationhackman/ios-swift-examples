import Vapor
import VaporPostgreSQL
import Auth

let drop = Droplet(
    providers:[VaporPostgreSQL.Provider.self]
)

let auth = AuthMiddleware(user:AppUser.self)
drop.middleware.append(auth)
 
drop.preparations.append(AppUser.self)
drop.preparations.append(Project.self)
drop.preparations.append(Experiment.self)


drop.get("hello"){ request in
    
    return try drop.view.make("welcome", [
        "message": drop.localization["welcome", "title"]
        ])
    
}


let project = ProjectController()
project.addRoutes(drop: drop)



let user = UserController()
user.addRoutes(drop: drop)


let experiment = ExperimentController()
experiment.addRoutes(drop: drop)

//drop.group("users", closure: { users in
//    
//    users.post{ req in
//        
//        print(" CSK inside users ")
//        
//        
//        guard let firstname = req.data["firstname"]?.string else {
//            throw Abort.badRequest
//        }
//        
//        guard let lastname = req.data["lastname"]?.string else {
//            throw Abort.badRequest
//        }
//        
//        guard let username = req.data["username"]?.string else {
//            throw Abort.badRequest
//        }
//        
//        guard let emailaddress = req.data["emailaddress"]?.string else {
//            throw Abort.badRequest
//        }
//        
//        guard let country = req.data["country"]?.string else {
//            throw Abort.badRequest
//        }
//        guard let password = req.data["password"]?.string else {
//            throw Abort.badRequest
//        }
//        
//        
//        var user = AppUser(firstname: firstname, lastname: lastname, username: username, emailaddress: emailaddress, country: country, password: password)
//        try user.save()
//        
//        return user
//        
//    }
//    
//})


drop.run()
