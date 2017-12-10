export type Simple = string|number|boolean;


export type Cfg =
{
    tag?:(typeof ViewNode)|string|HTMLElement|Text;
    text?:(() => Simple)|Simple|Text;
    clazz?:typeof ViewNode;

    child?:Cfg|ViewNode;
    children?:Array<Cfg|ViewNode>;
    className?:(() => string)|string;
    style?:(() => {[key: string]:any}|string)|{[key: string]:any}|string;

    keep?:boolean;
    bindings?:{[key: string]:any};

    [key: string]:any;
}


export declare class ViewNode
{
    static DEBUG:boolean;
    static DEFAULT_CLASS:typeof ViewNode;
    static CHECK_DOM:boolean;
    static TAG_KIND:number;
    static TEXT_KIND:number;
    static IGNORES:{[key: string]:boolean};

    cfg:Cfg;
    keep:boolean;
    parent:ViewNode;
    depth:number;

    __id__:number;

    constructor(cfg?:Cfg|Simple);

    appendTo(dom:HTMLElement):ViewNode;
    behind(dom:HTMLElement):ViewNode;
    before(dom:HTMLElement):ViewNode;
    replace(dom:HTMLElement):ViewNode;

    remove(dom:HTMLElement):ViewNode;

    addChild(childOrCfg:ViewNode|Cfg):ViewNode;
    removeChild(child:ViewNode):ViewNode;
    replaceChild(child:ViewNode, newChildOrCfg:ViewNode|Cfg):ViewNode;

    updateCfg(cfg:Cfg):boolean;
    update():void;
    updateNow():void;
    render():Cfg;

    onMount():void;
    onUnmount():boolean;

    onAddedToDom():void;
    onRemovedFromDom():void;
}
