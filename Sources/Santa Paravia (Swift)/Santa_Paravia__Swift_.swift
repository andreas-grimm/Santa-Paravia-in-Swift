// The Swift Programming Language
// https://docs.swift.org/swift-book
// 
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation

@main
struct Santa_Paravia__Swift_: ParsableCommand {
    mutating func run() throws {
        let game: Game = Game()
        game.game();
    }
}

