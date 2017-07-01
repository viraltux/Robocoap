wordSequence <- function(txt, words, sep){
  # Returns a vector with a sequence of regex expresions in 'words' within the text 'txt'

  words <- c(words,sep)

  x <- list()
  for(w in words){
    '(\\W|$)'
    x[[w]] <- gregexpr(paste('(^|\\W)',w,'(\\W|$)',sep=''),txt)[[1]]
  }

  suppressWarnings({ sec <- gregexpr(sep, txt)[[1]] })

  v <- vector(mode = 'character', length = nchar(txt))
  vs <- vector(mode = 'character', length = nchar(txt))

  for(w in words){
    if (x[[w]][1]>0) { v[x[[w]]] <- w }
  }

  h <- hist(which(v!=''), c(0,sec,nchar(txt)), plot = FALSE)

  data.frame(word = v[which(v!='')], section = rep(0:(length(h$counts)-1), h$counts))
}
