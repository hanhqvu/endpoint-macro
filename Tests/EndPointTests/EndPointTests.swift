import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import EndPointMacros

let testMacros: [String: Macro.Type] = [
    "EndPoint": EndPointMacro.self,
]

final class EndPointTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            #EndPoint("search")
            """,
            expandedSource: """
            URL(string: "http://api/search")!
            """,
            macros: testMacros
        )
    }
    func testMacroNotLiteralString() {
        let endPoint = "Test"
        
        assertMacroExpansion(
            """
            #EndPoint(endPoint)
            """,
            expandedSource: """
            """,
            diagnostics: [
                DiagnosticSpec(message: "#URL requires a static string literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
    func testMacroNotEmptyString() {
        assertMacroExpansion(
            """
            #EndPoint("")
            """,
            expandedSource: """
            """,
            diagnostics: [
                DiagnosticSpec(message: "String parameter must not be empty", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }
}
