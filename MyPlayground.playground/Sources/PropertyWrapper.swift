import Foundation
import Combine
import SwiftUI

@propertyWrapper struct Trimmed {
 
    private(set) var value = ""
    var wrappedValue: String {
        get { value }
        set {
        // 前後のスペースを削除する
            value = newValue
                .trimmingCharacters(in: .whitespaces)
            projectedValue.send(value)
        }
    }
 
    var projectedValue = PassthroughSubject<String, Never>()
    
    init(wrappedValue initialValue: String) {
        self.wrappedValue = initialValue
    }
}

struct Post {
    @Trimmed var title: String
}

public class PropertyWrapperSample {
    
    public static func main() {
        var post = Post(title: " init ")

        print("1. \(post.title)")

        post.$title.sink {
            print("sink: \($0)")
        }

        print("2. \(post.title)")
        post.title = " set title "
        print("3. \(post.title)")
        post.title = " set title second"
    }
}

