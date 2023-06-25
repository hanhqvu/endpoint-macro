import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

enum EndPointMacroError: Error, CustomStringConvertible {
    case requiresStaticStringLiteral
    case notEmpty

    var description: String {
        switch self {
        case .requiresStaticStringLiteral:
            return "#URL requires a static string literal"
        case .notEmpty:
            return "String parameter must not be empty"
        }
    }
}

public struct EndPointMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard
            /// 1. Grab the first (and only) Macro argument.
            let argument = node.argumentList.first?.expression,
            /// 2. Ensure the argument contains of a single String literal segment.
            let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            /// 3. Grab the actual String literal segment.
            case .stringSegment(let literalSegment)? = segments.first
        else {
            throw EndPointMacroError.requiresStaticStringLiteral
        }
        
        if (literalSegment.content.text.isEmpty) {
            throw EndPointMacroError.notEmpty
        }

        return "URL(string: \(literal: "http://api/\(literalSegment.content.text)"))!"
    }
}

@main
struct EndPoint_DemoPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EndPointMacro.self,
    ]
}
