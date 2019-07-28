## load knitr and stringr
require(knitr)
require(stringr)

## specify filename
filename <- readline(prompt="Enter filename: ")
Rmd_filename <- paste0(filename, ".Rmd")

## knit Rmd_filename
knit(Rmd_filename)

## replace references to "figure" folder and filenames in .md with correct folder/filenames
markdown_filename <- paste0(filename, ".md")
markdown_file <- readLines(markdown_filename)
markdown_file <- markdown_file %>%
                 str_c() %>%
                 str_replace_all(c("<img src" = "{::nomarkdown}<img src", 
                                   "auto;\" />" = "auto;\" />{:/}",
                                   "../img/" = "https://stevemyles.site/img/",
                                   '.png"' = '.png" class="img-responsive"',
                                   '.jpg"' = '.jpg" class="img-responsive"',
                                   "\"\"" = "\""))
#markdown_file <- str_replace_all(markdown_file, "{::nomarkdown}", "")

writeLines(markdown_file, con = markdown_filename)

## move .md file to "_posts" folder to prepare for jekyll build
if (file.exists(paste0("../_posts/", markdown_filename))) { file.remove(paste0("../_posts/", markdown_filename))}
file.rename(from = markdown_filename, to = paste0("../_posts/", markdown_filename))

