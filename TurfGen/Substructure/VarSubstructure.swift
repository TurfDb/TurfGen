import SourceKittenFramework

public class VarSubstructure: CustomDebugStringConvertible {
    // MARK: Object lifecycle

    public init(substructure: [String: SourceKitRepresentable]) {
        self.rawSubstructure = substructure
    }

    public var debugDescription: String {
        return "\(name): \(typeName)"
    }

    public var isReadOnly: Bool { return setterAccessibility != nil }

    // MARK: Raw

    public let rawSubstructure: [String: SourceKitRepresentable]

    public var substructures: [Substructure] {
        return toSubstructures(rawSubstructure)
    }

    public var offset: Int64 {
        return rawSubstructure["key.offset"] as! Int64
    }

    public var nameLength: Int {
        return rawSubstructure["key.namelength"] as! Int
    }

    public var bodyOffset: Int64 {
        return rawSubstructure["key.bodyoffset"] as! Int64
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

    public var nameOffset: Int64 {
        return rawSubstructure["key.nameoffset"] as! Int64
    }

    public var accessibility: Accessibility {
        return rawSubstructure["key.accessibility"].flatMap { Accessibility(rawValue: $0 as! String) } ?? .Internal
    }

    public var attributes: [String] {
        let rawAttributes = rawSubstructure["key.attributes"] as! [SourceKitRepresentable]
        return rawAttributes.map { rawAttribute in
            return (rawAttribute as! [String: String])["key.attribute"]!
        }
    }

    public var typeName: String {
        return rawSubstructure["key.typename"] as! String
    }

    public var setterAccessibility: Accessibility? {
        return rawSubstructure["key.setter_accessibility"].flatMap { Accessibility(rawValue: $0 as! String) }
    }
}
