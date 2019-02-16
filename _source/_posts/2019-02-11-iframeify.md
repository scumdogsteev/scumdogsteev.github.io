---
layout: post
title: iframeify
date: 2019-02-11
comments: true
categories: 
  - rstats
summary: Embedding (R)Markdown files hosted on <a href="https://pages.github.com/">GitHub pages</a> in <a href="https://tumblr.com/">tumblr</a> pages with iframes
always_allow_html: yes
output:
  md_document:
    variant: markdown_github
    preserve_yaml: true
---

**Navigate:**  [ [background](#background) ] &#124; [ [solution](#solution) ] &#124; [ [script](#script) ] &#124; [ [site](https://s.mylesandmyles.info/iframeify/) ]

---

*There's probably an easier way to do this, but it was fun to figure this out.*

<a id="background"></a>
-[ **background** ]-

[The running site I share with my wife](https://www.mylesandmyles.info/) is hosted on [tumblr](https://tumblr.com/).  We have [a page](https://www.mylesandmyles.info/race-results/) where we track our race results, as well as our upcoming races.  

<img src="https://s.mylesandmyles.info/img/2019-02-11-tumblr-iframe-markdown/races.jpg" class="img-responsive" alt="Races page" width="500" />
<p style="text-align: center;font-size: small;"><em>Our "<a href="https://www.mylesandmyles.info/race-results/">Races</a>" page</em></p>

<a id="solution"></a>
-[ **solution** ]-

I used to manually update that page, editing the html when we finished a race or adding new races to the "Future" list.  This was really time consuming, so I recently rebuilt the file in markdown and used [knitr](https://yihui.name/knitr/) to convert it to html, which I then copied/pasted into the page on tumblr.

<img src="https://s.mylesandmyles.info/img/2019-02-11-tumblr-iframe-markdown/markdown_file.jpg" class="img-responsive" alt="markdown file" width="500" />
<p style="text-align: center;font-size: small;"><em>The top of the markdown file.  Note the markdown table.</em></p>

I don't know why, but tumblr did not like the table that I had produced via knitting the markdown file.  It would only display a blank page so, instead of trying to get tumblr to show it correctly, I figured I would create the html file and embed it in an [iframe](https://www.w3schools.com/tags/tag_iframe.asp).

This led to some initial issues, mostly due to not really knowing how to use iframes.  Some quick
Googling helped me with the basics and I figured out the appropriate size (650x500 seems good for my tumblr theme).

<a id="iframe-html"></a>
```html
<p>
    <iframe class="frame-area" frameborder="0" height="650" name="race-results" scrolling="auto" 
    src="https://s.mylesandmyles.info/iframeify/races.html" width="500"> </iframe>
</p>
```

That worked, but there were three issues:

1. the `title` of the output html file was "Future" (which makes sense as that's the first word in the source markdown file, but it's not what I wanted since [the file is viewable outside of the iframe](https://s.mylesandmyles.info/iframeify/races.html))
2. the style of the text in the iframe didn't match the parent page
3. clicking any of the links opened them in the iframe instead of in the parent window

<img src="https://s.mylesandmyles.info/img/2019-02-11-tumblr-iframe-markdown/link_in_iframe.jpg" class="img-responsive" alt="link opened in iframe" width="500" />
<p style="text-align: center;font-size: small;"><em>Clicking a link at first opened it in the iframe</em></p>

To rectify these, I wrote [a simple R script](https://github.com/scumdogsteev/iframeify/blob/master/iframeify.R) to better prepare the markdown file to be embedded in a tumblr page via iframe.  The script:

1. changes the title of the output page to the name of the source file ("races" in this case)
2. updates the style to match this tumblr
3. adds `target="_parent"` to all `<a href="xxxxxx">` tags to open links in the parent window

For #2, I copied/pasted the links to the tumblr theme's CSS into [styles.txt](https://github.com/scumdogsteev/iframeify/blob/master/styles.txt) and added some custom CSS for the table to [styles.css](https://github.com/scumdogsteev/iframeify/blob/master/styles.css). These could be adjusted if necessary to work with different themes.

This script is set up to take the filename as an input in case I ever want to use this for something other than this specific page.

The output html file is then ready to be committed to a GitHub repository that is set up to serve [GitHub Pages](https://pages.github.com/). Once committed, it is served in an iframe on [the tumblr page](https://www.mylesandmyles.info/race-results/) via [the above html](#iframe-html).

<img src="https://s.mylesandmyles.info/img/2019-02-11-tumblr-iframe-markdown/gh-pages.jpg" class="img-responsive" alt="GitHub Pages" width="500" />
<p style="text-align: center;font-size: small;"><em>Repo settings to enable GitHub pages (https is optional)</em></p>

This script, called [iframeify](https://github.com/scumdogsteev/iframeify), could be used for [RMarkdown](https://rmarkdown.rstudio.com/) files as well.

<a id="script"></a>
-[ **[script](https://github.com/scumdogsteev/iframeify/blob/master/iframeify.R)** ]-

```r
## iframeify.R
## by Steve Myles / https://s.mylesandmyles.info/
## 10 February 2019
##
## converts a markdown file into an iframe-able html file for embedding in
## another site such as tumblr

iframeify <- function(filename, stylesheet = "styles.css", styles = "styles.txt") {
    require(knitr)
    require(stringr)

    ## add markdown and html extensions to filename
    md_filename <- paste0(filename, ".md")
    html_filename <- paste0(filename, ".html")

    ## check whether stylesheet exists; if not, set to blank
    if (!file.exists(stylesheet))
      stylesheet = ""

    ## knit
    knit2html(md_filename, html_filename, stylesheet = stylesheet)

    ## read the html and styles files into memory; if styles does not exist,
    ## replace it with opening html <style> tag
    html <- readLines(html_filename)
    if (file.exists(styles)) {
      styles <- paste(readLines(styles), collapse = "\n")
    } else {
      styles = '<style type="text/css">'
    }

    ## replace the title, add the styles, and add 'target="_parent"' to html tags
    html <- html %>%
        str_c() %>%
        str_replace_all(c('<title>(.*?)</title>' = paste0('<title>', filename, '</title>'),
                  '<style type="text/css">' = styles,
                  'a href' = 'a target="_parent" href'))

    ## write results back to the html file
    writeLines(html, con = html_filename)

    ## remove interim .txt file
    file.remove(paste0(filename, ".txt"))
}
```

<a id="comments"></a>
