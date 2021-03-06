#if !canImport(ObjectiveC)
import XCTest

extension ServiceLocatorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ServiceLocatorTests = [
        ("testFactoryShouldBeCalledOnlyOnce", testFactoryShouldBeCalledOnlyOnce),
        ("testRegisterAndResolveRefType", testRegisterAndResolveRefType),
        ("testRegisterAndResolveValueType", testRegisterAndResolveValueType),
        ("testRegisterWithName", testRegisterWithName),
        ("testResolvingNotRegisteredServiceShouldReturnNil", testResolvingNotRegisteredServiceShouldReturnNil),
        ("testResolvingTwiceShouldReturnSameObject", testResolvingTwiceShouldReturnSameObject),
        ("testStoreHoldsWeakReferenceOfInstance", testStoreHoldsWeakReferenceOfInstance),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ServiceLocatorTests.__allTests__ServiceLocatorTests),
    ]
}
#endif
