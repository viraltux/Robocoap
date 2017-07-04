novel.coap <- function(novel, characters, split = 'Chapter', language = 'english', encoding = 'UTF-8',
                       gephi = FALSE, plot = FALSE){
  # Function to generate a characters co-apperance matrix and characters timeline dataset plus files
  # formatted to be used in the Gephi network analysis tool.
  #
  # Input
  # novel: path to a TXT or PDF file containing a novel or text itself.
  # characters: regexp expression containing characters names to analyze co-apperance.
  # split: regex used to recognize different parts of the novel to establish co-apperance dynamics.
  # language: the language the novel is written on
  # encoding: text econding in the novel file
  # gephi: flag to generate files formatted to be use with Gephi
  # plot: flag to plot the adjacency co-apperance matrix
  #
  # Output
  # coapmat: directed graph matrix describing co-apperance of the characters members
  # dynamic: data set describing characters appearances considering the 'split' separator


if (file.exists(novel)) {
    if (!any(tolower(tools::file_ext(novel)) %in% c('txt', 'pdf'))) {
      stop('novel format needs to have txt or PDF extensions and format')
    }
    novel <- sprintf("file://%s", path.expand(novel))

    if (tolower(tools::file_ext(novel)) == 'pdf') {
      novel <- tm::VCorpus( tm::URISource(novel, mode = "", encoding = encoding),
                           readerControl = list(reader = tm::readPDF(engine = "xpdf"),
                                                language = language))
    } else {
      novel <- tm::VCorpus( tm::URISource(novel, mode = "text", encoding = encoding),
                           readerControl = list(reader = tm::readPlain, language = language))
    }

  } else {

    novel <- tm::VCorpus( tm::VectorSource(novel),
                         readerControl = list(reader = tm::readPlain, language = language))
  }

  novel <- tm::tm_map(novel, tm::stripWhitespace)
  novel <- tm::tm_map(novel, tm::PlainTextDocument)
  novel <- novel[[1]]$content

  ## TODO check if this line is needed
  novel <- paste(novel, collapse = '\n')

  ##################################################################

  ws <- wordSequence(novel, words = characters, sep = split)

  ws$word <- gsub('\\\\W','', gsub('\\(','', gsub('\\|.*)','',ws$word)))

  firstcap <- function(x){
    paste(toupper(substr(paste(strsplit(x,' ')[[1]]),1,1)),
          substring(paste(strsplit(x,' ')[[1]]),2), sep = '', collapse = ' ')
  }

  mt <- markovchain::createSequenceMatrix(ws$word)
  rownames(mt) <- colnames(mt) <- gsub(' ','_',apply(matrix(colnames(mt) ), 1, firstcap))
  cr <- match(tolower(split), tolower(colnames(mt)))
  if (!is.na(cr)) {mt <- mt[-cr, -cr]}

  res <- list()
  res[['coapmat']] <- mt
  if (plot){plot(igraph::graph.adjacency(mt))}

  ## dynamic

  ws <- data.table::as.data.table(ws)
  # gimmick to avoid a NOTE when R CMD checking the pkg coming from the data.table pkg
  # https://github.com/Rdatatable/data.table/issues/850
  word <- section <- . <- NULL
  dt <- ws[order(word),.N,by=.(word, section)]
  suppressWarnings({ dt <- dt[word!=split] })

  timeset <- dt[, .(section = paste('"<',paste('[',section,',', section,']', collapse = ';', sep=''),'>"',sep='')), by = word]
  fword <- apply(matrix(timeset[,word]), 1, firstcap)
  co.ts <- data.frame(id = gsub(' ', '_', fword),
                      label = fword,
                      timeset = timeset[,section])
  ## Gephi files
  if (gephi){
    write.csv2(mt, 'novel.coapnet.csv', quote = FALSE)
    write.csv2(co.ts, 'novel.coapnet.timeset.csv', quote = FALSE, row.names = FALSE)
  }

  res[['dynamic']] <- co.ts

  res
}
