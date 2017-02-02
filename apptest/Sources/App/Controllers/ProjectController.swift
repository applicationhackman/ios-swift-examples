import Vapor
import HTTP
import VaporPostgreSQL

final class ProjectController {
    
    func addRoutes(drop:Droplet)  {
        
        let projectRoute = drop.grouped("api/v1/projects")
        projectRoute.get("get",handler: projects)
        projectRoute.post("new",handler: newProject)
        projectRoute.get("update",handler:updateProject)
        
        drop.get("projects"){ request in
            
            let projects = try JSON(node:Project.all())
            return try drop.view.make("projects/index", Node(node:["projects":projects]))
            
        }
        
        drop.post("projects",handler: addNewProject)
        
    }
    
    func addNewProject(request:Request) throws -> ResponseRepresentable{
    
        print(" CSK trying to   add new project ")
        
        guard let name = request.data["name"]?.string, let description = request.data["description"]?.string else {
            throw Abort.badRequest
        }
        
        print(name, description)
        
        print(" addNewProject ")
        
        var project = Project(name: name, description: description,appuserId:1)
        try project.save()
        
        return Response(redirect: "/projects")
        
    }
    
    
    
    func projects(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Project.all().makeNode())
    }
    
    func newProject(request: Request) throws -> ResponseRepresentable  {
        
        var project = try Project(node:request.json)
        try project.save()
        return project
    }
    
    func updateProject(request:Request) throws -> ResponseRepresentable {
        
        guard var project = try Project.query().first(), let description = request.data["description"]?.string, let name = request.data["name"]?.string
            else {
            throw Abort.badRequest
        }
        
        project.name = name
        project.description = description
        
        try project.save()
        return project
    }
    
    
}
