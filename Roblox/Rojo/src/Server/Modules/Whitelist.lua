return setmetatable({
	["Berserker"] = {
	    "EmperorTarkin"
	},
	["Nitro"] = {
		"EmperorTarkin",
		"Synkiii",
		"DannyGames34",
		"TheTopTinker"
	}
}, {
	__index = function(t, k)
		local _t = t
        return _t[k] ~= nil
    end
})

-- ["N/A"] = true,
-- ["N/A"] = true -- ? wth are these for?? were under Berserker key
		