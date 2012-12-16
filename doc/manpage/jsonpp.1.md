% JSONPP(1) jsonpp User Manuals
% griffin_stewie
% December 12, 2012

# NAME

jsonpp - pretty-print json

# SYNOPSIS

jsonpp [*options*] [*input*]

# DESCRIPTION

pass json as argument

    `jsonpp ~/Documents/foo/sample.json`

pass URL as argument. use curl -k if URL starts with "https".

    `jsonpp --sort-numeric http://localhost:4567/sample.json`

pass json as STDIN

    `curl http://localhost:4567/sample.json | jsonpp --sort`

open pretty-printed JSON by "Sublime Text 2.app"

    `jsonpp ~/foo/sample.json | open -f -a "Sublime Text 2.app"`

write output to FILE instead of stdout.

    `jsonpp -o ~/foo/bar/buzz.json ~/foo/bar/buzz.json`

    `jsonpp --output twitter_search.json "http://search.twitter.com/search.json?lang=ja&rpp=20&q=%23iPhone"`


# OPTIONS

-v, \--version
:   Print version.

-h, \--help
:   Print help.

\--sort,
:   Sort keys (use compare)

\--sort-numeric
:   Sort keys (NSNumericSearch)

-o *FILE*, \--output *FILE*
:   Write output to *FILE* instead of *stdout*.