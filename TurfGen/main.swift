import SourceKittenFramework

let discoveredTurfTypes = parseModule(xcodeBuildArguments: [], moduleName: nil)
let collectionUsrs = discoveredTurfTypes.collections.map { return $0.0 }

for (usr, container) in discoveredTurfTypes.containers {
    let transformed = CollectionsContainerTransformer.transform(container, turfCollectionUsrs: collectionUsrs, accessibility: "internal")

    print(transformed)
}
