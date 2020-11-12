import XCTest
@testable import ServiceLocator

final class ServiceLocatorTests: XCTestCase {
    func testRegisterAndResolveRefType() {
        let locator = ServiceLocator()

        let bar = Bar()
        locator.register { bar as Foo }

        let returned = locator.resolve(Foo.self) as! Bar
        XCTAssertTrue(bar === returned)
    }

    func testRegisterAndResolveValueType() {
        let locator = ServiceLocator()

        let baz = Baz()
        locator.register { baz as Foo }

        let returned = locator.resolve(Foo.self) as! Baz
        XCTAssertEqual(baz, returned)
    }

    func testFactoryShouldBeCalledOnlyOnce() {
        let locator = ServiceLocator()

        var count = 0
        locator.register { () -> Foo in
            count += 1
            return Bar()
        }

        let foo = locator.resolve(Foo.self) as! Bar
        let foo2 = locator.resolve(Foo.self) as! Bar

        XCTAssertEqual(count, 1)
        XCTAssertTrue(foo === foo2)
    }

    func testResolvingTwiceShouldReturnSameObject() {
        let locator = ServiceLocator()
        locator.register { Bar() as Foo }

        let resolved1 = locator.resolve(Foo.self) as! Bar
        let resolved2 = locator.resolve(Foo.self) as! Bar

        XCTAssertTrue(resolved1 === resolved2)
    }

    func testResolvingNotRegisteredServiceShouldReturnNil() {
        let locator = ServiceLocator()
        XCTAssertNil(locator.optional(Foo.self))
    }

    func testRegisterWithName() {
        let locator = ServiceLocator()

        let bar = Bar()
        let foo = Bar()
        locator.register(name: .bar) { bar as Foo }
        locator.register(name: .foo) { foo as Foo }

        let returnedBar = locator.resolve(Foo.self, name: .bar) as! Bar
        let returnedFoo = locator.resolve(Foo.self, name: .foo) as! Bar

        XCTAssertTrue(bar === returnedBar)
        XCTAssertTrue(foo === returnedFoo)
    }

    func testStoreHoldsWeakReferenceOfInstance() {
        let locator = ServiceLocator()

        locator.register { Bar() as Foo }

        var instance = locator.resolve(Foo.self) as? Bar
        var sameInstance = locator.resolve(Foo.self) as? Bar

        XCTAssertTrue(instance === sameInstance)
        XCTAssertEqual(instance?.value, 0)
        instance?.value = 1
        XCTAssertEqual(instance?.value, 1)

        instance = nil
        sameInstance = nil

        let otherInstance = locator.resolve(Foo.self) as! Bar
        XCTAssertEqual(otherInstance.value, 0)
    }
}

protocol Foo {}

class Bar: Foo {
    var value = 0
}

struct Baz: Foo, Equatable {
    let id = UUID()
}

extension ServiceLocator.Name {
    static let foo = ServiceLocator.Name(rawValue: "foo")
    static let bar = ServiceLocator.Name(rawValue: "bar")
}
