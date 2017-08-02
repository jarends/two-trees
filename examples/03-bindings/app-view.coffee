ViewNode = require('../two-trees').ViewNode


class AppView extends ViewNode


    constructor: (cfg) ->
        super cfg


    updateCfg: (cfg) ->
        super cfg
        @data = @tree.root


    render: () ->
        tag: 'div'
        children: [
            tag:       'h1'
            className: 'my-class'
            onClick: () =>
                ++@data.clicks
                @data.bgGreen = (Math.random() * 100 + 155) >> 0
                @tree.update()
            children:  [
                tag:      'div'
                style:    () => "padding: 20px; background-color: rgb(0,#{@data.bgGreen},0);"
                bindings: [
                    [@data, 'bgGreen']
                    [@data, 'clicks']
                ]
                children: () =>
                    if @data.clicks
                        @data.title + " clicks: #{@data.clicks}"
                    else
                        @data.title + ' click me!'
            ]
        ,
            tag:      'button'
            disabled:  () => @data.clicks == 0
            onClick:   () => @tree.undo()
            bindings: [
                [@data, 'clicks']
            ]
            children: 'undo'
        ,
            tag:      'button'
            disabled: () => @data.clicks >= @tree.history.length
            onClick:  () => @tree.redo()
            bindings: [
                [@data, 'clicks']
            ]
            children: 'redo'
        ]




module.exports = AppView