import Foundation

@freestanding(expression)
public macro Endpoint(_ endpoint: String) -> URL = #externalMacro(module: "EndPointMacros", type: "EndPointMacro")
