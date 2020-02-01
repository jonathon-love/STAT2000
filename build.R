
local({
  # set a stable mirror
  r <- getOption("repos")
  r["CRAN"] <- "https://cran.microsoft.com/snapshot/2020-01-01"
  options(repos = r)
})

if ( ! require(rmarkdown))
  install.packages('rmarkdown')

Rmds <- list.files(pattern='.*\\.Rmd')

for (Rmd in Rmds) {
  match <- regexec('^(.*)\\.Rmd$', Rmd)
  name <- substring(Rmd, 1, nchar(Rmd)-4)
  output_q <- paste(name, 'Q.html')
  output_s <- paste(name, 'S.html')

  rmarkdown::render(
    input=Rmd,
    output_format='html_document',
    output_file=output_q,
    params=list(inc_solu=FALSE))

  rmarkdown::render(
    input=Rmd,
    output_format='html_document',
    output_file=output_s,
    params=list(inc_solu=TRUE))
}

files <- list.files(pattern='Lab*.*')
files <- c(files, 'all.zip')
links <- sapply(files, function(x) paste0(' - [', x, '](', URLencode(x), ')'))

# tweaky sort
links <- gsub('-', '~', links, fixed=TRUE)
links <- sort(links)
links <- gsub('~', '-', links, fixed=TRUE)

index <- paste0('# index\n\n', paste0(links, collapse='\n'))

writeLines(index, 'index.Rmd')

rmarkdown::render(
  input='index.Rmd',
  output_format='html_document',
  output_file='index.html')
