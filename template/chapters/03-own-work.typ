// An opinionated 3rd party library for rendering prettier source code blocks.
// You may get rid of it or replace it with something else if you like.
// https://typst.app/universe/package/codly
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

// Auxiliary functions for fixing the vertical offset of icons.
// This is a font-dependent hack (Noto Color Emoji font). You could use
// FontAwesome or Nerd Fonts for better results.
#let icon-text(body) = box()[#v(-1pt)#body#v(1pt)]
#let icon(body) = box()[#v(-2pt)#body#v(2pt)]
// Configure codly. Optional.
#codly(
	languages: (
		c: (name: [C], icon: none, color: black),
		cpp: (name: [C++], icon: none, color: black),
		py: (name: icon-text(text(rgb("#003070"))[Python]), icon: icon[🐍], color: blue),
		rust: (name: icon-text(text(red)[Rust]), icon: icon[🦀], color: rgb("#CE412B")),
	)
)

= Own work
#lorem(400)
#figure(
	image("../img/plot.svg", width: 80%),
	caption: [Sine wave],
)
#lorem(300)

== Implementation details

=== Programming languages
#block(breakable: false)[
	Take some time to examine @hello-c.
	#figure(
		```c
		#include <stdio.h>

		int main(int argc, char **argv)
		{
			printf("Hello, world!\n");
			return 0;
		}
		```,
		caption: [The best program, written in the C programming language.],
	) <hello-c>
]

While @hello-c is written in the best programming language, here is a version
in a much inferior, offspring language, C++:

#codly(highlights: ((line: 5, start: 3, fill: red),))
#figure(
	```cpp
	#include <iostream>

	int main(int argc, char **argv)
	{
		std::cout << "Hello, world!" << std::endl;
		return 0;
	}
	```,
	caption: [The best program, made slightly worse.],
) <hello-cpp>

Highlighted red, you can see one of the earliest red flags in the design of the
C++ language.

Scripting languages also deserve credit. @hello-python showcases a
version of the same program, this time written in Python.

#figure(
	```py
	print("Hello, world!")
	```,
	caption: [The best program, for the lazy.],
) <hello-python>

Last but not least, let us consider a representative of a newer front of
memory-safe languages, Rust. The code can be seen on @hello-rust.

#figure(
	```rust
	fn main() {
		println!("Hello, world!");
	}
	```,
	caption: [The best program, memory safe#footnote[mostly, see @cve-rs]],
) <hello-rust>


=== Ranking
Now that we have seen what the different languages can do and how they present
themselves, a natural question arises: Which one to use? @tab:ranking shows an
objective, unopinionated ranking of all languages.
#figure(
	table(
		stroke: none,
		columns: (3),
		align: (center, left, left),
		table.hline(),
		table.header[*Rank*][*Language*][*Comment*],
		table.hline(),
		[1], [C], [The undisputed king.],
		[2], [Python], [You may disagree, but you cannot argue with its practicality.],
		[3], [Rust], [Rust is on trial. It could become fantastic, let us hope so.],
		[4], [C++], [It's a mess. I just don't like it.],
		table.hline(),
	),
	caption: [Ranking of all languages],
) <tab:ranking>
