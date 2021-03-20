extension Array {
    func onlyType<T>() -> Array<T> {
        var result: [T] = []
        for e in self {
            if let c = e as? T {
                result.append(c)
            }
        }
        return result
    }
}

public func decodeJson<T: Decodable>(_ string: String) -> T? {
    guard let inputData = string.data(using: .utf8) else {
        return nil
    }
    do {
        return try JSONDecoder().decode(T.self, from: inputData)
    } catch {
        return nil
    }
}

public func encodeJson<T: Codable>(_ value: T) -> String? {
    do {
        return String(data: try JSONEncoder().encode(value), encoding: .utf8)
    } catch {
        return nil
    }
}