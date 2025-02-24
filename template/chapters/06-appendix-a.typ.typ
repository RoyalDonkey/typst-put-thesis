= More tips for writers

== Numbered, unnumbered, terms, tight and wide lists
Typst has numbered, unnumbered and terms lists. All 3 types also can be tight
or wide:

#align(center, table(
	columns: (4),
	align: (left + horizon),
	table.header[][*Numbered*][*Unnumbered*][*Terms*],
	[*Tight*],
	[
		Paragraph before.
		1. One
		2. Two
		3. Three
		Paragraph after.
	],
	[
		Paragraph before.
		- One
		- Two
		- Three
		Paragraph after.
	],
	[
		Paragraph before.
		/ One: This is 1.
		/ Two: This is 2.
		/ Three: This is 3.
		Paragraph after.
	],
	[*Wide*],
	[
		Paragraph before.
		1. One

		2. Two

		3. Three
		Paragraph after.
	],
	[
		Paragraph before.
		- One

		- Two

		- Three
		Paragraph after.
	],
	[
		Paragraph before.
		/ One: This is 1.

		/ Two: This is 2.

		/ Three: This is 3.
		Paragraph after.
	],
))

Numbering of lists can be done explicitly or automatically. Both examples below
are equivalent:

#align(center, block(width: 5cm)[
	#place(left)[
		```typst
		// Explicit
		1. One
		2. Two
		3. Three
		```
	]
	#place(right)[
		```typst
		// Automatic
		+ One
		+ Two
		+ Three
		```
	]
	#v(17mm)
])

For more information, refer to:
- https://typst.app/docs/reference/model/list/#definitions-item
- https://typst.app/docs/reference/model/enum/
- https://typst.app/docs/reference/model/terms/

== Conjugating the supplement in Polish writing
#block(breakable: false)[
	In Polish writing, when using automatic references, conjugation of the
	supplement poses a slight challenge. For Polish writers:

	#box(stroke: 1pt, inset: 8pt)[
		#set text(lang: "pl")
		Jeśli zdanie wymaga formy mianownikowej suplementu ("Sekcja"), to nie ma
		problemu. Piszemy wtedy po prostu:
		```typst
		@sec:topic-and-scope opowiada o temacie pracy.
		```
		Ale gdybyśmy chcieli napisać "W Sekcji 1.1, ...", potrzebujemy odpowiedniej
		odmiany, której Typst nie zagwarantuje. Przykładowo, taki kod:
		```typst
		W @sec:topic-and-scope omawiany jest temat pracy.
		```
		Zostanie przełożony na "W @sec:topic-and-scope omawiany jest temat pracy", co jest
		gramatycznie niepoprawne i nieładnie wygląda. W takich sytuacjach zalecane
		jest tymczasowe nadpisanie tzw. suplementu (w tym wypadku słowa "Sekcja"):
		```typst
		W @sec:topic-and-scope[Sekcji] omawiany jest temat pracy.
		```
		Taka forma skutkuje poprawnym "W @sec:topic-and-scope[Sekcji] omawiany jest
		temat pracy". Równocześnie, całe sformułowanie
		"@sec:topic-and-scope[Sekcji]" będzie poprawnie wygenerowane jako klikalny
		odnośnik do odpowiedniego miejsca w pracy.

		To samo tyczy się odwołań do rysunków, tabel, równań, etc. Dla ciekawskich,
		dokumentacja funkcji ```typst ref()```, która jest wywoływana pod spodem
		dla każdego odwołania:\ https://typst.app/docs/reference/model/ref/.
	]
]
