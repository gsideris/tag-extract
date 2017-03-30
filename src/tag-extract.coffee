$.fn.extend
  tagExtract: (options) ->
    self = $.fn.tagExtract
    opts = $.extend {}, self.default_options, options    
    $(this).each (i, el) ->        
        self.init el, opts
        

$.extend $.fn.tagExtract,
  default_options:
    max:'auto'
    min:3
    ignored : ['the', 'be','to','of','and','a','in','that','have','I','it','for','not','on','with','he','as','you','do','at','this','but','his','by','from','they','we','say','her','she','or','an','will','my','one','all','would','there','their','what','so','up','out','if','about','who','get','which','go','me','when','make','can','like','time','no','just','him','know','take','person','into','year','your','good','some','could','them','see','other','than','then','now','look','only','come','its','over','think','also','back','after','use','two','how','our','work','first','well','way','even','new','want','because','any','these','give','day','most','us','were','was','has','less','more','is','s','said','between','without','are','been','such','did','both','had','still','within']

  init: (el, opts) ->
        ignored = opts['ignored']
        target = opts['target']        
        if ($(el).is("textarea"))
           text = $(el).val()
        else
           text = $(el).text()
        
        clusters = opts['clusters']        
        bins = clusters.length        
        tagnumber = opts['max']
                

        # remove the words to be ignored
        for word in ignored
            re = new RegExp("\\b"+word+"\\b","gi")
            text = text.replace(re,'')

        # find the occurence of a ll words in the text
        numofwords = 0
        occurences = []
        for line in text.split("\n")
            for token in line.split /\W+/
                word = "##{token.toLowerCase()}"
                if ! parseFloat(word) && word.length > 1
                    numofwords = numofwords + 1
                    if occurences[word]
                        occurences[word] = parseInt(occurences[word] + 1)
                    else
                        occurences[word] = 1
        

        # transform the occcurence in percentages
        sum = 0
        for k,v of occurences
            occurences[k] = occurences[k]/numofwords
            sum += occurences[k]
                
        avg = sum / numofwords
        
        if tagnumber == 'auto'
            tagnumber = numofwords // 100
            if tagnumber < opts['min']
               tagnumber = opts['min']

        # sort them
        occurences = do (occurences) ->
            res = {}
            keys = Object.keys(occurences).sort (a, b) -> occurences[b] - occurences[a]
            for k in keys
                if occurences[k] > avg
                    res[k] = occurences[k]
            res

        # calculate cluster centers
        max = -1
        min = 1000
        out = Object.keys(occurences)[..tagnumber]
        hash = {}
        
        for o in out
            if min > (occurences[o] * 100)
                min = (occurences[o] * 100)

            if max < (occurences[o] * 100)
                max = (occurences[o] * 100)

            hash[o] = (occurences[o] * 100)


        diff = max - min
        binrange = diff / bins
        binhash = []
        for i in [0..bins-1]
            binhash[min+(i*binrange)] = []

        
        # place tags in clusters
        for k in Object.keys(hash)
            score = hash[k]

            minval = 1000
            minkey = 0
            for i in [0..bins-1]
                key = min+(i*binrange)
                if Math.abs(key-score) < minval
                    minval = Math.abs(key-score)
                    minkey = key
            binhash[minkey].push k        
        # place them in the targets

        obj = $("##{target}").each (i,obj) ->        
            c = 0            
            $(obj).empty()                        
            for k in Object.keys(binhash).reverse()
                b = binhash[k]
                cstyle = clusters[c]
                c = c + 1
                for tag in b                    
                    label = $('<span>').attr({class:"label #{cstyle}"}).append(tag)
                    $(obj).append(label)
                    

