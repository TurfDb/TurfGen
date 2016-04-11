import Mustache
import SourceKittenFramework

class CollectionsContainerTransformer {
    static let template = try! Template(named: "ReadWrite")

    class func transform(collectionsContainer: ClassSubstructure, turfCollectionUsrs: [String], accessibility: String) -> String {
        var containerName = collectionsContainer.typename
        if containerName.hasSuffix(".Type") {
            let index = containerName.endIndex.advancedBy(-".Type".characters.count)
            containerName = containerName.substringToIndex(index)
        }

        let safeContainerName = containerName.stringByReplacingOccurrencesOfString(".", withString: "_")
        var templateVariables: [String: AnyObject] = [
            "version": "0.1.0",
            "containerTypeName": containerName,
            "safeContainerTypeName": safeContainerName,
            "readWriteContainerTypeName": "ReadWrite\(safeContainerName.uppercaseFirst)",
            "readOnlyContainerTypeName": "ReadOnly\(safeContainerName.uppercaseFirst)",
            "accessibility": "\(accessibility) ",
            // Extensions cannot be constrained to concrete types, only protocols. "Same-type requirement makes generic parameter non-generic"
            "collectionsContainerProtocolName": "_Turf\(safeContainerName.uppercaseFirst)",
            ]

        let collections = collectionsContainer.instanceVars.map { property in
            return [
                "name": property.name,
                "typeName": property.typeName
            ]
        }

        templateVariables["collections"] = collections
        return try! template.render(Box(templateVariables))
    }
}

