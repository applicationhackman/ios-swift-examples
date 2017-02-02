import Vapor
import HTTP
import VaporPostgreSQL

final class ExperimentController {

    func addRoutes(drop:Droplet) {
        
        
        
        drop.get("experiments"){ request in
            
            let experiments = try JSON(node:Experiment.all())
            
            print(" CSK trying to get all experiments ") 
            
            return try drop.view.make("experiments/index",Node(node:["experiments":experiments]))
            
        }
        
        
        drop.get("experiments", ":id"){ request in
            
            guard let id = request.parameters["id"]?.string else{
                throw Abort.badRequest
            }
            
            print(" Trying to identify Experiments ")
            
            print(id)
            
            let experiment = try JSON(node:Experiment.find(id))
            
            print(experiment)
            
            return try drop.view.make("experiment",Node(node:["experiment":experiment]))
            
        }
        
        
        drop.post("experiments",handler: addNewExperiment)
                
        
    }
    
    
    func addNewExperiment(request :Request) throws -> ResponseRepresentable {
        
        
        print(" Trying to add new experiment ")
        
        guard let name = request.data["name"]?.string, let description = request.data["description"]?.string else {
            throw Abort.badRequest
        }
        
        print(name, description)
        
        var experiment = Experiment(name: name, description: description, projectId: 1, appuserId: 1,type:"1")
        try experiment.save()
        
        
        return Response(redirect: "experiments")
        
    }
    
}

  
