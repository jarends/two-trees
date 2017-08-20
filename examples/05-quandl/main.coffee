trees    = require '../two-trees'
AppView  = require './app-view'

DataTree = trees.DataTree
ViewNode = trees.ViewNode
CompNode = trees.CompNode

ViewNode.DEFAULT_CLASS = CompNode

model = new DataTree graphs: [
    symbol: 'AAPL'
    name:   'APPLE'
    column: 11
, 
    symbol: 'TSLA'
    name:   'TESLA'
    column: 11
, 
    symbol: "FB"
    name:   'FACEBOOK'
    column: 11
,
    symbol: "GOOGL"
    name:   'GOOGLE'
    column: 11
,
    symbol: "AMZN"
    name:   'AMAZON'
    column: 11
,
    symbol: "MSFT"
    name:   'MICROSOFT'
    column: 11
,
    symbol: "BA"
    name:   'BOEING'
    column: 11
,
    symbol: "LMT"
    name:   'LOCKHEED MARTIN'
    column: 11
,
    symbol: "NOC"
    name:   'NORTHROP GRUMMAN'
    column: 11
,    
    symbol: 'BAC'
    name:   'BANK OF AMERICA'
    column: 11
,
    symbol: 'MS'
    name:   'MORGAN STANLEY'
    column: 11
,    
    symbol: 'GS'
    name:   'GOLDMAN SACHS'
    column: 11
,
    symbol: 'JPM'
    name:   'JPMORGAN CHASE'
    column: 11
,
    symbol: 'WFC'
    name:   'WELLS FARGO'
    column: 11
,
    symbol: 'USB'
    column: 11
,
    symbol: 'PNC'
    column: 11
,
    symbol: 'COF'
    name:   'CAPITAL ONE'
    column: 11
,
    db:     'FSE'
    symbol: 'BMW_X'
    name:   'BMW'
,    
    db:     'FSE'
    symbol: 'DAI_X'
    name:   'DAIMLER'
,    
    db:     'FSE'
    symbol: 'VOW3_X'
    name:   'VW'
,    
    db:     'FSE'
    symbol: 'SIE_X'
    name:   'SIEMENS'
,    
    db:     'FSE'
    symbol: 'BAYN_X'
    name:   'BAYER'
,    
    db:     'FSE'
    symbol: 'SPR_X'
    name:   'SPRINGER'
,    
    db:     'FSE'
    symbol: 'DBK_X'
    name:   'DEUTSCHE BANK'
,    
    db:     'FSE'
    symbol: 'CBK_X'    
    name:   'CITIBANK'
,
    symbol: 'AU_LAM'
    name:   "GOLD"
    db:     'COM'
, 
    symbol: "AG_USD"
    name:   "SILVER"
    db:     'COM'
,
    symbol: "OIL_BRENT"
    name:   "OIL"
    db:     'COM'
,
    symbol: "COPPER"
    name:   "COPPER"
    db:     'COM'
,
    symbol: "PNFUEL_INDEX"
    name:   "NON FUEL"
    db:     'COM'
    monthly:    true
,
    symbol: "PFOOD_INDEX"
    name:   "FOOD"
    db:     'COM'
    monthly:    true
,
    symbol: "PMAIZMT_USD"
    name:   "CORN"
    db:     'COM'
    monthly:    true
,
    symbol: "PWHEAMT_USD"
    name:   "WHEAT"
    db:     'COM'    
    monthly:    true
,
    symbol: "PRICENPQ_USD"
    name:   "RICE"
    db:     'COM'    
    monthly:    true
,
    symbol: "PSUGAUSA_USD"
    name:   "SUGAR"
    db:     'COM'    
    monthly:    true
]

app = new AppView
    inject:
        tree: model
        
app.appendTo document.querySelector '.app'

window.model = model
window.data  = model.root
