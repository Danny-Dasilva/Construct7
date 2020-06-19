function getPotency(R::Rotation,state::State)
    potency = 0;
    for action in R
        potency += getPotency(action,state);
        state = updateState(action,state);
    end
    return potency;
end

function modAstralUmbral(action::Action,state::State)
    return 100
end

function getCast(action::Action,state::State,spspeed::Int)
    lvSUB = 380;
    lvDIV = 3300;
    fSPD = floor(130*(spspeed-380)/lvDIV+1000);
    GCD1 = floor((2000-fSPD)*action.cast/1000);
    #  GCD2 = floor((100-action.typeY)*(100-state.haste)/100);
    GCD2 = floor((100-action.typeY)/100);
    GCD3 = (100-action.typeZ)/100;
    GCD4 = floor(Int,floor(ceil(GCD2*GCD3)*GCD1/100)*modAstralUmbral(action,state)/100);
    return GCD4*10#/100;
end

function getRecast(action::Action,state::State,skspeed::Int)
    lvSUB = 380;
    lvDIV = 3300;
    fSPD = floor(130*(skspeed-380)/lvDIV+1000);
    GCD1 = floor((2000-fSPD)*action.recast/1000);
    #  GCD2 = floor((100-action.typeY)*(100-state.haste)/100);
    GCD2 = floor((100-action.typeY)/100);
    GCD3 = (100-action.typeZ)/100;
    GCD4 = floor(Int,floor(ceil(GCD2*GCD3)*GCD1/100)/100);
    return GCD4*10#/100;
end

function updateState(action::Action,state::State)

    if action.isGCD
        state.time = max(state.nextGCD,state.cooldown[action]);
    else
        state.time = max(state.nextOGCD,state.cooldown[action]);
    end

    while state.time >= state.mptick
        state.mana = min(10000,state.mana+200);
        state.mptick += 3000;
    end

    if canUse(action,state)
        if action.isGCD
            state.nextGCD = max(state.time+max(action.recast,action.cast+action.lock),state.nextGCD);
            state.nextOGCD = state.time + action.cast + action.lock;
        else
            state.nextGCD = max(state.time+action.cast+action.lock,state.nextGCD);
            state.nextOGCD = state.time + action.cast + action.lock;
        end
        state.cooldown[action] += action.recast;
        state.mana -= action.mana;
        state.gauge -= action.gauge;
        if action.hasBuff
            state.buff[acton.buff] = state.time + action.buff.duration;
        end
    end
end

function canUse(action::Action,state::State)
    action.range < state.range() && return false;
    state.time < state.cooldown[action] && return false;
    if action.isGCD
        state.time < state.nextGCD && return false;
    else
        state.time < state.nextOGCD && return false;
    end
    action.req(state) || return false;
    return true
end
