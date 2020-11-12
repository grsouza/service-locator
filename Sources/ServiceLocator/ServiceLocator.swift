import ThreadSafe

public final class ServiceLocator {

    public static var main = ServiceLocator()

    public typealias Factory<Service> = () -> Service

    public init() {}

    // MARK: - Static Methods

    public static func register<Service>(
        _ metaType: Service.Type = Service.self,
        name: Name? = nil,
        factory: @escaping Factory<Service>
    ) {
        ServiceLocator.main.register(metaType, name: name, factory: factory)
    }

    public static func resolve<Service>(
        _ metaType: Service.Type = Service.self,
        name: Name? = nil
    ) -> Service {
        ServiceLocator.main.resolve(metaType, name: name)
    }

    public static func optional<Service>(
        _ metaType: Service.Type = Service.self,
        name: Name? = nil
    ) -> Service? {
        ServiceLocator.main.optional(metaType, name: name)
    }

    // MARK: - Public

    public func register<Service>(
        _ metaType: Service.Type = Service.self,
        name: Name? = nil,
        factory: @escaping Factory<Service>
    ) {
        let key = makeKey(forMetaType: metaType, name: name?.rawValue)

        mutableState.write {
            precondition(
                $0.factories[key] == nil,
                "Service of type '\(metaType)' registered twice with the key '\(key)'."
            )
            $0.factories[key] = factory
        }
    }

    public func resolve<Service>(
        _ metaType: Service.Type = Service.self,
        name: Name? = nil
    ) -> Service {
        let key = makeKey(forMetaType: metaType, name: name?.rawValue)

        guard let instance = optional(metaType, name: name) else {
            fatalError("Could not find instance of type \(metaType) with key \(key), maybe you forgot to register it.")
        }

        return instance
    }

    public func optional<Service>(
        _ metaType: Service.Type = Service.self,
        name: Name? = nil
    ) -> Service? {
        let key = makeKey(forMetaType: metaType, name: name?.rawValue)

        return mutableState.write {
            if let instance = $0.instances[key]?.value as? Service {
                return instance
            }

            if let factory = $0.factories[key] as? Factory<Service> {
                let instance = factory()
                $0.instances[key] = Weak(instance as AnyObject)
                return instance
            }

            return nil
        }
    }


    // MARK: - Private

    private struct MutableState {
        var factories: [String: Any] = [:]
        var instances: [String: Weak] = [:]
    }

    private var mutableState = ThreadSafe(value: MutableState())

    private func makeKey<Service>(forMetaType metaType: Service.Type, name: String?) -> String {
        if let name = name {
            return "\(metaType)-\(name)"
        }

        return "\(metaType)"
    }
}

extension ServiceLocator {
    public struct Name: RawRepresentable {
        public var rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

private extension ServiceLocator {
    class Weak {
        weak var value: AnyObject?

        init(_ value: AnyObject) {
            self.value = value
        }
    }
}
