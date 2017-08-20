CompNode = require('../two-trees').CompNode


EXAMPLES = [
    '00-hello-world'
    '01-simple'
    '02-todo'
    '03-bindings'
    '06-speed'
]


class IFrame extends CompNode

    render: () ->
        tag: 'iframe'
        className: 'iframe'
        src: '../02-todo'



class AppView extends CompNode


    updateCfg: (cfg) ->
        super()
        @data = @tree.root


    getLink: (e) ->
        tag:       'a'
        className: 'menu-link'
        text:      e
        onClick:   () => @iframe.view.src = "../#{e}/index.html"

        
    render: ->

        @iframe = new IFrame() if not @iframe

        tag: 'div'
        className: 'row'
        children: [
            tag:   'div'
            style: 'flex: 300px 0 1; min-width: 200px;'
            child:
                tag:       'div'
                className: 'menu'
                children: [
                    tag: 'h2', text: 'two-trees examples'
                ,
                    tag:       'ol'
                    children: @getLink e for e in EXAMPLES

                ,
                    tag: 'img'
                    src: '../../img/two-trees-icon-256.png'
                ]
        ,
            tag:   'div'
            className: 'examples'
            style: 'flex: 0px 1 0;'
            child: @iframe
        ]


module.exports = AppView