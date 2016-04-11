import SourceKittenFramework

public class ClassSubstructure: CustomDebugStringConvertible {
    // MARK: Object lifecycle

    public init(substructure: [String: SourceKitRepresentable]) {
        self.rawSubstructure = substructure
    }

    public var debugDescription: String {
        var temp = rawSubstructure
        temp["key.substructure"] = nil
        return "\(temp)"
    }

    public var instanceFunctionMethods: [FunctionMethodSubstructure] {
        return substructures.filter { substructure in
            return substructure.kind == .FunctionMethodInstance
            }.map { substructure in
                return substructure.functionMethodInstance
        }
    }

    public var classFunctionMethods: [FunctionMethodSubstructure] {
        return substructures.filter { substructure in
            return substructure.kind == .FunctionMethodClass
            }.map { substructure in
                return substructure.functionMethodClass
        }
    }

    public var staticFunctionMethods: [FunctionMethodSubstructure] {
        return substructures.filter { substructure in
            return substructure.kind == .FunctionMethodStatic
            }.map { substructure in
                return substructure.functionMethodStatic
        }
    }

    public var instanceVars: [VarSubstructure] {
        return substructures.filter { substructure in
            return substructure.kind == .VarInstance
            }.map { substructure in
                return substructure.varInstance
        }
    }

    public var classVars: [VarSubstructure] {
        return substructures.filter { substructure in
            return substructure.kind == .VarClass
            }.map { substructure in
                return substructure.varClass
        }
    }

    public var staticVars: [VarSubstructure] {
        return substructures.filter { substructure in
            return substructure.kind == .VarStatic
            }.map { substructure in
                return substructure.varStatic
        }
    }

    // MARK: Raw

    public let rawSubstructure: [String: SourceKitRepresentable]

    public var substructures: [Substructure] {
        return toSubstructures(rawSubstructure)
    }

    public var offset: Int {
        return rawSubstructure["key.offset"] as! Int
    }

    public var nameLength: Int {
        return rawSubstructure["key.namelength"] as! Int
    }

    public var bodyOffset: Int {
        return rawSubstructure["key.bodyoffset"] as! Int
    }

    public var bodyLength: Int {
        return rawSubstructure["key.bodylength"] as! Int
    }

    public var length: Int {
        return rawSubstructure["key.length"] as! Int
    }

    public var name: String {
        return rawSubstructure["key.name"] as! String
    }

    public var nameOffset: Int {
        return rawSubstructure["key.nameoffset"] as! Int
    }

    public var inheritedTypes: [String] {
        guard let array = rawSubstructure["key.inheritedtypes"] as? [SourceKitRepresentable] else { return [] }
        return array.flatMap { element in
            guard let dict = element as? [String: SourceKitRepresentable] else { return nil }
            return dict["key.name"] as? String
        }
    }

    public var accessibility: Accessibility {
        return rawSubstructure["key.accessibility"].flatMap { Accessibility(rawValue: $0 as! String) } ?? .Internal
    }

    public var annotatedDeclaration: String {
        return rawSubstructure["key.annotated_decl"] as! String
    }

    public var usr: String {
        return rawSubstructure["key.usr"] as! String
    }

    public var typename: String {
        return rawSubstructure["key.typename"] as! String
    }

    public var runtimeName: String {
        return rawSubstructure["key.runtime_name"] as! String
    }

    public var elements: [SourceKitRepresentable] {
        return rawSubstructure["key.elements"] as! [SourceKitRepresentable]
        /*
         [["key.kind": "source.lang.swift.structure.elem.typeref",
         "key.offset": 70,
         "key.length": 10]]]
         */
    }
}
