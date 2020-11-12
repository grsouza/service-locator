# ServiceLocator
![CI](https://github.com/grsouza/service-locator/workflows/CI/badge.svg)

Lightweight service locator implementation in Swift

## Installation

`ServiceLocator` is distributed using [Swift Package Manager](https://swift.org/package-manager/). To install it into a project, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        .package(name: "ServiceLocator", url: "https://github.com/grsouza/service-locator.git", from: "1.0.0")
    ],
    ...
)
```

## Usage

`ServiceLocator` is a Swift implementation of service locator pattern.

```swift
protocol MyServiceProtocol {}

class MyServiceImpl: MyServiceProtocol {}

// Register your services
ServiceLocator.register { MyServiceImpl() as MyServiceProtocol }

// Then, when you need an instance of MyServiceProtocol, just resolve it.
let service = ServiceLocator.resolve(MyServiceProtocol.self)

// Or use a propertyWrapper instead
@Locate var service: MyServiceProtocol
```

These are the basic usages of the library, take a look at [full documentation](Documentation.md).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](LICENSE)
