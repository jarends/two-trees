CompNode = require('../two-trees').CompNode

log = () -> 
    str = ([].slice.call arguments, 0).map((i) -> JSON.stringify(i)).join ", "
    console.log str
    
key = window.location.search.substring(1)
api = "https://www.quandl.com/api/v3/datasets"

queue = []
maxval = {}
    
dequeue = () ->
    req = queue.shift()
    req.send() if req

enqueue = (req) ->
    queue.push req
    
class GraphView extends CompNode

    @dequeue: -> dequeue()
    
    updateCfg: (cfg) ->
        
        @graph = cfg.graph        
        super cfg

    drawValues: (values, x, max, arg) ->
        y = 97-97*values[0]/max
        
        if arg.scale == 1
            x = 17*12 - values.length + (values.length % 12)
        
        for i in [1...values.length]
            v = values[i]
            l = @s.line()
            x += arg.scale
            ny = 97-97*v/max
            l.attr
                class: arg.class
                x1: x-arg.scale
                y1: y
                x2: x
                y2: ny
            y = ny
        
    requestData: (arg, xfunc) ->
        
        req = new XMLHttpRequest()
        req.stock = @graph.symbol
        req.node = @
        req.addEventListener "load", () ->
            dequeue()
            data = JSON.parse @response
            set = data.dataset
            values = (d[1] for d in set.data)
            if arg.class == 'long'
                maxval[@node.symbol] = Math.max.apply null, values
            x = xfunc set.data[0][0]
            @node.drawValues values, x, maxval[@node.symbol], arg

        arg.column_index = @graph.column ? 1
        arg.order = 'asc'
        opt = ("#{k}=#{v}" for k,v of arg).join "&"
        db  = @graph.db ? 'WIKI'
        req.open 'GET', "#{api}/#{db}/#{@graph.symbol}.json?#{opt}&api_key=#{key}", true
        enqueue req
        
    onMount: =>
                
        @s = Snap()
        @s.attr
            class:    'snap'
            viewBox:  '0 0 1000 100'
            overflow: 'visible'
                            
        bg = @s.rect()
        bg.attr
            id:     @graph.symbol
            class:  'bg'
            width:  1000
            height: 97
            rx:     10
            ry:     10
            
        years = (num, delta, offset) =>
            x = offset
            for y in [0...num]
                mid = @s.line()
                mid.attr
                    class: 'time'
                    x1: x
                    y1: 0
                    x2: x
                    y2: 97
                x += delta
        
        years 13, 12,  12
        years  4, 104, 13*12+104
    
        title = @s.text()
        title.attr
            x:     10
            y:     20
            class: 'title'
            text:  @graph.name ? @graph.symbol
                
        #000       0000000   000   000   0000000 
        #000      000   000  0000  000  000      
        #000      000   000  000 0 000  000  0000
        #000      000   000  000  0000  000   000
        #0000000   0000000   000   000   0000000 
        
        arg = 
            start_date:   "2000-01-01"
            end_date:     "2018-01-01"
            collapse:     "monthly"
            class:        'long'
            scale:        1
            
        @requestData arg, (d) ->
            y = parseInt d.substr 2,2
            m = parseInt d.substr 5,2
            x = (y*12+m)*2
                    
        #00     00  000  0000000  
        #000   000  000  000   000
        #000000000  000  000   000
        #000 0 000  000  000   000
        #000   000  000  0000000  
    
        arg = 
            start_date:   "2013-01-01"
            end_date:     "2018-01-01"
            collapse:     "weekly"
            class:        'mid'
            scale:        2

        if not @graph.monthly
            @requestData arg, -> 13*12

        # 0000000  000   000   0000000   00000000   000000000
        #000       000   000  000   000  000   000     000   
        #0000000   000000000  000   000  0000000       000   
        #     000  000   000  000   000  000   000     000   
        #0000000   000   000   0000000   000   000     000   

        arg = 
            start_date:   "2017-01-01"
            end_date:     "2018-01-01"
            collapse:     "dayly"
            class:        'short'
            scale:        2

        if not @graph.monthly
            @requestData arg, -> 13*12+104*4
            
        @view.appendChild @s.node
        
        if queue.length <= 3
            dequeue()
        
    render: -> tag: 'div'

module.exports = GraphView
