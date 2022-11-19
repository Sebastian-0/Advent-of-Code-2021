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

Lacks fundamental features like OR/AND in if statements. Strange behaviour in multiple cases like when reading variables inside if-statements where you can't modify them without using delayed expansion.

No support for sorting so a very hacky workaround is needed:
- Must abuse array index sorting
- No numeric sort so must zero pad
- No support for duplicates so must add a unique id

No way to handle integer overflow.

Why did I ever use this language? I didn't know about delayed expansion previously either, a wonder I got anything to work.

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

## Day 13 - Ada
- **Language type:** Procedural, Object-oriented
- **Typical use cases:** Systems with high reliability requirements

Ada was very annoying to work in, partly because of the strict type system but mostly because there are so many modern features lacking, and you have to write *so much* boilerplate code at times. Things I had problems with:

- Having both the attributes `A'B` and functions `A.B` makes the language confusing.
- Lacking basic features such as `+=` and loop continues, when googling people suggested using gotos and that's just tragic...
- Just creating a list and sorting it creates so much verbose boilerplate code...
- Array indices can start with 0, 1, 11 or whatever you want. Ada argues this is powerfull but in my opinion it will most likely cause obscure bugs which is particularly bad for a language intended for high reliability.
- The lack of a proper API reference is painful, there is one at adaic but apart from that you will spend a lot of time googling. The only place where I managed to find a list of all attributes was at Wikibooks?!

I can kind of, almost, see the point in using this language for some tasks but why not use something else like Rust?

## Day 14 - Perl
- **Language type:** Procedural, Imperative
- **Typical use cases:** Network programming, Scripting for system administration

Perl was an interesting language to work with, once you got the hang of it it was pretty straightforward to use. You could feel some of its limitations, like it being hard to pass multiple lists/hashes in/out of subroutines, but it was possible to work around it.

In general it was a bit bulky (and likely error prone) to handle function arguments, it would be better if that was more statically typed I think. The syntax for if statements was also a bit strange... Like `==` only working for integers so you need `eq` for strings, etc...

The use of the default variable `$_` was an interesting concept, however I don't know if it really is a good idea...

## Day 15 - Ruby
- **Language type:** Functional, Imperative, Object-oriented
- **Typical use cases:** Web applications

Ruby was nice, it is very similar to Python but with some other influences as well, like Perl. I have nothing major to complain about other than that the documentation was pretty bad and hard to find. The main Ruby website sucks big time!

There were some quirks that I didn't quite get, like why you had to add a `&` when you send lambdas to functions. I also think the language gets in the way of itself when it strictly enforces encapsulation by default, and you need to add getters/setters (or use `attr_accessor`) even for simple data structs.

## Day 16 - Go
- **Language type:** Concurrent, Imperative, Object-oriented
- **Typical use cases:** Distributed systems

This feels like a language that was created for a specific use case rather than to be useful in general. There are many things here that are strange/annoying/messy/unconsistent/etc... Some design decisions also don't feel like they were properly thought through, like how they motivated why the should write variable names and type without a separator based on some obscure edge cases in C.

Things I didn't like:

- You must use all variables, otherwise we get compile errors. This was really annoying during development and feels like something a "Clean code" guru just HAD to include in the language to force everyone to follow his/her workflow.
- Variable definitions are weird and are hard to read because there are no separators between name/type
- Weird language constructs with little benefit, like named return values. They even say in the docs that you probably shouldn't use it.
- Public-ness of functions is based on name casing. This feels like how old Fortran derived variable types from the first letter of the name.
- No proper way to handle errors. You seriously must litter your code with if-stmts everywhere!

In general I feel much more inclined to be negative towards this language after I started learning Rust, which feels better in almost every single way.

## Day 17 - Groovy
- **Language type:** Object-oriented, Imperative
- **Typical use cases:** DSLs e.g. in Gradle and Jenkins

Groovy is nice most of the time. It's like Java but with easier/simplified syntax. The only real hurdle I encountered was the error messages that were a bit cryptic, but other than that it worked fine.

Before writing this solution I had a very negative image of Groovy based on my experiences from Gradle and Jenkins. That image mostly stemmed from those platforms being poorly and messily documented at times, leading to many frustrating hours trying to fix seemingly simple errors. Thankfully it seems those problems are limited to those platforms and are not inherent issues in the language itself.

## Day 18 - Dart
- **Language type:** Object-oriented, Imperative, Functional
- **Typical use cases:** Mobile apps

Dart is a nice language, if you avoid its gotchas. I found it to be similar to many other languages in syntax which helped, and the documentation and API docs are really good!

I think the idea of explicitly defining variables as "nullable" is a good idea, but it feels like it could be handled way better by the compiler. My code has many places where I need the `!` operator to avoid compile errors where it's logically impossible for the variables to be null... Maybe it's my experience from Rust that makes me expect more.

I found the mix between static/dynamic typing to be confusing. I think it would be better to just stick to one paradigm. I was especially confused by what happens when you declare a variable like `var text;`. Even if you assign a string to it on the next line it still gets the type `dynamic`, which sometimes can cause the code to compile even though it's 100% guaranteed to fail (this happened to me).

A final note that I found interesting is that all numbers seem to be `double` even if you declare them as `int`.

## Day 19 - Javascript
- **Language type:** Functional, Imperative
- **Typical use cases:** Web development

When using Javascript I find myself missing Typescript. I expect that this code will be hard to understand when looking at it later because there are no types.

Writing this solution took a lot of time, both because the actual problem was tricky but also because Javascript is so lackluster. There are so many things missing that I'd like to have, but the main problem is the lack of quality-of-life stuff, like checking if a list contains an object.

Obviously you are supposed to run Javascript in a browser, so running it from the console made some things tricky, like reading input from `stdin`. I opted for reading from files instead, I never got console reading to work properly...

Some things I don't like:

- Reading input is hard
- Missing proper objects/classes
- Missing array contains/similar
- Missing convenient sets
- Tuples would be nice to have

## Day 20 - C#
- **Language type:** Imperative, Object-Oriented
- **Typical use cases:** Windows applications, Game development, Web development

C# is a nice language overall, however some more setup is required when building it on Linux vs. Windows. I guess Microsoft still uses a Windows-first approach. Also a bit strange that a `.csproj` file seems to be necessary to get it running in docker, those files are connected to Visual Studio so I had to write one manually.

Nothing more to say really. I don't think I will use this language much at the moment since it still feels very tied to Microsoft and their products.

## Day 21 - C
- **Language type:** Imperative, Procedural
- **Typical use cases:** Operating systems, Embedded systems, Application development

I like C, it's simple and clean compared to C++. As long as you don't need advanced datastructures or complicated functions it's fine to use. I decided to use C this day since it seemed like a problem that wouldn't require datastructures/libraries, and indeed it was!