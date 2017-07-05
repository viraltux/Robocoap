* Robocoap

Given, let's say, a novel, one might be interested in having a social network of all the interactions among the characters.

Since interactions can be very subtle, to generate such graph reliably we would need to use human reasoning which means we need strong AI if we want to automatize this process.

However, it is much simpler to gather the coappearance of a certain group of characters and, if the text is long enough, the social network of interactions and the network of coappearance should be farily similar, or similar enough to be able to draw useful conclusions.

Let's consider some examples:

** Novels

Let's generate a dynamic network in [[https://gephi.org][Gephi]] with the help of the Robocoap package on the mother of all novels; *Don Quijote de la Mancha*:

1. We donwload [[http://www.gutenberg.org/cache/epub/2000/pg2000.txt][Don Quijote de la Mancha]] from the great [[https://www.gutenberg.org/][Project Gutenberg]] and store the first part of the book in one file ~quijote.txt~.
2. We list the book characters we want to analyze their coappearance in a regex format, for example, Dulcinea is also named Alzonda Lorenzo in the book, so we will use ~(Dulcinea|Aldonza Lorenzo)~ to refer to this character in our list.
 #+BEGIN_SRC R
  personajes <- c('(Don Quijote|don Quijote|quijote)', '(El cura|el cura|Pedro Pérez|Pero Pérez)',
		  '(E|e)l ama','(Antonia Quijana|la sobrina|La sobrina)',
		  '(E|e)l ventero','Juan Haldudo','Andrés','(Dulcinea|Aldonza Lorenzo)',
		  'Pedro Alonso','(El barbero|el barbero|maese Nicolás|Maese Nicolás)',
		  'Frestón','(G|g)igantes','Sancho', '(Juana Panza|Teresa)','Sanchica',
		  'Grisóstomo','Marcela','Guillermo el rico','(M|m)aese Pedro',
		  'Sarra','Ambrosio','Vivaldo','Juan Palomeque','Maritornes',
		  '(E|e)l arriero','(E|e)l cuadrillero','Pedro Martínez','Tenorio Hernández',
		  'Alonso López','(Ginesillo|Ginés de Pasamonte)',
		  'Cardenio','Luscinda','(Dorotea|Micomicona)','(D|d)on Fernando',
		  'Anselmo','Lotario','Camila','Ruy Pérez','(Zoraida|María)','Juan Pérez',
		  'Clara', '(D|d)on Luis','Leandra','Eugenio','Anselmo','Vicente')
 #+END_SRC
3. We call the function ~novel.coap~ from the package ~Robocoap~ with the option to produce files for Gephi set to ~TRUE~.
 #+BEGIN_SRC R
 library(Robocoap)
 novel.coap('~/path/to/quijote.txt', characters = personajes, split = 'Capítulo', language = 'spanish', gephi = TRUE)
 #+END_SRC
4. We now load the generated files ~novel.coapnet.csv~ and ~novel.coapnet.timeset.csv~ into Gephi as follows:
 + novel.coapnet.csv :: Gephi -> File -> Open [Directed] -> Ok
 + novel.coapnet.timeset.csv :: Gephi -> File -> Import Spreadsheet -> Next -> Finish
5. Enjoy!
[[./images/quijote.png]]
[[https://viraltux.github.io/Robocoap/images/quijote.png]]
