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
    typealias FoodType = Mouse
    func eat(food: Mouse) {
        print("yum")
    }
    func makeFriend(friend: Cat) {
        print("Hello Friend!")
    }
}
