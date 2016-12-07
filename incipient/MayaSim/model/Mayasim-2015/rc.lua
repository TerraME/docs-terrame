function rc(cell)
    local x = cell.step
    local out = 0
    
        if x >=   0 and x <  56 then out =   20 - (15/28) * x^1
    elseif x >=  56 and x < 112 then out =  -40 + (15/28) * x^1
    elseif x >= 112 and x < 168 then out =   80 - (15/28) * x^1
    elseif x >= 168 and x < 224 then out = -100 + (15/28) * x^1
    elseif x >= 224 and x < 280 then out =  140 - (15/28) * x^1
    elseif x >= 280 and x < 336 then out = -160 + (15/28) * x^1
    elseif x >= 336 and x < 392 then out =  200 - (15/28) * x^1
    elseif x >= 392 and x < 448 then out = -220 + (15/28) * x^1
    elseif x >= 448 and x < 504 then out =  260 - (15/28) * x^1
    elseif x >= 504 and x < 560 then out = -280 + (15/28) * x^1
    elseif x >= 560 and x < 616 then out =  320 - (15/28) * x^1
    elseif x >= 616 and x < 672 then out = -340 + (15/28) * x^1 end

    return 1 + out/100
end