import Vapor

final class Experiment: Model {
    
    var id     : Node?
    var exists : Bool = false
    var name   :   String
    var description : String
    var projectId : Node?
    var appuserId : Node?
    var type : String
    
    init(name: String, description:String, projectId : Node? = nil, appuserId: Node? = nil, type : String) {
        
        self.id = nil
        self.name = name
        self.description = description
        self.projectId = projectId
        self.appuserId = appuserId
        self.type = type
        
    }
    
    
    init(node:Node, in context: Context) throws {
        
        id = try node.extract("id")
        name = try node.extract("name")
        description = try node.extract("description")
        projectId = try node.extract("projectId")
        appuserId = try node.extract("appuserId")
        type = try node.extract("type")
        
    }
    
    func makeNode(context:Context) throws -> Node {
        
        return try Node(node:[
                "id":id,
                "name":name,
                "description":description,
                "project_id":projectId,
                "appuser_id":appuserId,
                "type":type
        ])
        
    }
    
    
    static func prepare(_ database:Database) throws {
        
        try database.create("experiments") { users in
            
            users.id()
            users.string("name")
            users.string("description")
            users.parent(AppUser.self, optional:false)
            users.parent(Project.self, optional:false)
            users.string("type")
            
        }  
        
    }
    
    static func revert(_ database: Database) throws {
        
    
        try database.delete("experiments")
        
    }
    
     
    
}
 
