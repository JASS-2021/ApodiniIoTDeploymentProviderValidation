//
// This source file is part of the JASS open source project
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the JASS project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//

import ArgumentParser
import IoTDeploymentProviderCommon
import IoTDeploymentProvider
import DeviceDiscovery
import DuckiePostDiscoveryAction
import LifxIoTDeploymentOption
import DuckieIoTDeploymentOption
import Foundation


struct JASS2021IoTDeploymentProviderCommand: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "deploy",
            abstract: "LIFX Deployment Provider",
            discussion: "Runs the LIFX deployment provider",
            version: "0.0.1"
        )
    }
    
    @Argument(parsing: .unconditionalRemaining, help: "CLI arguments of the web service")
    var webServiceArguments: [String] = []
    
    @OptionGroup
    var deploymentOptions: IoTDeploymentOptions
    
    @Option(help: "Path to the credential file")
    var credentialFilePath: String
    
    func run() throws {
        print(FileManager.projectDirectory)
        let provider = IoTDeploymentProvider(
            searchableTypes: deploymentOptions.types.split(separator: ",").map { DeviceIdentifier(String($0)) },
            automaticRedeployment: deploymentOptions.automaticRedeploy,
            webServiceArguments: webServiceArguments,
            input: .dockerImage("ghcr.io/jass-2021/jass2021-webservice:latest"),
            configurationFile: URL(fileURLWithPath: credentialFilePath),
            dumpLog: deploymentOptions.dumpLog,
            redeploymentInterval: TimeInterval(deploymentOptions.redeploymentInterval)
        )
        provider.registerAction(
            scope: .all,
            action:
                .docker(
                    DockerDiscoveryAction(
                        identifier: ActionIdentifier("docker_lifx"),
                        imageName: "ghcr.io/jass-2021/lifx-post-discovery-action:latest",
                        fileUrl: URL(fileURLWithPath: deploymentOptions.deploymentDir)
                            .appendingPathComponent("lifx_devices"),
                        options: [
                            .privileged,
                            .volume(hostDir: deploymentOptions.deploymentDir, containerDir: "/app/tmp"),
                            .network("host"),
                            .command("/app/tmp --number-only"),
                            .credentials(username: "", password: "")
                        ]
                    )
                ),
            option: DeploymentDeviceMetadata(.lifx)
        )
        provider.registerAction(scope: .all, action: .action(DuckiePostDiscoveryAction.self), option: DeploymentDeviceMetadata(.duckie))
        try provider.run()
    }
}
