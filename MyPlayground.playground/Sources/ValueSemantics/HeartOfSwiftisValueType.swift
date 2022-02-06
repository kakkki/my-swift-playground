import Foundation

public struct HeartOfSwiftisValueType {
    public static func main() {
        Logger.makeBorder { CollectionisAlsoValueTypes.main() }
        Logger.makeBorder { SafetyInoutArgument.main() }
        Logger.makeBorder { CompareMethodWithFunction.main() }
        Logger.makeBorder { MutatingFunction.main() }
        Logger.makeBorder { UpdateViaComputedProperty.main() }
        Logger.makeBorder { UpdateEachElementValueInCollection.main() }
        Logger.makeBorder { HigherOrderFunctionAndInoutArgument.main() }
        Logger.makeBorder { SummaryValueTypesAndMutableClass.main() }
    }
}

struct CollectionisAlsoValueTypes {
    static func main() {
        print("Swift の標準ライブラリはコレクションも値型")
        print("他の多くの言語では、コレクションは参照型")
        var a = [2, 3, 4]
        var b = a
        a[2] = 5
        print("a : \(a)")
        print("b : \(b)")
        
        let c = Array(1...1000)
        print("c.reduce(0, +) : \(c.reduce(0, +)) // Copy-On-Writeの仕組みで不必要にコピーされない")
    }
}


struct SafetyInoutArgument {
    struct User {
        var name: String
        var points: Int
    }

    static func main() {
        print("安全な inout 引数")
        print("inoutは関数で使う")
        var user = User(name: "sorita", points: 300)
        print("user.points : \(user.points)")
        consumePoints(100, of: &user)
        print("user.points : \(user.points)")
    }
    
    // 関数
    static func consumePoints(_ points: Int, of user: inout User) {
        guard user.points >= points else {
            return // NO-OP
        }
        user.points -= points
    }
}

struct CompareMethodWithFunction {
    static func main() {
        print("関数とメソッドの関係")
        let foo = Foo()
        bar(foo, 42)
        
        foo.bar(42)
    }
    
    struct Foo {
        var value: Int = 10
        
        func bar(_ x: Int) {
            print("メソッドの場合は、fooが暗黙的な引数 self としてbarメソッドに渡されている")
            print("メソッドは暗黙的な `self` を持つ関数")
            print(self.value + x)
        }
    }
    
    static func bar(_ self: Foo, _ x: Int) {
        print(self.value + x)
    }
}

struct MutatingFunction {
    struct User {
        var name: String
        var points: Int
        
//        func consumePoints(_ points: Int) {
//            guard self.points >= points else {
//                return
//            }
//            // left side of mutating operator isn't mutable. `self` is immutable
//            self.points -= points
//        }
        
        // メソッド
        mutating func consumepoints(_ points: Int) {
            guard self.points >= points else {
                return
            }
            self.points -= points
        }
    }
    
    static func main() {
        print("mutating func")
        print("mutatingはメソッドで使う")
        print("mutating を付与することは、暗黙の引数 self に inout を付けるのと同じ意味を持つ")
        var user = User(name: "sorita", points: 300)
        print("user.points : \(user.points)")
        user.consumepoints(100)
        print("user.points : \(user.points)")
                
//        let owner = User(name: "owner", points: 200)
//        owner.consumepoints(100) // compile error
        print("定数に対してはmutating func を呼び出せない")
    }
}

struct UpdateViaComputedProperty {
    struct User {
        var name: String
        var points: Int
    }
    
    struct Group {
        var members: [User]
        
        // Computed Property
        var owner: User {
            get {
                print("owner get members[0] : \(members[0])")
                return members[0]
            }
            set {
                print("owner set newValue : \(newValue)")
                members[0] = newValue
            }
        }
        
        func hoge() -> User {
            return members[0]
        }
    }
    
    static func main() {
        print("Computed Propertyを介した変更")
        
        var group = Group(members: [
            User(name: "Sorita", points: 300)
        ])
        group.owner.points = 0
//        group.hoge().points = 0 // compile error
        print("Computed Propertyはプロパティのフリしたメソッドのようなもの")
        print("メソッドだとしたらmutatingのような修飾子もなく、値を更新できるのは不自然")
        print("理由は、group.owner.points = 0の間にgetとsetの両方が順番に実行されるから")
    }
}

struct UpdateEachElementValueInCollection {
    
    struct User {
        var name: String
        var points: Int
    }

    static func main() {
        print("高階関数と inout 引数の組み合わせ 1")
        
        var users: [User] = [
            User(name: "userA", points: 100),
            User(name: "userB", points: 200),
            User(name: "userC", points: 300),
        ]
        
//        for user in users {
//             for文の中でuserは定数となる
//            user.points += 100 // compile error
//        }
        
        for var user in users {
            user.points += 100 // コンパイルが通り、実行しても何も起こらない😵
        }
        print("コンパイルが通り、実行しても何も起こらない😵")
        print("var userしてもusersに対してValue Semanticsで、オリジナルには更新は反映されない")
        print(users)
        
        for i in users.indices {
            users[i].points += 100
        }
        print("コンパイルが通り、変更も反映される✅")
        print(users)

    }
}

struct HigherOrderFunctionAndInoutArgument {
    static func main() {
        print("高階関数と inout 引数の組み合わせ 2")
        // modifyEachの話
        // reduceの話
        
        
        var numbers = [2, 3, 4, 6, 9]
        let theNumber = 4
        
        print("Numbers old: \(numbers)")
        let newNumbers = numbers.map { n in
            n + theNumber
        }
        print("Numbers new: \(newNumbers)")
        

    }
}



struct SummaryValueTypesAndMutableClass {
    static func main() {

    }
}
