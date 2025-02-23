#import "src/lib.typ": *

#show: put-thesis.with(
	lang: "en",  // or "pl"
	ttype: "bachelor",  // or "master"
	title: "Title of the thesis",
	authors: (
		("First author", 111111),
		("Second author", 222222),
		("Third author", 333333),
	),
	supervisor: "Name of the supervisor",
	year: 2025,  // Year of final submission (not graduation!)

	// Override only if you're not from WIiT/CAT faculty or CompSci institute
	// faculty: "My faculty",
	// institute: "My institute",
)
#abstract[
	Write your abstract here.
]
#outline(depth: 3)
#pagebreak(weak: true)
#show: styled-body

#include("chapters/01-introduction.typ")
#include("chapters/02-literature-review.typ")
#include("chapters/03-own-work.typ")
#include("chapters/04-results.typ")
#include("chapters/05-conclusions.typ")

#pagebreak(weak: true)
#bibliography("references.bib", style: "ieee")

#show: appendices
#include("chapters/06-appendix-a.typ.typ")
