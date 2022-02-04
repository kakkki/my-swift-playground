import Foundation

public struct NonValueSemanticsTypesIssueAndResolve {
    public static func main() {
        Logger.makeBorder { UnintentionalChangesIssue.main() }
        Logger.makeBorder { IntegrityDestructionIssue.main() }
        Logger.makeBorder { ImmuetableClassSolution.main() }
        Logger.makeBorder { IssueByImmutableClass.main() }
        Logger.makeBorder { ValueTypeSolution.main() }
        Logger.makeBorder {
            print("まとめると。。。")
            print("イミュータブルクラスでも Value Semantics が維持できるが、値の更新が大変")
            print("structによる値型であれば、 Value Semantics を維持しつつ、値の更新も簡単")
        }
    }
}

struct UnintentionalChangesIssue {
    
    class Item {
        var name: String
        var settings: Settings
        
        init (name: String = "", settings: Settings = Settings()) {
            self.name = name
            self.settings = settings
        }
    }
    
    class Settings {
        var isPublic: Bool = false
    }
    
    static func main() {
        print("意図しない変更の例")
        
        let item = Item()
        let duplicated = Item(
            name: item.name,
            settings: item.settings
        )
                
        print("item.settings.isPublic : \(item.settings.isPublic)")
        duplicated.settings.isPublic = true
        print("item.settings.isPublicもtrueに変更されてしまう")
        print("item.settings.isPublic : \(item.settings.isPublic)")
        print("duplicated.settings.isPublic : \(duplicated.settings.isPublic)")
    }
}

struct IntegrityDestructionIssue {
    
    class Person {
        var firstName: String {
            didSet { _fullName = nil }
        }
            
        var familyName: String {
            didSet { _fullName = nil }
        }
        
        var fullName: String {
            if let fullName = _fullName {
                return fullName
            }
            _fullName = "\(firstName)\(familyName)"
            return _fullName!
        }
        private var _fullName: String? //キャッシュ
        
        init(firstName: String = "", familyName: String = "") {
            self.firstName = firstName
            self.familyName = familyName
        }
    }
    
    
    static func main() {
        print("整合性の破壊のの例")
        let person = Person(firstName: "Taylor", familyName: "Swift")
        var familyName = person.familyName
        familyName.append("y")
        print("familyNameはStringで、StringはValue Semanticsをもつstruct")
        print("なのでappendによる変更はperson.familyNameには影響しない")
        print("familyName : \(familyName)")
        print("person.familyName : \(person.familyName)")
        
        print("もし仮にfamilyNameがValue Semanticsを持たないReferenceTypeだったら")
        print("person.familyNameにも影響する")
        print("このときpersonを介せずperson.familyNameないしperson._fullNameを変更できてしまうパスができてしまうことになる")
        
        print("この節で言いたかったのは、Reference Semanticsは意図しないパスを作ってしまい整合性が破壊されてしまう可能性がある")
    }
}

struct ImmuetableClassSolution {
    
    static func before() {
        print("対処法は3つ")
        print("防御的コピー")
        print("Read-onlyl View")
        print("イミュータブルクラスでReferenceTypeにValue Semanticsを持たせる")
        print("↓↓↓↓↓前回の例")
        HasReferenceTypePropertyButHasValueSemantics.main()
        
    }
    
    class Settings {
        let isPublic: Bool = false
    }
    
    static func main() {
        print("問題への対処法")
        self.before()
    }
}

struct IssueByImmutableClass {
    static func main() {
        print("特定の値を更新したいだけなのに、新しいインスタンスを生成したりと処理が複雑になる")
        print("Kotlinはdata classがcopyメソッドが自動生成される。これを使うと目的のプロパティだけを更新した新しいインスタンスを生成することができる")
        print("KotlinやJavaは参照型中心の言語。Swiftは値型中心の言語。")
        print("イミュータブルクラスはValue Semanticsを持たないことに起因する問題は解決してくれるが、ミュータブルに比べて処理が複雑")
    }
}

struct ValueTypeSolution {
    
    static func before() {
        print("Swift はイミュータブルクラスではなく値型によって問題の解決を図る")
        print("値型であれば簡単に Value Semantics を持つことができる")
    }
    
    // structになることでitemを複製してもValue Semanticsが維持される
    struct Item {
        var name: String
        var settings: Settings
        
        init (name: String = "", settings: Settings = Settings()) {
            self.name = name
            self.settings = settings
        }
    }
    
    struct Settings {
        var isPublic: Bool = false
    }
    
    struct User {
        var name: String
        var points: Int
    }

    static func main() {
        print("値型")
        let item = Item()
        var duplicated = item
        duplicated.settings.isPublic = true
        
        print("item.settings.isPublic : \(item.settings.isPublic)") // falseのまま
        print("duplicated.settings.isPublic : \(duplicated.settings.isPublic)")
        
        var user = User(name: "Sorita", points: 80)
        print("user.points : \(user.points)")
        user.points += 20
        print("user.points : \(user.points)")
        
        var newUser = user
        newUser.points += 100
        print("user.points : \(user.points) 複製された先で値が更新されても、元の値は変更されない")
        print("newUser.points : \(newUser.points) 複製した先の値のみが更新されている")
    }
}
