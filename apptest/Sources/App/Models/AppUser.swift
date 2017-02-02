import Vapor
import Auth
import HTTP

final class AppUser : Model{
    
    /**
     The revert method should undo any actions
     caused by the prepare method.
     
     If this is impossible, the `PreparationError.revertImpossible`
     error should be thrown.
     */
    public static func revert(_ database: Database) throws {
        
        try database.delete("appusers")
    }

    
    
    var id: Node?
    var exists: Bool = false
    var firstname : String
    var lastname  : String
    var username : String
    var emailaddress : String
    var country : String
    var password : String
    
    
    /* Intermediate node data representation  starts */
    
    init(firstname:String, lastname:String, username:String,emailaddress:String, country:String, password:String)  {
        
        self.id = nil
        self.firstname = firstname
        self.lastname = lastname
        self.username = username
        self.country = country
        self.emailaddress = emailaddress
        self.password = password
        
    }
    
    
    init(node: Node, in context: Context) throws {
        id  = try node.extract("id")
        firstname = try node.extract("firstname")
        lastname  = try node.extract("lastname")
        username = try node.extract("username")
        country = try node.extract("country")
        emailaddress = try node.extract("emailaddress")
        password = try node.extract("password")
    }
    
    func makeNode(context: Context) throws -> Node {

        return try Node(node:[
            "id":id,
            "firstname":firstname,
            "lastname":lastname,
            "username":username,
            "emailaddress":emailaddress,
            "country":country,
            "password":password
            ])
        
    }
    
    
    /* Intermediate node data representation  ends */
    
    
    static func prepare(_ database: Database) throws {
        
        try database.create("appusers",closure: { users in
            
            users.id() 
            users.string("firstname")
            users.string("lastname")
            users.string("username")
            users.string("emailaddress")
            users.string("country")
            users.string("password")    
            
        })
    }
    
    
}


extension AppUser: Auth.User {
    
    public static func register(credentials: Credentials) throws -> User {
        throw Abort.custom(status: .badRequest, message: "Register not found")
    }

    
    static func Authenticate(credentials: Credentials) throws -> Auth.User {
        
        let user: AppUser?
        
        switch credentials {
        case let id as Identifier:
            user = try AppUser.find(id.id)
        case let accessToken as AccessToken:
            user = try AppUser.query().filter("accessToken",accessToken.string).first()
        case let apiKey as APIKey:
            user = try AppUser.query().filter("email",apiKey.secret).first()
        default:
            throw Abort.custom(status: .badRequest, message: "Invalid credentials")
            
        }
        
        guard let u = user else {
            throw Abort.custom(status: .badRequest, message: "User not exist or found")
        }
        
        return u
        
    }

    
}



extension Request{
    
    func user() throws -> AppUser {
        
        guard let user = try auth.user() as? AppUser else {
            throw Abort.custom(status: .badRequest, message: "Ivalid user type")
        }
        
        return user
        
    }
    
}

