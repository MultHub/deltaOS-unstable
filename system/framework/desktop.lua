oldPullEvent = os.pullEvent

os.pullEvent = os.pullEventRaw

--local function init()

build = 68.4

local isDialog = false

local width = kernel.x
local height = kernel.y

local tab = {
  {
    y = 2,
    x = 1,
    name = "Shell",
    exec = "system/icons/shell.exc",
    icon = "system/icons/shell.nft",
    isNFT = true,
  },
  {
    y = 2,
    x = 7,
    name = "IcoC",
    exec = "system/icons/icoc.exc",
    icon = "system/icons/icoc.nft",
    isNFT = true,
  },
  {
    y = 2,
    x = 10,
    name = "Updt",
    exec = "system/icons/update.exc",
    icon = "system/icons/update.nft",
    isNFT = true,
  },
  {
    y = 2,
    x = 13,
    name = "CookieClicker",
    exec = "system/icons/cookie.exc",
    icon = "system/icons/cookie.img",
    isNFT = false,
  },
  {
    y = 3,
    x = 1,
    name = "CCUG",
    exec = "system/icons/cookie2.exc",
    icon = "system/icons/cookie2.img",
    isNFT = false,
  },
  {
    y = 3,
    x = 4,
    name = "Ink",
    exec = "system/icons/ink.exc",
    icon = "system/icons/ink.nft",
    isNFT = true,
  },
  {
    y = 3,
    x = 7,
    name = "Sketch",
    exec = "system/icons/sketch.exc",
    icon = "system/icons/sketch.img",
    isNFT = false,
  },
  {
  	y = 3,
  	x = 10,
  	name = "LIDE",
  	exec = "system/icons/luaide.exc",
  	icon = "system/icons/luaide.nft",
  	isNFT = true,
  },
}
if not fs.exists("system/.appdata") then
	local hand = fs.open("system/.appdata","w")
	hand.write(textutils.serialize(tab))
	hand.close()
end
		
rdnt = false
appsdir = "system/apps"
appsfle = "system/.appdata"
gridsze = 5 --x=gridsze*c[x]+1
dbclk = 0.6

asel = 0
lclk = os.clock()
grid = false

function getGridMax()
 return math.floor(width/gridsze),math.floor((height-1)/gridsze)
end

function isTaken(x,y)
 for k,v in pairs(apps) do
  if apps[k].x==x and apps[k].y==y then
   return true
  end
 end
 return false
end

function saveInfo()
 kernel.saveToFile(apps,"system/.appdata")
end

local function mainDesktop()

local function getIcons()
 apps = {}
 local m = fs.open(appsfle,"r")
 apps = textutils.unserialize(m.readAll())
 for i=1,#tab do
  local fnd = false
  for j=1,#apps do
   if apps[j].exec==tab[i].exec then
    fnd = true	
   end
  end
  if not fnd then
   table.insert(apps,tab[i])	
  end
 end
 m.close()
end
getIcons()

n = {  }
local isAppOpen = false
local redraw = false


isUnstable = true

fullBuildName = "DeltaOS Unstable(build "..build..")"

os.loadAPI("/apis/users")


local function getC()
 return term.current()
 
end

local gc = getC()



local function loginScr()

local function maxRead(w,c,str)
	w = w and w-1 or 10
	
	term.setCursorBlink(true)
	local x,y = term.getCursorPos() --get original cursor x,y
	
	local s = str or "" --string
	local ds = "" --displayed string
	
	ds = s
	if (c) then
		ds = string.rep(c,#s)
	end
	
	term.setCursorPos(x,y)
	term.write(string.rep(" ",w+1))
	term.setCursorPos(x,y)
	term.write(string.sub(ds,(#s-w >= 1) and #s-w or 1,#s))
	
	local toNext
	
	while true do --main loop
		local e,p,cx,cy = os.pullEvent() --pull event
		
		if e == "char" then --character was pressed
			s = s..p --append typed character to string
		elseif e == "key" then --key was pressed
			if p == keys.enter then --return/enter
				toNext = true
				break --break the loop
			elseif p == keys.backspace then --backspace
				s = string.sub(s,1,#s-1) --remove last character from string
			end
		elseif e == "mouse_click" then
			if (cx < x) or (cx > x+w) or (cy ~= y) then
				break
			end
		end
		
		ds = s
		if (c) then
			ds = string.rep(c,#s)
		end
		
		term.setCursorPos(x,y)
		term.write(string.rep(" ",w+1))
		term.setCursorPos(x,y)
		term.write(string.sub(ds,(#s-w >= 1) and #s-w or 1,#s))
	end
	
	term.setCursorBlink(false)
	return s,toNext --return the string
end

local bgSetting = nil --settings.getSetting("desktop",2)
local bgColor,bgImage
if (type(bgSetting) == "string") then
	if (fs.exists(bgSetting)) then
		bgImage = bgSetting
	else
		bgColor = colors.white
	end
elseif (type(bgSetting) == "number") then
	bgColor = bgSetting
else
	bgColor = colors.white
end

local function drawBackground()
	if (bgColor) then
		term.setBackgroundColor(bgColor)
		term.clear()
	elseif (bgImage) then
		term.clear()
		graphics.drawImage(bgImage, 1, 1)
	else
		term.setBackgroundColor(colors.white)
		term.clear()
	end
end

drawBackground()

local w,h = term.getSize()

term.setBackgroundColor(colors.lightGray)
term.setCursorPos(2,4)
term.write(string.rep(" ",w-2))
term.setCursorPos(2,7)
term.write(string.rep(" ",w-2))

term.setBackgroundColor(colors.white)
term.setTextColor(colors.black)
term.setCursorPos(2,3)
term.write("Username")
term.setCursorPos(2,6)
term.write("Password")

local button = {
	new = function(self,s,x,y,b,t)
		return setmetatable({s=s,x=x,y=y,b=b,t=t},{__index=self})
	end,
	draw = function(self)
		term.setBackgroundColor(self.b)
		term.setTextColor(self.t)
		term.setCursorPos(self.x,self.y)
		term.write(self.s)
	end,
	isClicked = function(self,cx,cy)
		return ((cx >= self.x) and (cx <= self.x+#self.s-1) and (cy == self.y))
	end
}

local login = button:new(" Login ",2,h-1,colors.green,colors.black)
local shutdown = button:new(" Shutdown ",w-10,h-1,colors.red,colors.black)

if (pocket) then
	login.x = w/2 - #login.s/2
	login.y = h-3
	login.s = " "..login.s.."  "
	shutdown.x = w/2 - #shutdown.s/2 + 1
end

login:draw()
shutdown:draw()

local function checkForOld(usern, actualPass)
  usern = tostring(usern)
  actualPass = tostring(actualPass)
  hPassword = tostring(users.getPassword(usern))
  if hPassword == sha256.sHash(actualPass, usern) then
    return true
  elseif actualPass == hPassword then
    return true
  elseif hPassword == sha256.hash(actualPass) then
    return true
  end
  return false
end

--select "username" input
os.queueEvent("mouse_click",1,2,4)

local username,password = "",""
while true do
	local e,_,x,y = os.pullEvent("mouse_click")
	
	if (x >= 2) and (x <= w-1) then
		if (y == 4) then
			term.setBackgroundColor(colors.lightGray)
			term.setCursorPos(2,4)
			local toNext
			username,toNext = maxRead(w-2,nil,username)
			
			if (toNext) then
				os.queueEvent("mouse_click",1,2,7)
			end
		elseif (y == 7) then
			term.setBackgroundColor(colors.lightGray)
			term.setCursorPos(2,7)
			password = maxRead(w-2,"*",password)
			
			--click the login button
			os.queueEvent("mouse_click",1,login.x,login.y)
		end
	end
	if (login:isClicked(x,y)) then
		if (users.isUser(tostring(username)) == true and users.getPassword(username) == sha256.sHash(password, password)) or (users.isUser(tostring(username)) == true and checkForOld(username, password)) then
      if checkForOld(username, password) == true then
        users.changePass(username, sha256.sHash(password, password))
      end
			users.login(username)
			break
			
		else 
			term.setCursorPos(1, 1)
			term.setTextColor(colors.red)
			graphics.cPrint("Invalid username and/or password")
			term.setTextColor(colors.black)
		end
			
	elseif (shutdown:isClicked(x,y)) then
		os.shutdown()
	end
end

end

loginScr()

local latest = http.get("https://raw.githubusercontent.com/FlareHAX0R/deltaOS-unstable/master/version")
if tonumber(latest.readAll()) > build then
	graphics.reset(colors.white, colors.black)
	print(" ")
	newVer = tostring(latest.readAll())
	graphics.cPrint( "Updating DeltaOS to build "..newVer.."!" )
	shell.run("/system/update")
end

if settings.getSetting("desktop", 4) == true then
 animations.wake()
end	




dofile("/system/sApi/dialog")


local function drawBar()
	graphics.drawLine( 1, settings.getSetting("desktop", 3) )

	term.current().setCursorPos( kernel.x-(kernel.x-1), kernel.y-(kernel.y-1))

	term.current().write("D")
end

local function findSpace(elim)
 --TODO; MAKE DIS
 local tx,ty = getGridMax()
 for i=1,tx do
  for j=1,ty do
   if not isTaken(i,j) then
    return true,i,j
   end
  end
 end
 return false
end

local function drawApps()
 --Format apps
 --icon,name,exec,x,y
 for k,v in pairs(apps) do
--  print(apps[k][4])
--  print(apps[k][5])
  local gx,gy = getGridMax()
  if apps[k].x>gx or apps[k].y>gy then
   local _,tx,ty = findSpace(k)
   if _ then
    apps[k].x=tx
    apps[k].y=ty
    saveInfo()
   end
  end
--====================================================================================
  if apps[k].isNFT then
    graphics.drawNFT(apps[k].icon,(apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+3)
  else
    graphics.drawImage(apps[k].icon,(apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+3)
  end
  term.setCursorPos((apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+6)
  term.setBackgroundColor(asel==k and colors.blue or colors.lightBlue)
  write(string.rep(" ",gridsze-1))
  term.setCursorPos((apps[k].x-1)*gridsze+2,(apps[k].y-1)*gridsze+6)
  term.setTextColor(colors.black)
  write(apps[k].name:sub(1,gridsze-1))
 end
end

local function drawGrid()
 term.setBackgroundColor(colors.lightBlue)
 for i=1,math.floor(width/gridsze)+1 do
  for j=2,height do
   term.setCursorPos((i-1)*gridsze+1,j)
   write("|")
  end
 end
 for i=1,math.floor(height/gridsze)+1 do
  term.setCursorPos(1,(i-1)*gridsze+2)
  write(string.rep("-",width))
 end
end

local function draw(ua)
	
local cUser = users.getUserName()

local isI = false

if settings.getSetting("desktop", 1) == "color" then
	isI = true
	graphics.reset( settings.getSetting("desktop", 2 ), colors.black )
elseif settings.getSetting("desktop", 1) == "image" then
	local imgPath = tostring( settings.getSetting("desktop", 2) )
	graphics.drawImage(imgPath, 1, 2)
end
graphics.drawLine( kernel.y, settings.getSetting("desktop", 3) )
	

term.current().setCursorPos(kernel.x-(kernel.x-1), 1)
if ua==nil then ua=true end
drawBar()
if ua then getIcons() end
if grid then drawGrid() end
drawApps()

if isUnstable then
 term.current().setBackgroundColor( settings.getSetting("desktop", 3) )
 term.current().setCursorPos(kernel.x-string.len(fullBuildName)+1, kernel.y)
 write(fullBuildName)
 term.current().setCursorPos(1, 1)
end

term.setCursorPos(kernel.x-cUser:len()+1, 1)
write(cUser)

end







--os.loadAPI("/system/tabserv")

draw()

local function timeout(s)
 sleep(s)
 return true
end

local function rtz(n)
 if n<0 then return 0 else return n end
end

local function dragIcon(iID)
 if apps[iID] then
  local ids
  while ids~=1 do
   ids=parallel.waitForAny(function() timeout(0.15) end,
   function()
    local _,_,x,y = os.pullEvent("mouse_drag")
    local tpx = rtz(math.floor((x-1)/gridsze))+1
    local tpy = rtz(math.floor((y-2)/gridsze))+1
    local gx,gy = getGridMax()
    if not isTaken(tpx,tpy) and tpx<=gx and tpy<=gy then
     apps[iID].x=tpx
     apps[iID].y=tpy
    end
   end)
   draw(false)
  end
  saveInfo()
  return true
 else
  return false
 end
end

--[[
function isTaken(x,y)
 for k,v in pairs(apps) do
  if apps[k]["x"]==x and apps[k]["y"]==y then
   return true 
  end
 end
 return false
end
]]--

--function getGridMax()
-- local x,y = kernal.x,kernal.y
-- return math.floor(x/gridsze),math.floor(y/gridsze)
--end

local function shellServ() 
while true do
 local e,b,x,y = os.pullEvent()
 if e=="mouse_click" or e=="mouse_drag" or e=="monitor_touch" then
	if x==kernel.x-(kernel.x-1) and y==kernel.y-(kernel.y-1) and b==2 and event ~= "monitor_touch" then
		local d = Dialog.new(nil, nil, nil, nil, "DeltaOS", {"Do you want to", "shutdown?"}, true,true)
		if d:autoCaptureEvents() == "ok" then
			draw()
			
			if settings.getSetting("desktop", 4) == true then
			 animations.shutdown()
			end
			graphics.reset(colors.black, colors.white)
			--term.setCursorPos(1, 2)
			--isAppOpen = true
			--print("Run 'exit' to go back to deltaOS")
			--shell.run("/rom/programs/shell")
   			saveInfo()
   			os.shutdown()
			--isAppOpen = false
			--animations.wake()
			--draw()
		else
      draw()
		end
	else
  local found = false
  for k,v in pairs(apps) do
   local xs,ys = (apps[k].x-1)*gridsze,(apps[k].y-1)*gridsze
   --local xs,ys = 3,4
   --print(kernal.inSpan) read()
   
   if kernel.inSpan(xs+2,ys+3,xs+5,ys+6,x,y) then
    if e=="mouse_drag" then
     if asel~=k then asel=k;draw(false) end
     dragIcon(k)
    else
     if asel==k then
      if os.clock()-lclk<=dbclk then
       if settings.getSetting("desktop", 4) == true and settings.getSetting("desktop", 5) == false then
        animations.closeIn()
       end
       graphics.reset(colors.black,colors.white)
       os.pullEvent = oldPullEvent
       
       if settings.getSetting("desktop", 5) == true then
        local tID = shell.openTab(apps[k]["exec"])
        shell.switchTab(tID)
       else
        shell.run(apps[k]["exec"])
       end
       oldPullEvent = os.pullEvent
       os.pullEvent = os.pullEventRaw
       if grid then drawGrid() end
       if settings.getSetting("desktop", 4) == true then
        animations.wake()
       end
       draw()
      end
     else
      asel=k
      draw()
     end 
     lclk=os.clock()
    end
    found=true
    break
   end
  end
  if not found then
   asel=0
   draw()
  end
  end
 elseif e=="key" then
  if b==67 then
   grid = not grid
   draw()
  end
 end
 end
end



local function sleepServ()
 while true do
 	local event, key = os.pullEvent("key")
 	if key == 59 then
    if settings.getSetting("desktop", 4) == true then
 		 animations.sleep()
    else
     graphics.reset(colors.black, colors.white)
    end

 		local event = os.pullEvent()
 		if event == "key" or event == "mouse_click" or event == "monitor_touch" then
 			os.sleep(0.1)
 			if settings.getSetting("desktop", 4) == true then
 			 animations.wake()
 			end
 			os.sleep(0.1)
 		
 			draw()
 		end
 	end
 end
end




local function firewall()
 shell.run("/system/digitalarmor/firewall")
end

local function PaP()
  while true do
    local event, side = os.pullEvent("peripheral")
    if side ~= nil then
      local win = dwin.cWindow(27, 10)
      local per = peripheral.getType(side)
      if per == "modem" and peripheral.call(side, "isWireless") == true then
        per = "Wireless Modem"
      elseif per == "modem" and peripheral.call(side, "isWireless") ~= true then
        per = "Wired Modem"
      end
      if per == "monitor" and peripheral.call(side, "isColor") == true then
        per = "Adv. Monitor"
      elseif per == "monitor" and peripheral.call(side, "isColor") ~= true then
        per = "Monitor"
      end
      if per == "chatbox" then
        per = "Chatbox"
      end
      if per == "drive" then
        per = "Disk Drive"
      end
      if per == "nil" or per == nil then
        per = "Unknown"
      end
      if per == "printer" then
        per = "Printer"
      end
      if per == "computer" then
        per = "Computer"
      end
      if per == "turtle" then
        per = "Turtle"
      end

      graphics.red_reset(win, colors.white, colors.black)
      graphics.red_drawLine(win, 1, colors.lightGray)
      graphics.red_cPrint(win, "Plug & Play", 1)
      win.setBackgroundColor(colors.white)
      win.setTextColor(colors.black)
      win.setCursorPos(1, 2)
      win.write("A device has been attached")
      graphics.red_cPrint(win, "The device type is:", 3)
      graphics.red_cPrint(win, per, 4)

      graphics.red_cPrint(win, "Click anywhere or press", 6)
      graphics.red_cPrint(win, "ENTER to return.", 7)
      while true do
        local event, char = os.pullEvent()
        if event == "key" and char == 28 then
          draw()
          break
        elseif event == "mouse_click" then
          break
        end
      end



    end
  end
end

parallel.waitForAll(sleepServ, shellServ, firewall, PaP)
end






mainDesktop()  

kernel.saveToFile(apps,"system/.appdata")
--end


--init()
