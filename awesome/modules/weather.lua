local beautiful = require("beautiful")

-- Weather module
local weather = {}

local function matchThis(s, pattern)
   if s == nil then
      return false
   else 
      position = string.find(s,pattern,1)
      if position==nil then
	 return false
      else
	 return true
      end
   end   
end

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function weather.getWeather(paths)
   local weatherinfo = ""
   local weather = ""
   local temp = 0
   --{{{
   -- Create the string with the weather and the temperature info
   command = io.popen(paths.scripts .. "weather.py")
   weathertext = command:read('*a')
   -- Split the string into weather and temp.
   -- weather[1] --> weather
   -- weather[2] --> temperature
   weather = weathertext:split(':')
   weather[2]=tonumber(weather[2])

   -- Uncomment this to substitute text with icons {{{{
   
   -- Rain
--   if matchThis(weather[1], "Rain") or matchThis(weather[1], "Drizzle") then
--      if matchThis(weather[1], "Light") then
--	 weatherinfo = string.format(": %sºC", weather[2])
--      else
--	 weatherinfo = string.format("☔: %sºC", weather[2])
--      end
--      -- Cloudy
--   elseif matchThis(weather[1], "Cloudy") or matchThis(weather[1], "Overcast") then
--      if matchThis(weather[1], "Partly") then
--	 weatherinfo = string.format(" : %sºC ", weather[2])
--      else
--	 weatherinfo = string.format(" : %sºC ", weather[2])
--      end
--   elseif matchThis(weather[1], "Mist") then
--      weatherinfo = string.format(" : %sºC ", weather[2])
--      -- Sunny
--   elseif matchThis(weather[1], "Sunny") or matchThis(weather[1], "Clear") or matchThis(weather[1], "Fair") then
--      weatherinfo = string.format(" : %sºC ", weather[2])
--      -- Snow
--   elseif  matchThis(weather[1], "Snow") then
--      weatherinfo = string.format(" ❄: %sºC ", weather[2])
   --   else
   --}}}}
   weatherinfo = weather[1] .. " " .. weather[2] .. "ºC "
--   end
   --}}}

   --{{{
   -- Colorize the string according to the temperature
   if weather[2] ~= nil and weather[2]~="N/A" then
      if weather[2] >= 40 then
	 weatherinfo = string.format('<span color="%s"> %s </span>', beautiful.red, weatherinfo)
      elseif weather[2] >= 30 then
	 weatherinfo = string.format('<span color="%s"> %s </span>', beautiful.yellow, weatherinfo)
     elseif weather[2] >= 20 then
	 weatherinfo = string.format('<span color="%s"> %s </span>', beautiful.green, weatherinfo)
      elseif weather[2] >= 10 then
	 weatherinfo = string.format('<span color="%s"> %s </span>', beautiful.blue, weatherinfo)
      elseif weather[2] >= 0 then
	 weatherinfo = string.format('<span color="%s"> %s </span>', beautiful.aqua, weatherinfo)
      else
	 weatherinfo = string.format('<span color="%s"> %s </span>', beautiful.white, weatherinfo)
      end
   end
   --}}}
   return weatherinfo
end

return weather
