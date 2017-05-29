//
//  Operators.swift
//
//  Created by Michael Savich on 5/28/17.
//  Copyright © 2017 Michael Savich. All rights reserved.
//

infix operator =? //assign only if nonnil
func =?<T>(v1:inout T,v2:T?) { v1 = (v2 ?? v1) }

prefix operator ¢ //to character operator
prefix func ¢(val:String) -> Character { return val[val.startIndex] }

prefix operator § //to string operator
prefix func § <T:CustomStringConvertible>(value:T) -> String {
    return String(describing: value)
}
