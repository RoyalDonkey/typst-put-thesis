#import "private.typ": *
#import "@preview/linguify:0.4.1": linguify, set-database
#import "@preview/hydra:0.5.2": hydra

#let header() = context {
  let chapter = hydra(1, skip-starting: false, display: (ctx, h) => h.body)

  let number = counter(page).display(here().page-numbering())

  if calc.odd(here().page()) {
    align(right, [#chapter | #number])
  } else {
    align(left, [#number | #chapter])
  }
}

/// Initialize the thesis. This must be called before any other function of the template.
#let put-thesis(
	/// Language of the thesis; "pl" or "en"
	lang: "pl",

	/// Type of the thesis; "bachelor" or "master"
	ttype: "bachelor",

	/// Title of the thesis; string
	title: "Title of the thesis",

	/// Authors of the thesis; a list of (name, index) pairs
	authors: (("First author", 111111), ("Second author", 222222), ("Third author", 333333),),

	/// Thesis supervisor (don't forget the honorifics!); string
	supervisor: "Name of the supervisor",

	/// Year of final submission (not graduation!); int
	year: datetime.today().year(),

	/// Faculty name (override); string
	faculty: linguify("faculty"),

	/// Institute name (override); string
	institute: linguify("institute"),

	/// Font family name (override); string
	font: "CMU Serif",

	body,
) = {
	if sys.version < version(0, 12, 0) {
		panic("This template requires typst >=0.12.0")
	}
	assert(lang == "pl" or lang == "en")
	assert(ttype == "bachelor" or ttype == "master")
	set-database(toml("./lang.toml"))

	set document(
		title: title,
		author: (authors.map(x => x.at(0) + " " + str(x.at(1)))),
		date: datetime.today(),
	)
	set page("a4",
		margin: (
			left: 3.5cm,
			right: 2.5cm,
			top: 2.5cm,
			bottom: 2.5cm,
		),
	)
	set text(size: 10pt, font: "CMU Serif", lang: lang)
	set par(justify: true, leading: 0.83em)

	set outline(
		title: text(size: 20pt)[#v(77pt)#linguify("toc")#v(39pt)],
		indent: auto,
		depth: 3,
	)
	show outline.entry: it => {
		if sys.version < version(0, 13, 0) {
			let chapter_num = numbering(it.element.numbering, ..counter(heading).at(it.element.location()))

			// Ugly solution, but this fixes the vertical alignment of subheadings
			if it.level == 2 {
				h(-1pt)
			} else if it.level == 3 {
				h(-4pt)
			}

			chapter_num
			it.element.body
			h(6pt)
			box(width: 1fr, repeat[.#h(4pt)])
			h(16pt)
			it.page
		} else {
			panic("Not implemented yet!")
		}
	}
	show outline.entry.where(level: 1): it => {
		if sys.version < version(0, 13, 0) {
			v(18.5pt, weak: true)
			let chapter_num = numbering(it.element.numbering, ..counter(heading).at(it.element.location()))
			strong(chapter_num)
			strong(it.element.body)
			h(1fr)
			strong(it.page)
		} else {
			panic("Not implemented yet!")
		}
	}

	front-matter((
		lang: lang,
		ttype: ttype,
		title: title,
		authors: authors,
		supervisor: supervisor,
		year: year,
		faculty: faculty,
		institute: institute,
		linguify: linguify,
	))
	set page(numbering: "I")
	counter(page).update(1)
	body
}

#let abstract(body) = {
	if body != none {
		place(center + horizon)[
			*#linguify("abstract")*
			#v(10pt)
			#body
		]
		pagebreak(weak: true)
	}
}

#let styled-body(body) = {
	set page(numbering: "1")
	counter(page).update(1)

	set heading(numbering: "1.1  ", supplement: linguify("section"))

	// Treat level-1 headings as chapters
	show heading.where(level: 1): set heading(supplement: linguify("chapter"))
	show heading.where(level: 1): it => context [
		#pagebreak(weak: true)
		#v(75pt)
		#text(size: 17pt)[#linguify("chapter") #numbering(it.numbering, ..counter(heading).get())]
		#v(12pt)
		#text(size: 21pt, it.body)
		#v(22pt)
	]
	show heading.where(level: 2): set text(size: 12pt)

	set figure(numbering: "1.1")
	show figure: set figure(supplement: linguify("figure"))
	show figure.where(kind: table): set figure(supplement: linguify("figure-table"))
	show figure.where(kind: raw): set figure(supplement: linguify("figure-code"))

	body
}
