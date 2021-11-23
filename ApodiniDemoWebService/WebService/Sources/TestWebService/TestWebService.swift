import Apodini
import ApodiniOpenAPI
import ApodiniREST
import ArgumentParser
import ApodiniDeploy
import DeploymentTargetIoTRuntime
import LifxIoTDeploymentOption
import DuckieIoTDeploymentOption

@main
struct TestWebService: WebService {
    var content: some Component {
        Group("lifx") {
            TextHandler("Displaying Lifx Content")
        }.metadata(DeploymentDevice(.lifx))
        
        Group("duckie") {
            TextHandler("Displaying Duckie Content")
        }.metadata(DeploymentDevice(.duckie))
        
        Group("common") {
            TextHandler("Displaying Common Content")
        }.metadata(DeploymentDevice(.default))
    }
    
    var configuration: Configuration {
        REST {
            OpenAPI()
        }
        ApodiniDeploy(runtimes: [IoTRuntime<Self>.self])
    }
}
