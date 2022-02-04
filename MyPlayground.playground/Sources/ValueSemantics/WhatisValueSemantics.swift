import Foundation

public struct WhatisValueSemantics {
    public static func main() {
        Logger.makeBorder { ValueTypeHasValueSemantics.main() }
        Logger.makeBorder { ReferenceTypeHasnotValueSemantics.main() }
        Logger.makeBorder { ValueTypeButHasnotValueSemantics.main() }
        Logger.makeBorder { HasReferenceTypePropertyButHasValueSemantics.main() }
    }
}

struct ValueTypeHasValueSemantics {
    struct Foo {
        var value: Int = 0
    }

    static func main() {
        print("Value Semanticsを持つ例")
        
        var a = Foo()
        var b = a
        a.value = 2
        print("a.value : \(a.value)")
        print("b.value : \(b.value)")
        print("Fooはstructのため値型")
        print("なのでvar b = a をした時点で、aとbは別々のインスタンス")
    }
}

struct ReferenceTypeHasnotValueSemantics {
    class Foo {
        var value: Int = 0
    }
    
    static func main() {
        print("Value Semanticsを持たない例")

        var a = Foo()
        var b = a
        a.value = 2
        print("a.value : \(a.value)")
        print("b.value : \(b.value)")
        print("Fooはclassのため参照型")
        print("なのでvar b = a をした時点で、aとbは同じインスタンス")
    }
}

struct ValueTypeButHasnotValueSemantics {
    class Bar {
        var value: Int = 0
    }
    struct Foo {
        var value: Int = 0
        var bar: Bar = Bar()
    }
    static func main() {
        print("値型だけど Value Semantics を持たない例")
        var a = Foo()
        var b = a
        a.value = 2
        a.bar.value = 3
        
        // a.value is 2
        // a.bar.value is 3
        // b.value is 0
        // b.bar.value is 3
        print("a.value : \(a.value)")
        print("a.bar.value : \(a.bar.value)")
        print("b.value : \(b.value)")
        print("b.bar.value : \(b.bar.value)")
    }
}

struct HasReferenceTypePropertyButHasValueSemantics {
    final class Bar {
        let value: Int = 0 // イミュータブルでValue Semanticsを維持
    }
    struct Foo {
        var value: Int = 0
        var bar: Bar = Bar()
    }

    static func main() {
        print("参照型プロパティを持つ値型でも Value Semantics を持つ例")
        var a = Foo()
        var b = a
        a.value = 2
//        a.bar.value = 3 // compile error
        print("a.value : \(a.value)")
        print("a.bar.value : \(a.bar.value)")
        print("b.value : \(b.value)")
        print("b.bar.value : \(b.bar.value)")
    }
}
