ViewNode = require('../two-trees').ViewNodeSmall


window.renderCalls = 0
class DashboardItem extends ViewNode


    updateCfg: (cfg) ->
        #return false if @item == cfg.item
        (@item = cfg.item) or true


    render: () ->
        tag:       'div'
        className: 'item'
        style:     "background-color: #{@item.color};"
        children: [
            tag: 'label'
            text: @item.val + '%'
        ]


class Dashboard extends ViewNode


    updateCfg: (cfg) ->
        (@data = cfg.data) or true


    render: () ->
        tag: 'div'
        children:
            for item, i in @data
                tag:  DashboardItem
                item: item


module.exports = Dashboard