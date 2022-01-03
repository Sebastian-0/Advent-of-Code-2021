# Language analysis
These are my thoughts from working with the different languages.

## Day 1 - Excel
- **Language type:** Not really a language
- **Typical use cases:** Economics

Not sure you can call this a language? However, it was easy to solve the problem and probably would have been for many of other early ones as well.

## Day 2 - Assembly (x64 GAS for Linux)
- **Language type:** Procedural
- **Typical use cases:** Low level programming, hardware specific optimizations, drivers

Hard to get started because there are so many different flavours of assembly: NASM, MASM, GAS, FASM, etc... Each has some variations on the syntax, and then you also must take into account if you are targeting 32 or 64 bits, which OS you are using etc...

Once you have figured out the syntax and the quirks of the environment you use (for instance guaranteeing the stack to be 16 byte aligned in my case), and how to compile the code, it's easy to get the job done.

Overall I feel that GAS was nice to work with, if you need to code at such a low level.

## Day 3 - Haskell
- **Language type:** Functional
- **Typical use cases:** Not sure, mostly of academic interest

I'm not used to functional programming languages, however I have used Haskell before. It takes a while to get into their syntax because many operators and functions are defined as symbols rather than readable strings.

To fully understand what you are doing it is necessary to understand how types are resolved. I have complemented all my definitions with their types to make sure everything is correct and as I expect.

Once you know the basics you can start to simplify the expressions by removing the explicit function arguments. I did this to some extent but not fully, I think readability is important too.

I feel Haskell is hard to get into and even harder to master. I also feel that it is quite pointless to use this language in the first place, there are better alternatives.

## Day 4 - SQL
- **Language type:** Procedural
- **Typical use cases:** Automating and optimizing database operations

To be fair, using procedural SQL to solve programming problems is a gross misuse of the language. However, that being said it was interesting to try as a learning opportunity. 

Since the problem involved bingo boards it felt fitting for SQL since bingo boards are tables. Unfortunatelly I didn't bother to rewrite the boards into tables after I solved the problem so they are implemented as a 2D matrix of integers in a single column (very bad SQL practice).

I think PL/pgSQL is a cool language but we should probably only use it for real database operations. My solution works but is way slower than it has any right to be.

## Day 5 - Fortran
- **Language type:** Procedural, Object-oriented
- **Typical use cases:** Simulations, high performance computations

I admit that I went into Fortran expecting an outdated language with a horrible syntax (where did that preconception come from?) but I was pleasantly surprised.

There are some strange things in the language, like inferring the type from the variable name by default. The formatting strings for reading/writing are also really strange compared to other languages. Other than those minor things it was pretty straightforward to use.

It's reminescent of Matlab but faster and more clean. As long as you write modern fortran that is, I ran into some old Advent of Code solutions riddled with gotos...

## Day 6 - Clojure
- **Language type:** Functional
- **Typical use cases:** Not sure, maybe integrated with Java on the JVM

Another functional language. For some reason I really liked this one. Unlike Haskell there are no strange operators, everything is explicit in text. Since the code is compiled to the JVM you can also integrate it with other Java code and libraries which is a big strength.

I would really like to use this more in the future.

## Day 7 - Prolog
- **Language type:** Logic
- **Typical use cases:** NLP, AI

Really hard to get into. Annoying with SWI prolog vs. GNU prolog when googling because the answers are a mix of both. Disappointing that the finite domain solver is so slow for minimization problems... Maybe I did something wrong? It is also a pain in the ass to get working because there are no real examples anywhere.

At the end I reached a better understanding and feel like I could use it to tackle more problems, however I probably will never use it again.

## Day 8 - R
- **Language type:** Procedural, Object-oriented
- **Typical use cases:** Statistics

I should not have used R for a constraint problem with strings... You really feel that this language is meant to be used for math and not much else.

I like that vectorization of operations is deeply embedded in the language, even though it made the code a bit trickier to write.

## Day 9 - Bash
- **Language type:** Procedural
- **Typical use cases:** Scripting on Linux, task automation

I new this language pretty well to begin with. It was interesting to learn new tricks for dealing with n-dimensional arrays. Also learned the hard way how slow subshell execution is; **never** use it in loops...

## Day 10 - Batch
- **Language type:** Procedural
- **Typical use cases:** Scripting on Windows, task automation

What an annoying piece of work.

Lacks fundamental features like OR/AND in if statements. Strange behaviour in multiple cases like when reading variables inside if-statements where you can't modify them without using delayed execution.

No support for sorting so a very hacky workaround is needed:
- Must abuse array index sorting
- No numeric sort so must zero pad
- No support for duplicates so must add a unique id

No way to handle integer overflow.

Why did I ever use this language? I didn't know about delayed execution previously either, a wonder I got anything to work.

## Day 11 - Lua
- **Language type:** Procedural, Object-oriented
- **Typical use cases:** Scripting language for applications

This language was very easy to get into with great resources available. It was intuitive and similar to many other languages. Lua is very simple in its design which has both upsides and downsides, for instance the lack of -=/+=/etc... was a bit annoying, but on the other hand there is less syntax and libraries you need to learn.

Apart from day 1 in Excel this was the fastest solution to write by a wide margin, not much more than 1 hour from start to finish including learning the language.

## Day 12 - PHP
- **Language type:** Procedural, Object-oriented
- **Typical use cases:** Web page development

PHP was pretty nice to code in, I had no major hurdles when building the solution. There are some annoying things, like having to type `$` before every variable, and that it uses type juggling like Javascript, but other than that I feel like this is decent language.

A lot of people seem to dislike PHP but the reasons why are not apparent when using it for AoC, maybe it would be more obvious during web development.