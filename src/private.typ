#let front-matter(config) = context {
	let lang = config.lang
	let ttype = config.ttype
	let title = config.title
	let supervisor = config.supervisor
	let year = config.year
	let faculty = config.faculty
	let institute = config.institute
	let linguify = config.linguify
	set page(numbering: none)

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
		#text(size: 11pt, upper(faculty))\
		#text(size: 11pt, institute)
	]

	place(center + top, dy: 298pt)[
		#text(size: 11pt, linguify(ttype + "-caption"))
		#v(21pt)
		#text(size: 13.8pt, upper(strong(title)))
		#v(42pt)
		#let authors_block = [
			#for (student, student_id) in config.authors [
				#student, #student_id

			]
		]
		#authors_block
		#let authors_block_h = measure(authors_block).height
		#v(109pt - authors_block_h)
		#linguify("supervisor")\
		#supervisor
		#v(26mm)
		POZNAŃ #year
	]
	pagebreak(weak: true)

	place(center + horizon, linguify("diploma-card-page"))
	pagebreak(weak: true, to: "odd")
}
