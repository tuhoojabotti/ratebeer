b1 = Brewery.create name:"Koff", year:1897
b2 = Brewery.create name:"Malmgard", year:2001
b3 = Brewery.create name:"Weihenstephaner", year:1042

lager = Style.find_by name:"Lager"
ale = Style.find_by name:"Pale ale"
porter = Style.find_by name:"Porter"
weizen = Style.find_by name:"Weizen"

b1.beers.create name:"Iso 3", style:lager
b1.beers.create name:"Karhu", style:lager
b1.beers.create name:"Tuplahumala", style:lager
b2.beers.create name:"Huvila Pale Ale", style:ale
b2.beers.create name:"X Porter", style:porter
b3.beers.create name:"Hefezeizen", style:weizen
b3.beers.create name:"Helles", style: lager