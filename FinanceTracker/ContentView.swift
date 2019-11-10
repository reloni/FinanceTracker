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

struct Parser<Input, Output> {
    let run: (Input) -> Output?
}

extension Parser {
    func map<NewOutput>(_ transform: @escaping (Output) -> NewOutput?) -> Parser<Input, NewOutput> {
        Parser<Input, NewOutput> { self.run($0).map { transform($0) } ?? nil }
    }
}

extension Parser where Input == String {
    static var `string`: Parser<Input, String> { return .init { $0 } }
    static var `bool`: Parser<Input, Bool> { return Parser.string.map { Bool($0) } }
    static var logLevel: Parser<Input, LogLevel> { return Parser.string.map { LogLevel(rawValue: $0) } }
}

struct EnvironmentVariable<T> {
    let name: String
    let parser: Parser<String, T>
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
