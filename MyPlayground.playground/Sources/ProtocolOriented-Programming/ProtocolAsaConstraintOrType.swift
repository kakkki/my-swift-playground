import Foundation

public struct ProtocolAsaConstraintOrType {
    public static func main() {
        Logger.makeBorder { ProtocolAsaTypeOnlyCanDo.main() }
        Logger.makeBorder { SwiftProtocolHasNotSelfConformance.main() }
        Logger.makeBorder { HeterogeneousCollectionExample.main() }
        Logger.makeBorder { ProtocolAsaConstraintOnlyCanDo.main() }
    }
}

struct ProtocolAsaTypeOnlyCanDo {
 
//    static func useAnimals(_ animals: [Animal]) {
//        print(animals)
//    }

    // CatとDogが混在したHeterogeneousなArrayを渡すことができない
    // CatかDogだけのHomogeneousなArrayなら渡せる
    static func useAnimals<A: Animal>(_ animals:[A]) {
        print(animals)
    }
    
    struct Cat: Animal {
        var value: UInt = 2 // 1Byte
        func foo() -> Int { 2 }
    }
    
    struct Dog: Animal {
        var value: Int32 = 1 // 4Byte
        func foo() -> Int { 1 }
    }

    static func main() {
        print("型としてのプロトコルでしかできないこと")
        useAnimals([Cat(), Cat()])
        print("-------")
        useAnimals([Dog(), Dog()])
        print("-------")
//        useAnimals([Cat(), Dog()]) // compile error
        
        print("Heterogeneous Collection が必要な場合には、プロトコルを制約として使うのではなく型として使う 必要がある")
    }
}

struct SwiftProtocolHasNotSelfConformance {
    
    struct Cat: Animal {
        func foo() -> Int { 2 }
    }
    
    static func useAnimal<A: Animal>(_ animal: A) {
//        print(A.foo()) // compile error
        print("AがAnimalのとき、Animal.foo()には具体的な実装がないので、")
        // AがAnimalのとき、Animal.foo()には具体的な実装がないので、
    }
    
    static func main() {
        print("型パラメータ A に Animal を当てはめられない理由")
        
        print("プロトコル型がそのプロトコル自体に適合することを Self-conformance と言う")
        print("一般的な Swift のプロトコルは Self-conformanceを持たない。(Errorだけ例外)")
    }
}

// 型としてのプロトコル
protocol ViewAsaType {
    var subBviews: [ViewAsaType] { get } // 👈 ここで「型として」使われている
}

// 制約としてのプロトコル
protocol ViewAsaConstraint {
    associatedtype Subview: ViewAsaConstraint
    var subviews: [Subview] { get }  // 👈 ここで「制約として」使われている
}

struct HeterogeneousCollectionExample {
 
    struct ViewGroupType: ViewAsaType {
        var subBviews: [ViewAsaType]
    }
    
    struct LabelType: ViewAsaType {
        var subBviews: [ViewAsaType]
    }
    
    struct ButtonType: ViewAsaType {
        var subBviews: [ViewAsaType]
    }
    
    // 制約としてのプロトコル
    struct ViewGroupConstraint<Subview: ViewAsaConstraint>: ViewAsaConstraint {
        var subviews: [Subview]
    }
    
    static func main() {
        print("Heterogeneous Collection の具体例")
        let viewGroupTypes = ViewGroupType(subBviews: [
            LabelType(subBviews: []),
            ButtonType(subBviews: [])
        ])
        
        print("ちょっとよくわかっていない")
        print("Generalized Existential と型消去")
        print("Generalized Existentialは、associatedtype を持ったプロトコルで表される型のことだが、現状サポートされてない")
        print("型としてのプロトコルが必要な時のワークアラウンドがType Eraser(型消去)")
        print("例えばSwiftUIのViewはassociatedType Bodyがあるため型として使えないが、AnyViewでこう書ける")
        print("let views: [AnyView] = [AnyView(Text(\"...\")), AnyView(Image(\"...\"))] // ✅")
    }
}

struct ProtocolAsaConstraintOnlyCanDo {

/**
    Self-requirementを持つプロトコルの一例
    public protocol Equatable {
        static func == (
            lhs: Self,
            rhs: Self
        ) -> Bool
    }
 */
    
    static func main() {
        print("制約としてのプロトコルでしかできないこと")
        // Self-requirement を持つプロトコルは型としては使用せず、制約として使うことだけが想定されている
        // Protocol 'Equatable' can only be used as a generic constraint because it has Self or associated type requirements
        // Self-requirement を持つProtocolは、型として利用することはできない
        // 型として利用できるようにしてしまうと、例えば以下のようなIntとStringを比較する==が必要になる
        // コンパイルエラーで弾くために、型として利用できることをSwfitは認めてない
//        let a: Equatable = 42
//        let b: Equatable = "42"
//        a == b
    }
}
