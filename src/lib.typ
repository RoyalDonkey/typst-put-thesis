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

/// Stores global configuration
#let config = state("put-thesis-config")

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

	/// Abstract; string
	abstract: lorem(75),

	body,
) = {
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
	set text(size: 11pt, font: "Liberation Serif", lang: lang)
	set par(justify: true, leading: 0.9em)

	set outline(
		title: text(size: 24pt)[#v(74pt)Contents#v(50pt)],
		indent: auto,
	)
	show outline.entry.where(
		level: 1
	): it => {
		v(8pt, weak: true)
		strong(it)
	}

	config.update((
		lang: lang,
		ttype: ttype,
		title: title,
		authors: authors,
		supervisor: supervisor,
		year: year,
		faculty: faculty,
		institute: institute,
		abstract: abstract,
	))

	body
}

#let front-matter() = context {
	let lang = config.get().lang
	let ttype = config.get().ttype
	let title = config.get().title
	let supervisor = config.get().supervisor
	let year = config.get().year
	let faculty = config.get().faculty
	let institute = config.get().institute
	let abstract = config.get().abstract
	set page(numbering: "I")
	counter(page).update(1)

	let signet_imgpath
	if lang == "pl" {
		signet_imgpath = "../assets/sygnet-pp.svg"
	} else {
		signet_imgpath = "../assets/sygnet-pp-eng.svg"
	}

	place(center + top, dy: 41pt)[
		#figure(
			image(signet_imgpath, width: 100%),
		)
		#v(-5pt)
		#upper(faculty)\
		#institute
	]

	place(center + top, dy: 280pt)[
		#linguify(ttype + "-caption")
		#v(21pt)
		#text(size: 13.8pt, upper(strong(title)))
		#v(41pt)
		#let authors_block = [
			#for (student, student_id) in config.get().authors [
				#student, #student_id\
			]
		]
		#authors_block
		#let authors_block_h = measure(authors_block).height
		#v(126pt - authors_block_h)
		#linguify("supervisor")\
		#supervisor
		#v(25mm)
		POZNAŃ #year
	]
	pagebreak(weak: true)

	place(center + horizon, linguify("diploma-card-page"))
	pagebreak(weak: true, to: "odd")

	if abstract != none {
		place(center + horizon)[
			*Abstract*\

			#abstract
		]
		pagebreak(weak: true)
	}

	outline()
	pagebreak(weak: true)
}

#let styled-body(body) = {
	set page(numbering: "1")
	counter(page).update(1)

	set heading(numbering: "1.1", supplement: linguify("section"))
	// Treat level-1 headings as chapters
	show heading.where(level: 1): set heading(supplement: linguify("chapter"))
	show heading.where(level: 1): it => context [
		#pagebreak(weak: true)
		#v(74pt)
		#text(size: 18pt)[#linguify("chapter") #str(counter(heading).get().at(0))]\
		#text(size: 24pt, it)\
	]
	show heading.where(level: 2): set text(size: 14pt)

	set figure(numbering: "1.1")
	show figure: set figure(supplement: linguify("figure"))
	show figure.where(kind: table): set figure(supplement: linguify("figure-table"))
	show figure.where(kind: raw): set figure(supplement: linguify("figure-code"))

	body
}
