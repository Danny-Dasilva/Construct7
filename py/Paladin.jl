#  module Paladin

include("structs.jl")


Actions = [
           ["Fast Blade","Weaponskill",200,200,"",true,0,2500,700,0,0,nothing,0,0,true],
           ["Fight of Flight","Ability",0,0,"",false,0,60000,700,0,0,nothing,0,0,true]
          ]

Action.(Actions)
#  end
