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
import ApodiniDeployer
import IoTDeploymentProviderRuntime
import LifxIoTDeploymentOption
import DuckieIoTDeploymentOption


@main
struct JASS2021WebService: WebService {
    var content: some Component {
        Group("lifx") {
            LIFXHandler()
        }.metadata(DeploymentDevice(.lifx))
        
        Group("duckie") {
            DuckieBotHandler()
        }.metadata(DeploymentDevice(.duckie))
        
        Group("common") {
            FogNodeStatusHandler()
        }.metadata(DeploymentDevice(.default))
    }
    
    var configuration: Configuration {
        REST {
            OpenAPI()
        }
        ApodiniDeployer(runtimes: [IoT.self])
    }
}
