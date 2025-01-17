//
//  StringStyle.swift
//  StringStyle
//
//  Created by Omar Abdelhafith on 31/10/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

import Foundation


let startOfCode = "\u{001B}["
let endOfCode = "m"
let codesSeperators = ";"


protocol StringStyle {
  var rawValue: Int { get }
  func colorize(string: String) -> String
}


extension StringStyle {
  
  func colorize(string: String) -> String {
    
    if hasAnyStyleCode(string) {
      return colorizeStringAndAddCodeSeperators(string)
    } else {
      return colorizeStringWithoutPriorCode(string)
    }
  }
  
  fileprivate func colorizeStringWithoutPriorCode(_ string: String) -> String {
    return "\(preparedColorCode(self.rawValue))\(string)\(endingColorCode())"
  }
  
  fileprivate func colorizeStringAndAddCodeSeperators(_ string: String) -> String {
    //To refactor and use regex matching instead of replacing strings and using tricks
    let stringByRemovingEnding = removeEndingCode(string)
    let sringwWithStart = "\(preparedColorCode(self.rawValue))\(stringByRemovingEnding)"
    
    let stringByAddingCodeSeperator = addCommandSeperators(sringwWithStart)
    
    return "\(stringByAddingCodeSeperator)\(endingColorCode())"
  }
  
  fileprivate func preparedColorCode(_ color: Int) -> String {
    return "\(startOfCode)\(color)\(endOfCode)"
  }
  
  fileprivate func hasAnyStyleCode(_ string: String) -> Bool {
    return string.contains(startOfCode)
  }
  
  fileprivate func addCommandSeperators(_ string: String) -> String {
    var rangeWithInset = (string.index(after: string.startIndex) ..< string.index(before: string.endIndex))
      
    let newString = string.replacingOccurrences(of: startOfCode, with: ";", options: .literal, range: rangeWithInset)
    
    rangeWithInset = (newString.index(after: newString.startIndex) ..< newString.index(before: newString.endIndex))
    return newString.replacingOccurrences(of: "m;", with: ";", options: .literal, range: rangeWithInset)
  }
  
  fileprivate func removeEndingCode(_ string: String) -> String {
    let rangeWithInset = (string.index(after: string.startIndex) ..< string.endIndex)
    return string.replacingOccurrences(of: endingColorCode(), with: "", options: .literal, range: rangeWithInset)
  }
  
  fileprivate func endingColorCode() -> String {
    return preparedColorCode(0)
  }
}


enum ForegroundColor: Int, StringStyle {
  
  case black = 30
  case red = 31
  case green = 32
  case yellow = 33
  case blue = 34
  case magenta = 35
  case cyan = 36
  case white = 37
}


enum BackgroundColor: Int, StringStyle {
  
  case black = 40
  case red = 41
  case green = 42
  case yellow = 43
  case blue = 44
  case magenta = 45
  case cyan = 46
  case white = 47
}


enum StringTextStyle: Int, StringStyle {
  
  case reset = 0
  case bold = 1
  case italic = 3
  case underline = 4
  case inverse = 7
  case strikethrough = 9
  case boldOff = 22
  case italicOff = 23
  case underlineOff = 24
  case inverseOff = 27
  case strikethroughOff = 29
}
