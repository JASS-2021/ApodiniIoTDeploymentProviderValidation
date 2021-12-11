//
// This source file is part of the JASS open source project
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import Apodini
import ApodiniREST
import ApodiniOpenAPI
import ApodiniDeploy
import DeploymentTargetIoTRuntime
import LifxIoTDeploymentOption
import DuckieIoTDeploymentOption

@main
struct DemoWebService: WebService {
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
