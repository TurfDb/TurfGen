extension String {
    var first: String {
        return String(characters.prefix(1))
    }

    var uppercaseFirst: String {
        return first.uppercaseString + String(characters.dropFirst())
    }
}
