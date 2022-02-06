import Foundation

// https://qiita.com/mshrwtnb/items/2f947eb8422899b84dbc
public struct GenericProtocolSample {
    public static func main() {
        print("ジェネリックプロトコル（Generic Protocol）入門 - associatedtype, typealias, Self")
        
        let c1 = Cat()
        let c2 = Cat()
        let m = Mouse()
        c1.eat(food: m)
        c1.makeFriend(friend: c2)
    }
}

protocol AnimalP {
    associatedtype FoodType
    func eat(food: FoodType)
    func makeFriend(friend: Self)
}

struct Mouse {
    
}

struct Cat: AnimalP {
    // @see https://docs.swift.org/swift-book/LanguageGuide/Generics.html
    // Thanks to Swift’s type inference, you don’t actually need to declare a concrete Item of Int as part of the definition of IntStack. Because IntStack conforms to all of the requirements of the Container protocol, Swift can infer the appropriate Item to use, simply by looking at the type of the append(_:) method’s item parameter and the return type of the subscript. Indeed, if you delete the typealias Item = Int line from the code above, everything still works, because it’s clear what type should be used for Item.
    // ↓の一行がなくてもFoodType = Mouseが自明なので動作する。
    // Swiftがコンパイル時に型推論してるから
    typealias FoodType = Mouse
    func eat(food: Mouse) {
        print("yum")
    }
    func makeFriend(friend: Cat) {
        print("Hello Friend!")
    }
}
