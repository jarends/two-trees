ViewNode = require('../two-trees').ViewNode


EXAMPLES = [
    '00-hello-world'
    '01-simple'
    '02-todo'
    '03-bindings'
    '05-quandl'
    #'06-speed'
]


class AppView extends ViewNode


    constructor: () ->
        super()
        window.addEventListener 'hashchange', @updateHash


    updateCfg: () -> @updateHash()


    updateHash: (event) =>
        event.preventDefault() if event
        hash = window.location.hash.slice 1
        if EXAMPLES.indexOf(hash) == -1
            hash = @e ? EXAMPLES[0]

        @update() if @e
        if window.location.hash != hash
           window.location.hash = hash
        @e = hash
        true


    showExample: (e) -> window.location.hash = e


    getLink: (e) ->
        tag:       'a'
        className: 'menu-link' + if e == @e then ' selected' else ''
        text:      e
        onClick:   () => @showExample e


    render: ->
        tag:       'div'
        className: 'row'
        children: [
            tag:   'div'
            style: 'flex: 200px 0 1; min-width: 200px;'
            child:
                tag:       'div'
                className: 'menu'
                children:  [
                    tag: 'img'
                    src: '../../img/two-trees-icon-256.png'
                ,
                    tag:      'ol'
                    children: @getLink e for e in EXAMPLES
                ]
        ,
            tag:       'div'
            className: 'examples'
            style:     'flex: 0px 1 0;'
            child:
                tag:       'iframe'
                className: 'iframe'
                src:       "../#{@e}/index.html"
        ]


module.exports = AppView