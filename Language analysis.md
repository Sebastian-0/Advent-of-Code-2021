# Language analysis
These are my thoughts from working with the different languages.

## Excel
Not sure you can call this a language? However, it was easy to solve the problem and probably would have been for many of other early ones as well.

## Assembly (x64 GAS for Linux)
Hard to get started because there are so many different flavours of assembly: NASM, MASM, GAS, FASM, etc... Each has some variations on the syntax, and then you also must take into account if you are targeting 32 or 64 bits, which OS you are using etc...

Once you have figured out the syntax and the quirks of the environment you use (for instance guaranteeing the stack to be 16 byte aligned in my case), and how to compile the code, it's easy to get the job done.

Overall I feel that GAS was nice to work with, if you need to code at such a low level.

## Haskell
I'm not used to functional programming languages, however I have used Haskell before. It takes a while to get into their syntax because many operators and functions are defined as symbols rather than readable strings.

To fully understand what you are doing it is necessary to understand how types are resolved. I have complemented all my definitions with their types to make sure everything is correct and as I expect.

Once you know the basics you can start to simplify the expressions by removing the explicit function arguments. I did this to some extent but not fully, I think readability is important too.

I feel Haskell is hard to get into and even harder to master. I also feel that it is quite pointless to use this language in the first place, there are better alternatives.

## SQL
To be fair, using procedural SQL to solve programming problems is a gross misuse of the language. However, that being said it was interesting to try as a learning opportunity. 

Since the problem involved bingo boards it felt fitting for SQL since bingo boards are tables. Unfortunatelly I didn't bother to rewrite the boards into tables after I solved the problem so they are implemented as a 2D matrix of integers in a single column (very bad SQL practice).

I think PL/pgSQL is a cool language but we should probably only use it for real database operations. My solution works but is way slower than it has any right to be.

## Fortran
I admit that I went into Fortran expecting an outdated language with a horrible syntax (where did that preconception come from?) but I was pleasantly surprised.

There are some strange things in the language, like inferring the type from the variable name by default. The formatting strings for reading/writing are also really strange compared to other languages. Other than those minor things it was pretty straightforward to use.

It's reminescent of Matlab but faster and more clean. As long as you write modern fortran that is, I ran into some old Advent of Code solutions riddled with gotos...

## Clojure
Another functional language. For some reason I really liked this one. Unlike Haskell there are no strange operators, everything is explicit in text. Since the code is compiled to the JVM you can also integrate it with other Java code and libraries which is a big strength.

I would really like to use this more in the future.

## Prolog
Really hard to get into. Annoying with SWI prolog vs. GNU prolog when googling because the answers are a mix of both. Disappointing that the finite domain solver is so slow for minimization problems... Maybe I did something wrong? It is also a pain in the ass to get working because there are no real examples anywhere.

At the end I reached a better understanding and feel like I could use it to tackle more problems, however I probably will never use it again.

## R
I should not have used R for a constraint problem with strings... You really feel that this language is meant to be used for math and not much else.

I like that vectorization of operations is deeply embedded in the language, even though it made the code a bit trickier to write.

## Bash
I new this language pretty well to begin with. It was interesting to learn new tricks for dealing with n-dimensional arrays. Also learned the hard way how slow subshell execution is; **never** use it in loops...

## Batch
What an annoying piece of work.

Lacks fundamental features like OR/AND in if statements. Strange behaviour in multiple cases like when reading variables inside if-statements where you can't modify them without using delayed execution.

No support for sorting so a very hacky workaround is needed:
- Must abuse array index sorting
- No numeric sort so must zero pad
- No support for duplicates so must add a unique id

No way to handle integer overflow.

Why did I ever use this language? I didn't know about delayed execution previously either, a wonder I got anything to work.
