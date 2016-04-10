import SourceKittenFramework

public class FunctionMethodSubstructure: CustomDebugStringConvertible {
    // MARK: Object lifecycle

    public init(substructure: [String: SourceKitRepresentable]) {
        self.rawSubstructure = substructure
    }

    public var debugDescription: String {
        return name
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

    public var accessibility: Accessibility {
        return rawSubstructure["key.accessibility"].flatMap { Accessibility(rawValue: $0 as! String) } ?? .Internal
    }

    public var attributes: [String] {
        let rawAttributes = rawSubstructure["key.attributes"] as! [SourceKitRepresentable]
        return rawAttributes.map { rawAttribute in
            return (rawAttribute as! [String: String])["key.attribute"]!
        }
        
    }
}
