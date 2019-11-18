import Foundation

let startTime = CFAbsoluteTimeGetCurrent()
var minWordLength = 3

// get word list
var wordFile = try String(contentsOfFile: "/Users/dblock/Developer/WheresWordo/data/4000-most-common-english-words-csv.csv")
var words = wordFile.components(separatedBy: "\r\n")
    .filter { $0.count >= minWordLength }
    .map { $0.uppercased() }

// add the reversed words to the list
var reversedWords = words
    .map { String($0.reversed()) }
    .filter { $0.count > minWordLength }

words.append(contentsOf: reversedWords)


// create the word search puzzle martrix
var file = try String(contentsOfFile: "/Users/dblock/Developer/WheresWordo/data/gen-puzzle.txt")
var data = file.components(separatedBy: "\n")
    .filter { $0.count > 0 }
    .map { $0.uppercased() }

var matrix: [[Character]] = []
for line in data {
    matrix.append(Array(line))
}

var needles = Set(words)
var haystack = Set(data);

// top to bottom
for (key, _) in matrix.enumerated() {
    let word: [Character] = matrix
        .map { $0[key] }
    
    haystack.insert(String(word))
}

// top left
for (key, _) in matrix.enumerated() {
    var word: [Character] = []

    var j = key
    for i in 0...key {
        word.append(matrix[j][i])
        j -= 1
    }

    haystack.insert(String(word))
}

// botton left
for (key, val) in matrix.enumerated() {
    var word: [Character] = []

    var y = key
    for x in 0...key {
//        print("X: \(x), Y: \(y), key: \(key), Count: \(val.count)")
        word.append(matrix[matrix.count - (y + 1)][x])

        if (y == 0) {
            break;
        }

        y -= 1
    }

    haystack.insert(String(word))
}

// bottom right
for (key, val) in matrix.enumerated() {
    var word: [Character] = []

    var y = matrix.count - (key + 1)
    for x in 0...key {
        word.append(matrix[y][val.count - (x + 1)])

        y += 1
    }

    haystack.insert(String(word))
}

// top right
for (key, val) in matrix.enumerated() {
    var word: [Character] = []

    var y = val.count - (key + 1)
    for x in 0...key {
        word.append(matrix[x][y])

        y += 1

    }

    haystack.insert(String(word))
}

var i = 0
var count = 0
for line in haystack {
    let v = needles
        .filter { line.contains($0) }
    
    count += v.count
    if v.count > 0  {
        print("\(v.count) of \(count): \(v)")
    }
}

let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
print("Time elapsed: \(timeElapsed) s.")

