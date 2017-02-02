import Vapor
import HTTP
import VaporPostgreSQL

final class UserController{
    
    
    func addRoutes(drop:Droplet) {
        
        let usersRoute = drop.grouped("api/v1/users")
        
        usersRoute.post("new",handler: newUser)
        usersRoute.get(AppUser.self,"get",handler:projectIndex)
               
    }
    
    
    func newUser(request: Request) throws -> ResponseRepresentable {
        
        print(" CSK inside new user")
        
        var user = try AppUser(node:request.json)
        try user.save()
        return user 
        
    }
    
    
    func projectIndex(request: Request, appuser: AppUser) throws -> ResponseRepresentable{
        
        print("project index begin here ")
        
        let children = try appuser.children(nil, Project.self).all()
        
        return try JSON(node:children.makeNode())
    }
    
    
    
}
