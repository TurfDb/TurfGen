import SourceKittenFramework

class CollectionsContainerTransformer {
//    static let template = try! Template(named: "ReadWrite")

    class func transform(collectionsContainer: ClassSubstructure, turfCollectionUsrs: [String], accessibility: String) -> String {
        let containerName = collectionsContainer.name

        var templateVariables: [String: AnyObject] = [
            "version": "0.1.0",
            "containerTypeName": containerName,
            "readWriteContainerTypeName": "ReadWrite\(containerName.uppercaseFirst)",
            "accessibility": "\(accessibility) ",
            // Extensions cannot be constrained to concrete types, only protocols. "Same-type requirement makes generic parameter non-generic"
            "collectionsContainerProtocolName": "_Turf\(containerName.uppercaseFirst)",
            ]

        let collections = collectionsContainer.instanceVars.map { property in
            return [
                "name": property.name,
                "typeName": property.typeName
            ]
        }

        templateVariables["collections"] = collections
//        print(try! template.render(Box(templateVariables)))
        print(templateVariables)
        return ""
    }
}

