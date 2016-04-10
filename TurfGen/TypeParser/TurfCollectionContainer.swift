func isTurfCollectionContainer(substructure substructure: ClassSubstructure) -> Bool {
    return (substructure.inheritedTypes.contains("Turf.CollectionsContainer") || substructure.inheritedTypes.contains("CollectionsContainer"))
        && substructure.annotatedDeclaration.containsString("Turf")
}

func handle(collectionsContainer substructure: ClassSubstructure) {
    guard isTurfCollectionContainer(substructure: substructure) else { return }

    for property in substructure.instanceVars {
        print(property.name)
    }

//    turfCollectionContainers[substructure.usr] = substructure
//    turfRelatedTypeInfo[substructure.usr] = substructure
}
