import SourceKittenFramework

func isTurfCollectionContainer(substructure substructure: ClassSubstructure) -> Bool {
    return (substructure.inheritedTypes.contains("Turf.CollectionsContainer") || substructure.inheritedTypes.contains("CollectionsContainer"))
        && substructure.annotatedDeclaration.containsString("Turf")
}

func isTurfCollection(substructure substructure: ClassSubstructure) -> Bool {
    return (substructure.inheritedTypes.contains("Turf.Collection") || substructure.inheritedTypes.contains("Collection"))
        && substructure.annotatedDeclaration.containsString("Turf")
}


var turfRelatedTypeInfo = [String: ClassSubstructure]()
var turfCollectionContainers = [String: ClassSubstructure]()

func handle(collectionsContainer substructure: ClassSubstructure) {
    guard isTurfCollectionContainer(substructure: substructure) else { return }

    for property in substructure.instanceVars {
        print(property.name)
    }

    turfCollectionContainers[substructure.usr] = substructure
    turfRelatedTypeInfo[substructure.usr] = substructure
}

func handle(collection substructure: ClassSubstructure) {
    guard isTurfCollection(substructure: substructure) else { return }

    turfRelatedTypeInfo[substructure.usr] = substructure
}

func handle(substructure substructure: Substructure) {
    guard let kind = substructure.kind else { return }
    switch kind {
    case .Class:
        let classSubstructure = substructure.classSubstructure
        if isTurfCollectionContainer(substructure: classSubstructure) {
            handle(collectionsContainer: classSubstructure)
        } else if isTurfCollection(substructure: classSubstructure) {
            handle(collection: classSubstructure)
        }

        handle(substructures: toSubstructures(substructure.rawSubstructure))
    default:
        handle(substructures: toSubstructures(substructure.rawSubstructure))
        //<Declaration>let people: <Type usr=\"s:C4Test16PeopleCollection\">PeopleCollection</Type></Declaration>
        //<Declaration>func setUpCollections(transaction transaction: <Type usr=\"s:C4Turf20ReadWriteTransaction\">ReadWriteTransaction</Type>
        //<Declaration>final class Collections : <Type usr=\"s:P4Turf20CollectionsContainer\">CollectionsContainer</Type></Declaration>
    }
}

func handle(substructures substructures: [Substructure]) {
    for substructure in substructures {
        handle(substructure: substructure)
    }
}


let m = Module(xcodeBuildArguments: [], name: nil, inPath: "/Users/jordanhamill/Documents/Projects/TurfDb/Test")
print(m?.name)

for doc in m!.docs {
    let substructures = toSubstructures(doc.docsDictionary)
    handle(substructures: substructures)
}

//print(turfRelatedTypeInfo.keys)
print(turfCollectionContainers.map({ (name, klass)  in
    return klass.name
}))
