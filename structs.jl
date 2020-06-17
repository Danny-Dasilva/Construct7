struct Buff

end

struct Action
    name::String
    type::String
    potency::Int
    comboPotency::Int
    comboAction::String
    isGCD::Bool
    cast::Int
    recast::Int
    lock::Int
    typeY::Int
    typeZ::Int
    buff::Union{Buff,Nothing}
    mana::Int
    gauge::Int
    req::Union{Function,Bool}
    Action(A::Array) = new(A...)
end

struct Rotation
    data::Array{Action}
end

struct State
    time::Int
    nextGCD::Int
    nextOGCD::Int
    mana::Int
    mptick::Int
    gauge::Int
    cooldown::Dict{Action,Int}
    buff::Dict{Buff,Int}
    range::Function
end
