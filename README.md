# tag-extract
JQuery plugin to extract most representative tags from text

# Usage: 
    $('.blog-post').tagExtract({clusters:['label-primary','label-info','label-warning','label-danger'],max:55})


# Description

This plugin will find the most frequent words and creates tags for it. It will ignore certain words (i.e. artciles , prepositions) keeping the most representative from the text. 

You can select the maximum number of tags to be extracted and classify them (based on occurence/importance) using any number of clusters.

At the moment the tags will be appended to an element with class 'tags-extracted'


# Examples
    $('.blog-post').tagExtract({clusters:['label-primary'],max:10})

For every class="blog-post" find a maximum of 10 tags and use one cluster of label-primary as tag color


    $('.blog-post').tagExtract({clusters:['label-primary','label-info','label-warning','label-danger'],max:20})

For every class="blog-post" find a maximum of 20 tags and use 4 clusters of label-primary to label-danger as tag color with the first being the most frequent


# Live Demo
[http://gsideris.github.io/tag-extract/](http://gsideris.github.io/tag-extract/)

