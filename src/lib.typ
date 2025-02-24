#import "private.typ": *
#import "@preview/linguify:0.4.1": linguify, set-database
#import "@preview/headcount:0.1.0": dependent-numbering, reset-counter

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
	assert(lang == "pl" or lang == "en", message: "Only \"pl\" or \"en\" languages are currently supported.")
	assert(ttype == "bachelor" or ttype == "master", message: "Only \"bachelor\" or \"master\" thesis types are currently supported.")
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
	)
	show outline.entry: it => {
		if sys.version < version(0, 13, 0) {
			let chapter_num = []
			if it.element.numbering != none {
				chapter_num = numbering(it.element.numbering, ..counter(heading).at(it.element.location()))
			} else {
				// Ugly hack: bibliography is the only unnumbered top-level entry
				v(18.5pt, weak: true)
				link(it.element.location(), strong(linguify("bibliography")))
				h(1fr)
				link(it.element.location(), strong(it.page))
				return
			}

			if it.level == 1 {
				v(18.5pt, weak: true)
				link(it.element.location())[
					#strong(chapter_num)
					#strong(it.element.body)
				]
				h(1fr)
				link(it.element.location(), strong(it.page))
			} else {
				h(2pt)
				link(it.element.location())[
					#chapter_num
					#it.element.body
				]
				h(6pt)
				box(width: 1fr, repeat[.#h(4pt)])
				h(16pt)
				link(it.element.location(), it.page)
			}
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
	colophon((
		authors: authors,
		year: year,
		faculty: faculty,
		institute: institute,
		linguify: linguify,
	))
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
	set page(numbering: "1", header: header(), footer: footer())
	counter(page).update(1)

	// Use localized supplement names
	set heading(numbering: "1.1  ", supplement: linguify("section"))
	set math.equation(supplement: linguify("equation"))
	show figure.where(kind: image): set figure(supplement: linguify("figure-image"))
	show figure.where(kind: table): set figure(supplement: linguify("figure-table"))
	show figure.where(kind: raw): set figure(supplement: linguify("figure-code"))

	// Treat level-1 headings as chapters
	show heading.where(level: 1): set heading(supplement: linguify("chapter"))
	show heading.where(level: 1): it => context {
		if it.numbering != none {
			pagebreak(weak: true)
			v(75pt)
			text(size: 17pt)[#it.supplement #numbering(it.numbering, ..counter(heading).get())]
			v(12pt)
			text(size: 21pt, it.body)
			v(22pt)
		} else {
			it
		}
	}
	show heading.where(level: 2): set text(size: 12pt)
	show heading.where(level: 3): set text(size: 11pt)
	show heading.where(level: 4): set heading(numbering: none, outlined: false)
	show heading.where(level: 5): set heading(numbering: none, outlined: false)
	show heading.where(level: 6): set heading(numbering: none, outlined: false)
	show heading.where(level: 7): set heading(numbering: none, outlined: false)
	show heading.where(level: 8): set heading(numbering: none, outlined: false)
	show heading.where(level: 9): set heading(numbering: none, outlined: false)
	// If you need more than 9 level of headings, there is something wrong with you

	// Number figures relative to the current chapter
	set figure(numbering: dependent-numbering("1.1", levels: 1))
	set math.equation(numbering: it => {
		let count = counter(heading.where(level: 1)).at(here()).first()
		numbering("(1.1)", count, it)
	})
	show heading: reset-counter(counter(figure.where(kind: image)))
	show heading: reset-counter(counter(figure.where(kind: table)))
	show heading: reset-counter(counter(figure.where(kind: raw)))
	show heading.where(level: 1): it => {
		counter(math.equation).update(0)
		it
	}

	// Use PUT format for figure captions
	show figure.caption: set text(size: 9pt)
	show figure.caption: it => context {
		strong[#it.supplement #it.counter.display().]
		" "
		it.body
	}
	show figure.where(kind: table): set figure.caption(position: top)

	// Style bibliography
	set bibliography(title: text(size: 20pt)[#v(77pt)#linguify("bibliography")#v(39pt)])
	show bibliography: set text(size: 9pt)

	body
}

#let appendices(body) = {
	// Treat level-1 headings as appendices
	set heading(numbering: "A.1  ")
	show heading.where(level: 1): set heading(supplement: linguify("appendix"))
	show heading.where(level: 1): it => context {
		if it.numbering != none {
			pagebreak(weak: true)
			v(75pt)
			text(size: 17pt)[#it.supplement #numbering(it.numbering, ..counter(heading).get())]
			v(12pt)
			text(size: 21pt, it.body)
			v(22pt)
		} else {
			it
		}
	}
	counter(heading).update(0)

	body
}
