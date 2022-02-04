import Foundation

public class Logger {
    public static func makeBorder(do: () -> Void) {
        print("--------------------------------------------------")
        `do`()
    }
}
