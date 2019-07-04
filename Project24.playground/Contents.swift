import UIKit

extension String {
    // challenge 1
    func withPrefix(_ prefix: String) -> String {
        if self.contains(prefix) || self.isEmpty {
            return self
        } else {
            return String(prefix + self)
        }
    }
    
    // challenge 2
    var isNumeric: Bool {
        let result = Double(self) != nil ? true : false
        return result
    }
    
    // challenge 3
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

"pet".withPrefix("pet")
"pet".withPrefix("")
"bite".withPrefix("frost")

"123".isNumeric
"345s".isNumeric
"catDog".isNumeric
"".isNumeric

"this\nis\na\ntest".lines
"this\nis\na\ntest".lines.count
"".lines



