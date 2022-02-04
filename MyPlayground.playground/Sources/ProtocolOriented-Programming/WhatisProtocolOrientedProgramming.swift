import Foundation

public struct WhatisProtocolOrientedProgramming {
    
    static func before() {
        print("オブジェクト指向でのコード抽象化は、「クラスの継承」と「ポリモーフィズム」")
        print("参照型と異なり、値型は原理的に継承することができない")
        print("そのためSwfitでは、クラスの継承ではなくプロトコルが抽象化の主役になる")
        print("プロ所による抽象化は、リバースジェネリクスやOpaque Result Type等によって実現される")
    }
    
    public static func main() {
        Logger.makeBorder { PolymorphismUsingSwift.main() }
        Logger.makeBorder { ExistentialTypeAndExistentialContainer.main() }
        Logger.makeBorder { ReferenceTypeAndPolymorphism.main() }
        Logger.makeBorder { SubTypePolymorphism.main() }
        Logger.makeBorder { ParametricPolymorphism.main() }
        Logger.makeBorder { ProtocolAsaConstraints.main() }
    }
}

protocol Animal {
    func foo() -> Int
}

struct PolymorphismUsingSwift {
    
    struct Cat: Animal {
        func foo() -> Int { 2 }
    }
    
    struct Dog: Animal {
        func foo() -> Int { 1 }
    }
    
    static func main() {
        print("プロトコルによる不適切な抽象化")
        let animal: Animal = Bool.random() ? Cat() : Dog()
        print(animal.foo())
        print("これはオブジェクト指向でよくみられるポリモーフィズム")
        print("Swiftにおいてこのようなプロトコルの使い方は必ずしも適切ではない")
    }
}

struct ExistentialTypeAndExistentialContainer {
    
    struct Cat: Animal {
        var value: UInt = 2 // 1Byte
        func foo() -> Int { 2 }
    }
    
    struct Dog: Animal {
        var value: Int32 = 1 // 4Byte
        func foo() -> Int { 1 }
    }

    static func main() {
        print("Existential Type と Existential Container")
        let cat: Cat = Cat() // 1Byte
        let dog: Dog = Dog() // 4Byte
        let animal: Animal = Bool.random() ? cat : dog
        print("\(MemoryLayout.size(ofValue: cat))")
        print("1Byteでも40Byteでもなく、\(MemoryLayout.size(ofValue: animal))Byte消費する") // 40Byte
        print("プロトコル型変数に値を代入すると Existential Container に包まれるので")
    }
}

struct ReferenceTypeAndPolymorphism {
    
    class Animal {}
    class Cat: Animal {}
    class Dog: Animal {}
    
    static func main() {
        print("参照型とポリモーフィズム")
        print("Existential Containerのオーバーヘッドは値型とプロトコルに起因する")
        print("参照型のクラスの継承ではそのオーバーヘッドは発生しない")
        print("参照型のインスタンスは変数に直接格納されるのではなく、インスタンスはメモリ上の別の場所に存在し、その場所を示すアドレスが変数に格納される")
        print("一般的には、64ビット環境においてアドレスは8バイト(64ビット)で表される\n -> そのため、参照型の変数はどのような型でも8バイトの領域しか必要としない")
        
        let cat: Cat = Cat()
        let dog: Dog = Dog()
        let animal: Animal = Bool.random() ? cat : dog
        print(MemoryLayout.size(ofValue: cat))
        print(MemoryLayout.size(ofValue: dog))
        print(MemoryLayout.size(ofValue: animal))

        print("インメモリ上の参照型の変数に格納されるのはすべてインスタンスのアドレスなので、Existential Containerに包まれることもない")
        print("その点において、継承とポリモーフィズムによる抽象化は合理的かもしれないが。。。")
    }
}

struct SubTypePolymorphism {
    
    struct Cat: Animal {
        var value: UInt = 2 // 1Byte
        func foo() -> Int { 2 }
    }
    
    struct Dog: Animal {
        var value: Int32 = 1 // 4Byte
        func foo() -> Int { 1 }
    }

    // サブタイプポリモーフィズム
    static func useAnimal(_ animal: Animal) {
        print(animal.foo()) //動的ディスパッチ
        // animalはprotocol Animalに順応してるため、プロトコル型変数 = Existential Type と呼ばれる
        // プロトコル型変数はExistential Containerに包まれる
        // 呼び出し時はExistential Containerからインスタンスを取り出すオーバーヘッドがある
    }
    
    static func main() {
        print("サブタイプポリモーフィズム")
        print("オブジェクト指向の文脈でポリモーフィズムと言った場合、多くはサブタイプポリモーフィズムを指す")
        print("サブタイピングと言う方が一般的")
        
        print("プロトコルによって サブタイプポリモーフィズム を実現する場合、プロトコルは 型として 用いられる")
        useAnimal(Cat())
        useAnimal(Dog())
        print("")
    }
}

struct ParametricPolymorphism {
    
    struct Cat: Animal {
        var value: UInt = 2 // 1Byte
        func foo() -> Int { 2 }
    }
    
    struct Dog: Animal {
        var value: Int32 = 1 // 4Byte
        func foo() -> Int { 1 }
    }

    static func useAnimal<A: Animal>(_ animal: A) {
        print("型パラメータを導入した関数はジェネリック関数")
        print(animal.foo()) // 静的ディスパッチ
    }
    
    static func main() {
        print("パラメトリックポリモーフィズム")
        useAnimal(Cat()) // Existential Containerで包まず直接Catのまま渡される
        useAnimal(Dog())
        print("ジェネリック関数のコンパイルはサブタイプポリモーフィズムな実装のコンパイルと異なり、")
        print("ジェネリック関数としてのUseAnimalのバイナリに加えて、")
        print("型パラメータにCatやDogなどの具体的な型を当てはめたuseAnimalのバイナリも生成される")

        print("これにより、")
        print("サブタイプポリモーフィズムと異なり、UseAnimalにCatインスタンスやDogインスタンスを渡す際にExistentialContainerに包む必要はない ")
        print("-> なぜならCatインスタンスはCat用のuseAnimalに、DogインスタンスはDog用のuseAnimalにそれぞれ直接渡されるから")
        
        after()
    }
    
    static func after() {
        print(" 値型 中心の Swift においては、 値型 と組み合わせたときにオーバーヘッドの大きい サブタイピングポリモーフィズム よりも、 値型 であってもオーバーヘッドの発生しない パラメトリックポリモーフィズム の方が適している。")
        print("実際、 Swift の標準ライブラリで用いられている ポリモーフィズム のほとんどが パラメトリックポリモーフィズム ")
    }
}

struct ProtocolAsaConstraints {
    static func main() {
        print("サブタイプポリモーフィズムよりも、パラメトリックポリモーフィズムを優先することを言い換えると、")
        print("「プロトコルを「型として」ではなく「制約として」使用することを優先する」と言える")
        print("これはSwiftのプロトコルの使い方について最も重要なこと")
    }
}
