func findTurfCollectionTypes(substructure substructure: Substructure) -> (containers: [String: ClassSubstructure], collections: [String: ClassSubstructure]) {
    guard let kind = substructure.kind else { return ([:], [:]) }

    var turfCollections = [String: ClassSubstructure]()
    var turfCollectionContainers = [String: ClassSubstructure]()

    switch kind {
    case .Class:
        let classSubstructure = substructure.classSubstructure
        if isTurfCollectionContainer(substructure: classSubstructure) {
            turfCollectionContainers[classSubstructure.usr] = classSubstructure
        } else if isTurfCollection(substructure: classSubstructure) {
            turfCollections[classSubstructure.usr] = classSubstructure
        }

        let discovered = findTurfCollectionTypes(substructures: toSubstructures(substructure.rawSubstructure))
        turfCollections += discovered.collections
        turfCollectionContainers += discovered.containers
    default:
        findTurfCollectionTypes(substructures: toSubstructures(substructure.rawSubstructure))
        //<Declaration>let people: <Type usr=\"s:C4Test16PeopleCollection\">PeopleCollection</Type></Declaration>
        //<Declaration>func setUpCollections(transaction transaction: <Type usr=\"s:C4Turf20ReadWriteTransaction\">ReadWriteTransaction</Type>
        //<Declaration>final class Collections : <Type usr=\"s:P4Turf20CollectionsContainer\">CollectionsContainer</Type></Declaration>
    }

    return (turfCollectionContainers, turfCollections)
}

func findTurfCollectionTypes(substructures substructures: [Substructure]) -> (containers: [String: ClassSubstructure], collections: [String: ClassSubstructure]) {

    var turfCollections = [String: ClassSubstructure]()
    var turfCollectionContainers = [String: ClassSubstructure]()

    for substructure in substructures {
        let discovered = findTurfCollectionTypes(substructure: substructure)
        turfCollections += discovered.collections
        turfCollectionContainers += discovered.containers
    }

    return (turfCollectionContainers, turfCollections)
}
