import Foundation
import SourceKittenFramework

public func toSubstructures(raw: [String: SourceKitRepresentable]) -> [Substructure] {
    guard let rawSubstructures = raw["key.substructure"] as? [SourceKitRepresentable] else {
        return []
    }

    return rawSubstructures.map { rawSubstructure in
        return Substructure(substructure: rawSubstructure as! [String: SourceKitRepresentable])
    }
}

public class Substructure: CustomDebugStringConvertible {
    // MARK: Object lifecycle

    public init(substructure: [String: SourceKitRepresentable]) {
        self.rawSubstructure = substructure
    }

    public let rawSubstructure: [String: SourceKitRepresentable]

    public var debugDescription: String {
        return "\(rawSubstructure)"
    }

    public var kind: Kind? {
        return
            (rawSubstructure["key.kind"] as? String)
                .flatMap { Kind(rawValue: $0) }
    }

    public var classSubstructure: ClassSubstructure {
        precondition(kind == .Class)
        return ClassSubstructure(substructure: rawSubstructure)
    }

    public var functionMethodInstance: FunctionMethodSubstructure {
        precondition(kind == .FunctionMethodInstance)
        return FunctionMethodSubstructure(substructure: rawSubstructure)
    }

    public var functionMethodClass: FunctionMethodSubstructure {
        precondition(kind == .FunctionMethodClass)
        return FunctionMethodSubstructure(substructure: rawSubstructure)
    }

    public var functionMethodStatic: FunctionMethodSubstructure {
        precondition(kind == .FunctionMethodStatic)
        return FunctionMethodSubstructure(substructure: rawSubstructure)
    }

    public var varInstance: VarSubstructure {
        precondition(kind == .VarInstance)
        return VarSubstructure(substructure: rawSubstructure)
    }

    public var varClass: VarSubstructure {
        precondition(kind == .VarClass)
        return VarSubstructure(substructure: rawSubstructure)
    }

    public var varStatic: VarSubstructure {
        precondition(kind == .VarStatic)
        return VarSubstructure(substructure: rawSubstructure)
    }

    public enum Kind: String {
        case Class = "source.lang.swift.decl.class"

        case FunctionMethodInstance = "source.lang.swift.decl.function.method.instance"
        case FunctionMethodClass = "source.lang.swift.decl.function.method.class"
        case FunctionMethodStatic = "source.lang.swift.decl.function.method.static"
        case VarInstance = "source.lang.swift.decl.var.instance"
        case VarClass = "source.lang.swift.decl.var.class"
        case VarStatic = "source.lang.swift.decl.var.static"
    }
}
