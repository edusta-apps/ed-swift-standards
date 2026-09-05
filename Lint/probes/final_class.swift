// Probe fixture for the `final_class` custom rule.

// TRUE POSITIVE: bare class.
class BareThing {}

// TRUE POSITIVE: public class, no final.
public class PublicThing {}

// TRUE POSITIVE: package class was previously missed.
package class PackageThing {}

// FALSE POSITIVE CHECK: class func / class var are member modifiers, not a type declaration.
// (Utility itself is already `final` so only the two member lines below are under test.)
final class Utility {
    class func makeOne() -> Utility { Utility() }
    class var shared: Utility { Utility() }
}

// FALSE POSITIVE CHECK: already final.
final class FinalThing {}

// FALSE POSITIVE CHECK: public final.
public final class PublicFinalThing {}

// FALSE POSITIVE CHECK: open class is allowed.
open class OpenThing {}
