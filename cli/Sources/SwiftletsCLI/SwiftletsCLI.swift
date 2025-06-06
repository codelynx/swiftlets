import ArgumentParser
import Foundation

@main
struct SwiftletsCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swiftlets",
        abstract: "A Swift-based web framework with executable-per-route architecture",
        version: "0.1.0",
        subcommands: [New.self, Serve.self, Build.self, Init.self]
    )
}