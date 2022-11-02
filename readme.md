![](https://github.com/davidsharp/build-jam/raw/main/banner.png)

# Build-n-Blocks

A game made for a small jam with friends with the theme **"build"**. Built in Love2D.

Build-n-Blocks is a 1-bit falling blocks puzzle game, in which you're a contractor building homes on top of an ever-growing apartment tower block. The game was built in a fortnight, about an apartment block being built in a fortnight.


## What's next?
Although the jam is over, there's still a few things I'd like to tighten up before I move on:
- Bug fix and polish, the difficulty needs rebalancing and the scaling could do with more play-testing
- Add a fuller "resident" system, for now each floor will only ever have the sequence `woman -> man -> old man`, but I had hoped to have 14 (initially 30 x.x) semi-unique residents in semi-unique apartments. Failing a day would mean that resident wouldn't move in, and the next in the list would potentially move in, then talking to them on different days they'd have something else to say
- Port to Playdate, I need to refactor and add helper's to deal with the difference between Love2D and Playdate, but I'm hoping this will be a day's work to get the prototype running there
- Add an infinite mode, I'd not put much thought into this as once the puzzle worked my focus was mostly on the overworld stuff, but in retrospect this would be a good addition. Difficulty could scale up via speed (something I considered for the prototype, but didn't want it to become impossible without being able to properly play-test it), or the number of bombs and sparks could increase.
- Hard drop, when pressing up, pieces should basically auto-land, I had this intention to show where the current piece is expected to land, and these would go hand-in-hand

### Asset Credits

* Sprites/tiles/SFX are from Canari Games' 1BIT asset pack and Kenney's 1-bit asset pack
* Font is Somepx's Matchup Pro
* Music is by JDSherbett
* Dialogue frames are by VectorPixelStar
