//
//  Characters.swift
//  HiraganaTouch
//
//  Created by Michael Savich on 5/28/17.
//  Copyright © 2017 Michael Savich. All rights reserved.
//


func multiLookup<T,U>(key:T,dicts:[T:U]...)-> U? {
    var result: U?
    for dict in dicts {
        result = dict[key]
        if result != nil { break }
    }
    return result
}

var bases: [String] { //contains unadorned characters
    if let cache = cachedBases { return cache }
    var result: [String] = []
    for key in syllableOrder {
        guard let character = syllables[key] else { continue }
        if multiLookup(key: character, dicts: undashed,unbubbled) == nil {
            result.append(character)
        }
    }
    cachedBases = result; return result;
}; var cachedBases: [String]?;

let syllableOrder = [
    "n",
    "wa",
    "ra",
    "ya",
    "ma",
    "ha",
    "na",
    "ta",
    "sa",
    "ka",
    "a",
    "wi",
    "ri",
    "mi",
    "hi",
    "ni",
    "chi",
    "shi",
    "ki",
    "i",
    "ru",
    "yu",
    "mu",
    "fu",
    "nu",
    "tsu",
    "su",
    "ku",
    "u",
    "re",
    "me",
    "he",
    "ne",
    "te",
    "se",
    "ke",
    "e",
    "wo",
    "ro",
    "yo",
    "mo",
    "ho",
    "no",
    "to",
    "so",
    "ko",
    "o",
]
let syllables = [
    "a"  : "あ",
    "ka" : "か",
    "sa" : "さ",
    "ta" : "た",
    "na" : "な",
    "ha" : "は",
    "ma" : "ま",
    "ya" : "や",
    "ra" : "ら",
    "wa" : "わ",
    "ga" : "が",
    "za" : "ざ",
    "da" : "だ",
    "ba" : "ば",
    "pa" : "ぱ",
    "i"  : "い",
    "ki" : "き",
    "shi": "し",
    "chi": "ち",
    "ni" : "に",
    "hi" : "ひ",
    "mi" : "み",
    "ri" : "り",
    "wi" : "ゐ",
    "gi" : "ぎ",
    "ji" : "じ",
    "ji2": "ぢ",
    "bi" : "び",
    "pi" : "ぴ",
    "u"  : "う",
    "ku" : "く",
    "su" : "す",
    "tsu": "つ",
    "nu" : "ぬ",
    "fu" : "ふ",
    "mu" : "む",
    "yu" : "ゆ",
    "ru" : "る",
    "gu" : "ぐ",
    "zu" : "ず",
    "bu" : "ぶ",
    "pu" : "ぷ",
    "e"  : "え",
    "ke" : "け",
    "se" : "せ",
    "te" : "て",
    "ne" : "ね",
    "he" : "へ",
    "me" : "め",
    "re" : "れ",
    "ge" : "げ",
    "ze" : "ぜ",
    "de" : "で",
    "be" : "べ",
    "pe" : "ぺ",
    "o"  : "お",
    "ko" : "こ",
    "so" : "そ",
    "to" : "と",
    "no" : "の",
    "ho" : "ほ",
    "mo" : "も",
    "yo" : "よ",
    "ro" : "ろ",
    "wo" : "を",
    "go" : "ご",
    "zo" : "ぞ",
    "do" : "ど",
    "bo" : "ぼ",
    "po" : "ぽ",
    "v"  : "ゔ",
    "n"  : "ん"
]

let dashed = [
    "か" : "が",
    "き" : "ぎ",
    "く" : "ぐ",
    "け" : "げ",
    "こ" : "ご",
    "さ" : "ざ",
    "し" : "じ",
    "す" : "ず",
    "せ" : "ぜ",
    "そ" : "ぞ",
    "た" : "だ",
    "ち" : "ぢ",
    "つ" : "づ",
    "て" : "で",
    "と" : "ど",
    "は" : "ば",
    "ひ" : "び",
    "ふ" : "ぶ",
    "へ" : "べ",
    "ほ" : "ぼ",
    "う" : "ゔ",
]

var undashed: [String:String] {
    if let cache = cachedUndashed { return cache }
    var result: [String:String] = [:]
    for (k,v) in dashed { result.updateValue(k,forKey: v) }
    cachedUndashed = result; return result;
}; var cachedUndashed: [String:String]?;

let bubbled = [
    "は" : "ぱ",
    "ひ" : "ぴ",
    "ふ" : "ぷ",
    "へ" : "ぺ",
    "ほ" : "ぽ",
]

var unbubbled: [String:String] {
    if let cache = cachedUnbubbled { return cache }
    var result: [String:String] = [:]
    for (k,v) in bubbled { result.updateValue(k, forKey: v) }
    cachedUnbubbled = result; return result;
}; var cachedUnbubbled: [String:String]?;






