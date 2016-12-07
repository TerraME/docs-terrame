--IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
--II Games on Cellular Spaces for studying mobility                     II
--II                                                                    II
--II Pedro Ribeiro de Andrade Neto                                      II
--II Last change: 20160129                                              II
--IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

math.randomseed(os.time())

math.random(); math.random()

-- environment
PLAYERS_PROPORTION = 3
INITIAL_MONEY      = 200
--TURNS              = 3500

-- players
--STRATEGIES = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
STRATEGIES = {0.1, 0.5, 1.0}

-- threshold for changing cell
THRESHOLD = -20

-- how much each player gains after each game?
GAIN = 0.0

SHOW_PLAYERS   = true
SHOW_MOVEMENTS = false
SHOW_OWNERS    = true
SHOW_MONEY     = false
SHOW_BALANCE   = false

SHOOT     = 1
NOT_SHOOT = 0

players__         = {}
movements__       = {}
owners__          = {}
money__           = {}
balance__         = {}
count__           = 0
qtty_strategies__ = #STRATEGIES

changed = false


function Game(p1, p2)
	if p1 == SHOOT     and p2 == SHOOT     then return {-10,-10} end
	if p1 == SHOOT     and p2 == NOT_SHOOT then return {  1, -1} end
	if p1 == NOT_SHOOT and p2 == SHOOT     then return { -1,  1} end
	if p1 == NOT_SHOOT and p2 == NOT_SHOOT then return {  0,  0} end
end

-- these functions work with a vector of numbers, indicating positions of a vector of players

function RemoveOneIfOdd(players)	
	if (#players % 2) == 1 then
		table.remove(players, math.random(1, #players))
	end

	return players
end

function GamesTable(cell)
	local vplayers   = {}
	local vconfronts = {}

	local players = cell:getAgents()
	local tp = #players

	for i = 1, tp, 1 do
		vplayers[i] = i
	end	

	local p = tp
	for i = 1, tp, 1 do
		pos = math.random(1, p)
		vconfronts[i] = vplayers[pos]
		table.remove(vplayers, pos)
		p = p - 1
	end
	
	return RemoveOneIfOdd(vconfronts)	
end

-- return the strategy for a player. it cycles all STRATEGIES.
function InitialStrategy()
	count__ = (count__ + 1) % qtty_strategies__
	return STRATEGIES[count__ + 1]
end


agent = Agent{
	money    = INITIAL_MONEY,
	balance  = 0,
	init = function(self)
		self.strategy = InitialStrategy()
	end,
	play = function(player)
		if math.random() <= player.strategy then
			return SHOOT
		else
			return NOT_SHOOT
		end
	end,
	changeMoney = function(player, value)
		player.money   = player.money   + value
		player.balance = player.balance + value
	end,
	execute = function(player)
		if player.money <= 0 then -- leave the game
			pos = PositionOfStrategy(player)
			players__[pos] = players__[pos] - 1
			player:die()
		elseif player.balance < THRESHOLD then -- leave the cell
			pos = PositionOfStrategy(player)
			movements__[pos] = movements__[pos] + 1

			player.balance = 0
			player:walk()
		end
	end
}

function Pos__(strat)
	return math.floor(strat * 10 + 1.001)
end

function PositionOfStrategy(player)
	for i = 1, qtty_strategies__, 1 do
		if Pos__(player.strategy) == Pos__(STRATEGIES[i]) then return i end
	end
	print("ERROR: POSITION OF STRATEGY")
end

cell = Cell{
	runTurn = function(cell)
		local np = #cell:getAgents()

		if np < 2 then return true end

		forEachAgent(cell, function(agent)
			if agent.strategy > 0.01 then
				changed = true
			end
		end)

		local tab     = GamesTable(cell)
		local players = cell:getAgents()

		for i = 1, #tab - 1, 2 do
			local player  = players[tab[i]  ]
			local oponent = players[tab[i+1]]

			local confront = Game(player:play(), oponent:play())

			player:changeMoney(confront[1] + GAIN)
			oponent:changeMoney(confront[2] + GAIN)
		end	
	end,
	-- the cell must have at least one agent to call this function
	owner = function(cell)
		local players = cell:getAgents()


		local owner = players[1]

		forEachAgent(cell, function(player)
			if player.money > owner.money then
				owner = player
			end
		end)

		return owner
	end,
	strategy = function(cell)
		local owner = cell:owner()
		if not owner then return 0.0 end
		return owner.strategy
		--pos = PositionOfStrategy(owner)
		--return pos
	end,
	quantity = function(cell)
		local quant = #cell:getAgents()
		if quant > 3 then quant = 3 end
		return quant
	end
}

-- use the internal__ variables and clean them
function ShowState(cs)

	for i = 1, qtty_strategies__, 1 do
		movements__[i] = 0
		owners__   [i] = 0
		money__    [i] = 0
		balance__  [i] = 0
	end


	forEachCell(cs, function(cell)
		forEachAgent(cell, function(player)
			local p = PositionOfStrategy(player)
 
			money__  [p] = money__  [p] + player.money
			balance__[p] = balance__[p] + player.balance
		end)

		if #cell:getAgents() > 0 then
			local p = PositionOfStrategy(cell:owner())
			owners__[p] = owners__[p] + 1
		else
			--cell.owner = 0
		end
	end)
	p = ""
	m = ""
	o = ""
	s = "" -- $
	b = ""

	for i = 1, qtty_strategies__, 1 do
		p = p..players__  [i].."\t"
		m = m..movements__[i].."\t"
		o = o..owners__   [i].."\t"
		s = s..money__    [i].."\t"
		b = b..balance__  [i].."\t"
	end

	result = ""

	if SHOW_PLAYERS   then result = result..p end
	if SHOW_MOVEMENTS then result = result..m end
	if SHOW_OWNERS    then result = result..o end
	if SHOW_MONEY     then result = result..s end
	if SHOW_BALANCE   then result = result..b end

	print(result)
	io.flush()
end

function ShowHeader(cs)
	k = PLAYERS_PROPORTION * #cs
	p = ""
	m = ""
	o = ""
	s = "" -- $
	b = ""

	for i = 1, qtty_strategies__, 1 do
		players__  [i] = k; p = p.."strat"..(STRATEGIES[i]*10).."\t"
		movements__[i] = 0; m = m.."movem"..(STRATEGIES[i]*10).."\t"
		owners__   [i] = 0; o = o.."owner"..(STRATEGIES[i]*10).."\t"
		money__    [i] = 0; s = s.."money"..(STRATEGIES[i]*10).."\t"
		balance__  [i] = 0; b = b.."balan"..(STRATEGIES[i]*10).."\t"
	end

	result = ""

	if SHOW_PLAYERS   then result = result..p end
	if SHOW_MOVEMENTS then result = result..m end
	if SHOW_OWNERS    then result = result..o end
	if SHOW_MONEY     then result = result..s end
	if SHOW_BALANCE   then result = result..b end

	print(result)
	io.flush()
end

cs = CellularSpace{
	xdim = 20,
	instance = cell
}

cs:createNeighborhood{}

soc = Society{
	instance = agent,
	quantity = PLAYERS_PROPORTION * #STRATEGIES * #cs
}

env = Environment{soc, cs}

env:createPlacement{strategy = "uniform"}

Map{
	target = cs,
	select = "strategy",
	value = {0, 0.1, 0.5, 1.0},
	color = {"white", "green", "blue", "red"}
}

Map{
	target = cs,
	select = "quantity",
	color = {"white", "yellow", "purple", "black"},
	value = {0, 1, 2, 3},
	label = {"0", "1", "2", "3 or more"}
}

ShowHeader(cs)
ShowState(cs)

forEachElement(owners__, function(idx, value)
	print(idx.."  "..value)
end)

c = Cell{
	p01 = function() return owners__[1] end,
	p05 = function() return owners__[2] end,
	p10 = function() return owners__[3] end,
}

Chart{
	target = c,
	select = {"p01", "p05", "p10"},
	title = "Owner",
	color = {"green", "blue", "red"}
}
c:notify()

changed = true
while changed do
	changed = false
	cs:runTurn()
	soc:execute()

	ShowState(cs)
	cs:notify()
	c:notify()
end

