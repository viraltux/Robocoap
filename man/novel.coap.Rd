\name{novel.coap}
\alias{novel.coap}
\title{
novel.coap
}
\description{
Function to generate a characters co-apperance matrix and characters timeline dataset within
a novel plus files formatted to be used in the Gephi network analysis tool.
}
\usage{
novel.coap(novel, characters, split = "Chapter", language = "english",
          encoding = "UTF-8", gephi = FALSE, plot = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{novel}{
path to a TXT or PDF file containing a novel or text itself.
}
  \item{characters}{
regexp expression containing characters names to analyze co-apperance.
}
  \item{split}{
keyword used to recognize different parts of the novel to establish co-apperance dynamics.
}
  \item{language}{
the language the novel is written on
}
  \item{encoding}{
text econding in the TXT file
}
  \item{gephi}{
flag to generate files formatted to be use with Gephi. The files name
are 'novel.coapnet.csv' and 'novel.coapnet.timeset.csv'.
}
  \item{plot}{
flag to plot the adjacency co-apperance matrix
}
}
\details{
In novels co-apperance (defined as the apperance of two consecutive
characters within split sections) will be similar to interactions among
characters (defined as characters being object of actions by other
characters). Check the example for further details.

Follow these steps in order to load the dynamic graph of coapperances in
Gephi:

1- 'novel.coapnet.csv':
    Gephi -> File -> Open [Directed] -> Ok
2- 'novel.coapnet.timeset.csv:
    Gephi -> File -> Import Spreadsheet -> Next -> Finish
}
\value{
A list contatining the following components:
\item{coapmat}{directed graph matrix describing co-apperance of the characters members}
\item{dynamic}{data set describing characters appearances considering the 'split' separator}

Optionally a plot of the adjacency co-apperance matrix or a set of two Gephi friendly files will be saved.
}

\author{
Fran Urbano <viraltux@gmail.com>
}

\examples{
## Co-apperance vs Interaction Plots
## Co-apperance can be automatized, detect interactions is however a hard AI problem
## than can be approximated by the co-apperances when the story is long enough.

txt <- paste("A woman gets on a bus with her baby. The bus driver says:", "'Ugh,
that's the ugliest baby I've ever seen!' The woman walks", "to the rear of the
bus and sits down, fuming. She says to a man", "next to her: 'The driver just
insulted me!\n\nPun\n' The man says:", "'What? you just go back there and tell him
off. Go on, I'll hold", "your monkey for you.'")

res <- Robocoap::novel.coap(novel = txt, characters = c('woman','driver','baby|monkey','man'),
                 split = 'Pun', language = 'english', plot = FALSE)
res$coapmat
layout(matrix(c(1,2), ncol=2))
par(ask=FALSE)
plot(igraph::graph.adjacency(res$coapmat), main = 'Coapperances')

# Manually creating a matrix of interactions (A action on B)
inter <- res$coapmat
inter[] <- 0
# A woman gets on a bus with her baby ...
inter[4,1] <- 1
# The bus driver says ...
inter[2,4] <- 1
# She says to a man next to her: ...
inter[4,3] <- 1
# The man says: ...
inter[3,4] <- 1

plot(igraph::graph.adjacency(inter), main = 'Interactions')
layout(1)

## TODO Write instructions to load files into Gephi when gephi = TRUE
## To import the results into gephi set the gephi parameter to TRUE


}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
