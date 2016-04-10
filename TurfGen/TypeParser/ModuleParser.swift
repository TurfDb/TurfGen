import SourceKittenFramework

func parseModule(xcodeBuildArguments xcodeBuildArguments: [String], moduleName: String?) -> (containers: [String: ClassSubstructure], collections: [String: ClassSubstructure]) {
    guard let m = Module(xcodeBuildArguments: xcodeBuildArguments, name: moduleName, inPath: "/Users/jordanhamill/Documents/Projects/TurfDb/Test") else {
        print("Could not load module")
        return ([:], [:])
    }

    print("Parsing module \(m.name) for Turf collections")

    var turfCollections = [String: ClassSubstructure]()
    var turfCollectionContainers = [String: ClassSubstructure]()

    for doc in m.docs {
        let substructures = toSubstructures(doc.docsDictionary)
        let discovered = findTurfCollectionTypes(substructures: substructures)

        turfCollections += discovered.collections
        turfCollectionContainers += discovered.containers
    }

    return (turfCollectionContainers, turfCollections)
}
