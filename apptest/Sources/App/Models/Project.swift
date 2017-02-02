import Vapor

final class Project: Model {
    
    var id : Node?
    var exists : Bool = false
    var name: String
    var description : String
    var appuserId : Node?
    
    init(name:String, description:String, appuserId: Node? = nil) {
        
        self.id=nil
        self.name = name
        self.description = description
        self.appuserId = appuserId
        
    }
    
    init(node:Node, in context: Context)  throws {
        
        id = try node.extract("id")
        name = try node.extract("name")
        description = try node.extract("description")
        appuserId = try node.extract("appuser_id")
    }
    
    func makeNode(context:Context) throws -> Node {
        return try Node(node:[
            "id":id,
            "name":name,
            "description":description,
            "appuser_id":appuserId
        ])
    }
    
    static func prepare(_ database: Database) throws {
        
        try database.create("projects") { users in
            users.id()
            users.string("name")
            users.string("description")
            users.parent(AppUser.self, optional:false)
        }
    } 
    
    static func revert(_ database: Database) throws { 
        try database.delete("projects")
    }
    
}
