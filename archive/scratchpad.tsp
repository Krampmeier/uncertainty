function getResistanceBaseUncertainty(reading, range, calInterval) -- return measurement uncertainty in A
    local uncertOfReading = 0
    local uncertOfRange = 0
    if(calInterval == calibrationInterval_24h) then
        if range == 1 then
            return reading * 0.0080/100 + range * 0.0200/100
        elseif range == 10 then
            return reading * 0.020/100 + range * 0.0020/100
        elseif range == 100 then
            return reading * 0.020/100 + range * 0.0020/100
        elseif range == 1000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 10000 then   -- 10k
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 100000 then  -- 100k
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 1000000 then -- 1 Meg
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 10000000 then -- 10 Meg
            return reading * 0.0150/100 + range * 0.0006/100
        elseif range == 100000000 then -- 100 Meg
            return reading * 0.140/100 + range * 0.0030/100
        end
    elseif(calInterval == calibrationInterval_90days) then
        if range == 1 then
            return reading * 0.0080/100 + range * 0.0200/100
        elseif range == 10 then
            return reading * 0.080/100 + range * 0.0020/100
        elseif range == 100 then
            return reading * 0.075/100 + range * 0.0020/100
        elseif range == 1000 then
            return reading * 0.065/100 + range * 0.0006/100
        elseif range == 10000 then   -- 10k
            return reading * 0.065/100 + range * 0.0006/100
        elseif range == 100000 then  -- 100k
            return reading * 0.070/100 + range * 0.0010/100
        elseif range == 1000000 then -- 1 Meg
            return reading * 0.075/100 + range * 0.0006/100
        elseif range == 10000000 then -- 10 Meg
            return reading * 0.0200/100 + range * 0.0010/100
        elseif range == 100000000 then -- 100 Meg
            return reading * 0.2000/100 + range * 0.0030/100
        end
    elseif(calInterval == calibrationInterval_1year) then
        if range == 1 then
            return reading * 0.0080/100 + range * 0.0200/100
        elseif range == 10 then
            return reading * 0.020/100 + range * 0.0020/100
        elseif range == 100 then
            return reading * 0.020/100 + range * 0.0020/100
        elseif range == 1000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 10000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 100000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 1000000 then -- 1 Meg
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 10000000 then -- 10 Meg
            return reading * 0.0150/100 + range * 0.0006/100
        elseif range == 100000000 then -- 100 Meg
            return reading * 0.140/100 + range * 0.0030/100
        end
    elseif (calInterval == calibrationInterval_2years) then
        if range == 1 then
            return reading * 0.0080/100 + range * 0.0200/100
        elseif range == 10 then
            return reading * 0.020/100 + range * 0.0020/100
        elseif range == 100 then
            return reading * 0.020/100 + range * 0.0020/100
        elseif range == 1000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 10000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 100000 then
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 1000000 then -- 1 Meg
            return reading * 0.020/100 + range * 0.0006/100
        elseif range == 10000000 then -- 10 Meg
            return reading * 0.0150/100 + range * 0.0006/100
        elseif range == 100000000 then -- 100 Meg
            return reading * 0.140/100 + range * 0.0030/100
        end
    end
end

function getResistanceAdditionalUncertainty(reading, range, calInterval)
    local noiseOfRange = 0
    local noiseFixedValue = 0
    local noAutoZeroUncertOfRange = 0
    local noAutoZeroUncertFixedValue = 0
    local nplc = dmm.measure.nplc -- numeric
    local lineSyncState = dmm.measure.linesync -- dmm.OFF or dmm.ON
    local autoZeroState = dmm.measure.autozero.enable -- dmm.OFF or dmm.ON

    -- handle MEASUREMENT NOISE CHARACTERISTICS
    if(nplc < 0.01) then -- spec sheet specifies 0.0005 PLC, I assume the values are valid from 0.0005 - 0.01 PLC
        noiseOfRange = 0.0200/100
        noiseFixedValue = 5e-9 -- 5 nA
    elseif (nplc < 0.1) then -- spec sheet specifies 0.01 PLC, I assume the values are valid from 0.01 - 0.1 PLC
        noiseOfRange = 0.0030/100
        noiseFixedValue = 5e-9
    elseif (nplc < 1.0) then -- spec sheet specifies 0.1 PLC, I assume the values are valid from 0.1 - 1 PLC        
        if(lineSyncState == dmm.OFF) then
            noiseOfRange = 0.0015/100
            noiseFixedValue = 5e-9
        else -- line sync on
            noiseOfRange = 0.0009/100
            noiseFixedValue = 10e-12 -- 10 pA
        end
    -- no additional noise penalty for NPLC >= 1
    end

    -- handle "autozero off" penalty
    if(autoZeroState == dmm.OFF) then
        noAutoZeroUncertOfRange = 0.015/100 -- assuming worst specified case: within ±5 °C and ≤ 60 minutes since last autozero
        noAutoZeroUncertFixedValue = 0.0 -- none specified
    end
    return range * (noiseOfRange + noAutoZeroUncertOfRange) + noiseFixedValue + noAutoZeroUncertFixedValue    
end
