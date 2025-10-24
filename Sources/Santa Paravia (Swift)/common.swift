//
//  common.swift
//  
//
//  Created by Andreas Grimm on 05.10.2025.
//

class Common {
    
    static func limit10(number: Int, denomination: Int) -> Int {
        let value = number / denomination;
        
        if value > 10 {
            return 10;
        }
        
        return value;
    }
    
    private static func isStringNumber(string: String) -> Bool {
        return Double(string) != nil
    }
    
    static func clear() {
        print("\u{001B}[2J")
    }
    
    static func readFloat() -> Float {
        var answer: String = readLine(strippingNewline: true)!;
        
        while isStringNumber(string: answer) == false {
            print ("Please enter a number.");
            answer = readLine(strippingNewline: true)!;
        }
        
        return Float(answer)!;
    }

    static func readFloat(lower: Float, upper: Float) -> Float {
        var answer: String = readLine(strippingNewline: true)!;
        
        while isStringNumber(string: answer) == false || Float(answer)! < lower || Float(answer)! > upper {
            print ("Please enter a number between \(lower) and \(upper).");
            answer = readLine(strippingNewline: true)!;
        }
        
        return Float(answer)!;
    }

    static func readInt() -> Int {
        var answer: String = readLine(strippingNewline: true)!;
        
        while isStringNumber(string: answer) == false {
            print ("Please enter a number.");
            answer = readLine(strippingNewline: true)!;
        }
        
        return Int(answer)!;
    }

    static func readInt(lower: Int, upper: Int) -> Int {
        var answer: String = readLine(strippingNewline: true)!;
        
        while isStringNumber(string: answer) == false || Int(answer)! < lower || Int(answer)! > upper {
            print ("Please enter a number between \(lower) and \(upper).");
            answer = readLine(strippingNewline: true)!;
        }
        
        return Int(answer)!;
    }
    
    static func readString() -> String {
        let answer: String = readLine(strippingNewline: true)!;

        return answer;
    }

    static func readString(mustNotBeEmpty: Bool = true) -> String {
        var answer: String = readLine(strippingNewline: true)!;
        while answer.count < 1 {
            print ("Please provide a value.");
            answer = readLine(strippingNewline: true)!;
        }

        return answer;
    }

    static func readString(default: String = "") -> String {
        let answer: String = readLine(strippingNewline: true)!;
        
        return answer;
    }
    
    static func readString(default: String = "", allowed: [String]) -> String {
        var answer: String = readLine(strippingNewline: true)!;
  
        while allowed.contains(answer) == false {
            print("Please enter one of: \(allowed.joined(separator: ", "))");
            answer = readLine(strippingNewline: true)!;
        }
        
        return answer;
    }
}

