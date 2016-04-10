func isTurfCollection(substructure substructure: ClassSubstructure) -> Bool {
    return (substructure.inheritedTypes.contains("Turf.Collection") || substructure.inheritedTypes.contains("Collection"))
        && substructure.annotatedDeclaration.containsString("Turf")
}
