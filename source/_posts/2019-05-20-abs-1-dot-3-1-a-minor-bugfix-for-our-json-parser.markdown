---
layout: post
title: "ABS 1.3.1 released: a minor bugfix for our JSON parser"
date: 2019-05-20 19:31
comments: true
categories: [abs, scripting, programming language, open source]
description: "A new bugfix release for ABS (1.3.1), which fixes a small issue with our JSON parser."
---

We just [released version 1.3.1](https://github.com/abs-lang/abs/releases/tag/1.3.1)
of [ABS](https://www.abs-lang.org/), which fixes a simple bug
in our JSON parser.

<!-- more -->

This is a bugfix release that fixes [#222](https://github.com/abs-lang/abs/issues/222)
through [#226](https://github.com/abs-lang/abs/pull/226) (originally merged in
the `1.4.x` branch).
An empty string will now not cause a panic when parsed as JSON -- this is
the nasty screen you'd face before:

```
⧐  "".json()
panic: runtime error: index out of range

goroutine 1 [running]:
github.com/abs-lang/abs/evaluator.jsonFn(0x580b0b, 0x1, 0x2, 0x69714e, 0x1, 0xc000162370, 0x1, 0x1, 0x559d40, 0x5af060)
	/go/src/github.com/abs-lang/abs/evaluator/functions.go:785 +0x82e
github.com/abs-lang/abs/evaluator.applyMethod(0x580b0b, 0x1, 0x2, 0x69714e, 0x1, 0x5b02c0, 0xc000244070, 0xc00001a5d6, 0x4, 0x0, ...)
	/go/src/github.com/abs-lang/abs/evaluator/evaluator.go:974 +0x1e8
github.com/abs-lang/abs/evaluator.Eval(0x5aeea0, 0xc000236060, 0xc0000125c0, 0x5aeea0, 0xc000236060)
	/go/src/github.com/abs-lang/abs/evaluator/evaluator.go:195 +0x1beb
github.com/abs-lang/abs/evaluator.Eval(0x5aec60, 0xc0001ac300, 0xc0000125c0, 0x5aec60, 0xc0001ac300)
	/go/src/github.com/abs-lang/abs/evaluator/evaluator.go:67 +0x1636
github.com/abs-lang/abs/evaluator.evalProgram(0xc0001aa1a0, 0xc0000125c0, 0x100, 0x7f463a89bfff)
	/go/src/github.com/abs-lang/abs/evaluator/evaluator.go:232 +0x9b
github.com/abs-lang/abs/evaluator.Eval(0x5aefa0, 0xc0001aa1a0, 0xc0000125c0, 0x7f463d0566d0, 0x0)
	/go/src/github.com/abs-lang/abs/evaluator/evaluator.go:61 +0x461
github.com/abs-lang/abs/evaluator.BeginEval(...)
	/go/src/github.com/abs-lang/abs/evaluator/evaluator.go:54
github.com/abs-lang/abs/repl.Run(0xc00001a5d3, 0x9, 0x301)
	/go/src/github.com/abs-lang/abs/repl/repl.go:151 +0xcb
github.com/abs-lang/abs/repl.executor(0xc00001a5d3, 0x9)
	/go/src/github.com/abs-lang/abs/repl/repl.go:129 +0xf9
github.com/abs-lang/abs/vendor/github.com/c-bata/go-prompt.(*Prompt).Run(0xc0000aa100)
	/go/src/github.com/abs-lang/abs/vendor/github.com/c-bata/go-prompt/prompt.go:85 +0x7f2
github.com/abs-lang/abs/repl.Start(0x5ae1e0, 0xc000010010, 0x5ae200, 0xc000010018)
	/go/src/github.com/abs-lang/abs/repl/repl.go:94 +0x263
github.com/abs-lang/abs/repl.BeginRepl(0xc0000121b0, 0x1, 0x1, 0x580ebb, 0x5)
	/go/src/github.com/abs-lang/abs/repl/repl.go:211 +0x326
main.main()
	/go/src/github.com/abs-lang/abs/main.go:20 +0x94
```

and the beautiful one you would see now:

```
⧐  "".json()

⧐  
```

That's it!

## Now what?

Install ABS with a simple one-liner:

```
bash <(curl https://www.abs-lang.org/installer.sh)
```

...and start scripting like it's 2019!

PS: Thanks to [Ming](https://github.com/mingwho)
who was behind this one!

See you next time!