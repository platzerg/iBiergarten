/*
 * Declaring Arrays
 */

// Inferred
let birdGames = ["Angry Birds", "Tiny Wings", "Flappy Bird"]

// Explicit (long form)
let birdGamesExplicit:Array<String> = birdGames

// Explicit (shorthand)
let birdGamesExplicit2:[String] = birdGames

// Empty array
let birdGamesEmpty:[String] = []

/*
 * Accessing Arrays
 */

let firstGame = birdGames[0]
let lastGame = birdGames[birdGames.count - 1]
let tinyWings = birdGames[1]
birdGames.isEmpty

let flappyBirdIndex = find(birdGames, "Flappy Bird")
if let actualIndex = flappyBirdIndex {
  println("Found at \(actualIndex): \(birdGames[actualIndex])")
} else {
  println("Not found!")
}

/*
 * Immutable vs. Mutable Arrays
 */

let immutable = birdGames
//immutable.append("Flappy Felipe") // error

var mutable = birdGames
mutable.append("Flappy Felipe")

/*
 * Modifying Arrays
 */

mutable.removeAtIndex(3)
// mutable.removeLast()
// mutable.removeAll(keepCapacity: false)

mutable.insert("Angry Birds Rio", atIndex: 1)

mutable[0...1] = ["Angry Birds", "Angry Birds Epic", "Angry Birds Friends", "Angry Birds Go!", "Angry Birds Rio", "Angry Birds easons", "Angry Birds Space", "Angry Birds Star Wars", "Angry Birds Star Wars II"]

mutable.sort { a, b in a < b } // More on this later!

mutable
