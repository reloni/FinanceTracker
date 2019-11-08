//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Anton Efimenko on 13/09/2019.
//  Copyright © 2019 Anton Efimenko. All rights reserved.
//

import SwiftUI

enum LogLevel: String {
    case verbose
    case warning
    case error
}

struct EnvValueParser<A> {
    let run: (String) -> A?
}

extension EnvValueParser {
    static var `string`: EnvValueParser<String> { return EnvValueParser<String> { $0 } }
    static var `bool`: EnvValueParser<Bool> { return EnvValueParser.string.pullback { Bool($0) } }
    static var logLevel: EnvValueParser<LogLevel> { return EnvValueParser.string.pullback { LogLevel(rawValue: $0) } }
    
    func pullback<B>(_ transform: @escaping (A) -> B?) -> EnvValueParser<B> {
        return EnvValueParser<B> { self.run($0).map { transform($0) } ?? nil }
    }
}

struct EnvironmentVariable<T> {
    let name: String
    let parser: EnvValueParser<T>
}

extension EnvironmentVariable {
    static var myVar: EnvironmentVariable<Bool> { .init(name: "myVar", parser: .bool) }
    static var logLevel: EnvironmentVariable<LogLevel> { .init(name: "logLevel", parser: .logLevel) }
}


struct AppEnvironment {
    private let value: (String) -> String?
    
    static let current = AppEnvironment { ProcessInfo.processInfo.environment[$0] }

    func value<T>(_ variable: EnvironmentVariable<T>) -> T? {
        value(variable.name).map { variable.parser.run($0) } ?? nil
    }
}



func procInfo() {
    print(AppEnvironment.current.value(.myVar))
    print(AppEnvironment.current.value(.logLevel))
}

struct ContentView: View {
    var body: some View {
        Text("Hello World")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
