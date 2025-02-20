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
		#v(-4pt)
		#upper(faculty)\
		#institute
	]

	place(center + top, dy: 298pt)[
		#linguify(ttype + "-caption")
		#v(24pt)
		#text(size: 11.75pt, upper(strong(title)))
		#v(45pt)
		#let authors_block = [
			#for (student, student_id) in config.authors [
				#text(size: 11pt)[#student, #student_id]
				#v(-4pt)
			]
		]
		#authors_block
		#let authors_block_h = measure(authors_block).height
		#v(107pt - authors_block_h)
		#linguify("supervisor")\
		#supervisor
		#v(74pt)
		POZNAŃ #year
	]
	pagebreak(weak: true)

	place(center + horizon, linguify("diploma-card-page"))
	pagebreak(weak: true, to: "odd")
}
