//
// This source file is part of the Apodini open source project
//
// SPDX-FileCopyrightText: 2019-2021 Paul Schmiedmayer and the Apodini project authors (see CONTRIBUTORS.md) <paul.schmiedmayer@tum.de>
//
// SPDX-License-Identifier: MIT
//  

import ArgumentParser
import IoTDeploymentProvider


@main
struct JASS2021IoTDeploymentProvider: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "LIFX Deployment Provider",
            discussion: "Contains LIFX deployment related commands",
            version: "0.0.1",
            subcommands: [JASS2021IoTDeploymentProviderCommand.self, KillSessionCommand.self],
            defaultSubcommand: JASS2021IoTDeploymentProviderCommand.self
        )
    }
}
