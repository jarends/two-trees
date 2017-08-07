_ = require './utils'




#    000   000  000  00000000  000   000        000   000   0000000   0000000    00000000
#    000   000  000  000       000 0 000        0000  000  000   000  000   000  000     
#     000 000   000  0000000   000000000        000 0 000  000   000  000   000  0000000 
#       000     000  000       000   000        000  0000  000   000  000   000  000     
#        0      000  00000000  00     00        000   000   0000000   0000000    00000000

class ViewNode

    @DEBUG         = false
    @CHECK_DOM     = false
    @DEFAULT_CLASS = @
    @TEXT_KIND     = 0
    @TAG_KIND      = 1

    @create = (cfg) -> ViewTree.create cfg
    @map    = (tag, clazz, overwrite = false) -> ViewTree.map tag, clazz, overwrite
    @unmap  = (tag) -> ViewTree.unmap tag

    constructor: (cfg) ->
        @register  cfg
        @updateCfg cfg
        @updateNow()


    register:   (cfg) -> ViewTree.register   @, cfg
    updateNow:  ()    -> ViewTree.updateNow  @
    createView: (cfg) -> ViewTree.createView @, cfg

    # add nodes view to dom
    appendTo: (dom) -> ViewTree.appendTo @, dom
    behind:   (dom) -> ViewTree.behind   @, dom
    before:   (dom) -> ViewTree.before   @, dom
    replace:  (dom) -> ViewTree.replace  @, dom
    remove:   (dom) -> ViewTree.remove   @, dom

    # direct dom manipulation
    addChild:      (child) ->        ViewTree.addChild      @, child
    addChildAt:    (child, index) -> ViewTree.addChildAt    @, child, index
    removeChild:   (child) ->        ViewTree.removeChild   @, child
    removeChildAt: (index) ->        ViewTree.removeChildAt @, index

    # timed dom manipulation
    updateCfg: (cfg) -> (@cfg = cfg) or true
    update:    () => ViewTree.update @
    render:    () -> @cfg

    dispose: () ->

    onMount:   () ->
    onUnmount: () -> @keep
    onAdded:   () ->
    onRemoved: () ->




#    00000000  000   000  00000000    0000000   00000000   000000000
#    000        000 000   000   000  000   000  000   000     000   
#    0000000     00000    00000000   000   000  0000000       000   
#    000        000 000   000        000   000  000   000     000   
#    00000000  000   000  000         0000000   000   000     000   

if typeof module != 'undefined'
    module.exports = ViewNode
    ViewTree       = require './view-tree'
if typeof window != 'undefined'
    window.ViewNode = ViewNode
else
    this.ViewNode = ViewNode
