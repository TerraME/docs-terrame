--IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
--II Games on Cellular Spaces for studying mobility                     II
--II                                                                    II
--II Pedro Ribeiro de Andrade Neto                                      II
--II Last change: 20070131                                              II
--IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII

--------------------------------------------------------------------------
-- GLOBAL VARIABLES
--------------------------------------------------------------------------

math.randomseed(os.time())

math.random(); math.random()

-- environment
PLAYERS_PROPORTION = 3
INITIAL_MONEY      = 200
--TURNS              = 3500

-- players
STRATEGIES = {0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0}
--STRATEGIES = {0.1, 0.5, 1.0}

-- threshold for changing cell
THRESHOLD = -20

-- how much each player gains after each game?
GAIN = 0.0

SHOW_PLAYERS   = true
SHOW_MOVEMENTS = false
SHOW_OWNERS    = true
SHOW_MONEY     = false
SHOW_BALANCE   = false

--------------------------------------------------------------------------
-- INTERNAL VALUES
--------------------------------------------------------------------------
SHOOT     = 1
NOT_SHOOT = 0

players__         = {}
movements__       = {}
owners__          = {}
money__           = {}
balance__         = {}
count__           = 0
qtty_strategies__ = table.getn(STRATEGIES)

changed = false

--------------------------------------------------------------------------
-- FUNCTION WITH RULES FOR THE GAME
--------------------------------------------------------------------------

function Game(p1, p2)
	if p1 == SHOOT     and p2 == SHOOT     then return {-10,-10} end
	if p1 == SHOOT     and p2 == NOT_SHOOT then return {  1, -1} end
	if p1 == NOT_SHOOT and p2 == SHOOT     then return { -1,  1} end
	if p1 == NOT_SHOOT and p2 == NOT_SHOOT then return {  0,  0} end
end

--------------------------------------------------------------------------
-- CHAMPIONSHIP RULES
--------------------------------------------------------------------------

-- these functions work with a vector of numbers, indicating positions of a vector of players

function RemoveOneIfOdd(players)	
	if(math.mod(table.getn(players), 2) == 1)
		then table.remove(players, math.random(1, table.getn(players)))
	end
	return players
end

function GamesTable(cell)
	local vplayers   = {}
	local vconfronts = {}

	local players = GetAgents(cell)
	local tp = table.getn(players)

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

--------------------------------------------------------------------------
-- FUNCTIONS FOR MANIPULATING AGENTS
--------------------------------------------------------------------------

-- return the strategy for a player. it cycles all STRATEGIES.
function InitialStrategy()
	count__ = math.mod(count__ + 1, qtty_strategies__)
	return STRATEGIES[count__ + 1]
end

function NewPlayer()
	return {money    = INITIAL_MONEY,
			strategy = InitialStrategy(),
			balance  = 0}
end

function Play(player)
	if math.random() <= player.strategy then
		return SHOOT
	else
		return NOT_SHOOT
	end
end

function ChangeMoney(player, value)
	player.money   = player.money   + value
	player.balance = player.balance + value
end

function Pos__(strat)
	return math.floor(strat * 10 + 1.001)
end

function PositionOfStrategy(player)
	for i = 1, qtty_strategies__, 1 do
		if Pos__(player.strategy) == Pos__(STRATEGIES[i]) then return i end
	end
	print("ERROR: POSITION OF STRATEGY")
end

-------------------------------------------------------------------------
-- FUNCTIONS FOR MANIPULATING CELLS
-------------------------------------------------------------------------

function RunTurn(cell)
	local np = NumberOfAgents(cell)

	if np < 2 then return true end

	ForEachAgent(cell, function(cell, agent)
		if agent.strategy > 0.01 then
			changed = true
		end
		return true
	end)

	local tab     = GamesTable(cell)
	local players = GetAgents(cell)

	for i = 1, table.getn(tab) - 1, 2 do
		local player  = players[tab[i]  ]
		local oponent = players[tab[i+1]]

		local confront = Game(Play(player), Play(oponent))

		ChangeMoney(player,  confront[1] + GAIN)
		ChangeMoney(oponent, confront[2] + GAIN)
	end	
	return true;
end

function EndTurn(cell)
	local i = 1
	local players = GetAgents(cell)

	while i <= table.getn(players) do
		local player = players[i]

		if player.money <= 0 then -- leave the game
			pos = PositionOfStrategy(player)
			players__[pos] = players__[pos] - 1
			RemoveAgent(cell, player)

		elseif player.balance < THRESHOLD then -- leave the cell
			pos = PositionOfStrategy(player)
			movements__[pos] = movements__[pos] + 1

			player.balance = 0
			MoveTo( cell, player, GetRandomNeighbour(cell, 1) )
		
		else
			i = i + 1
		end
	end

	return true
end

-- the cell must have at least one agent to call this function
function Owner(cell)
	local players = GetAgents(cell)
	local owner = players[1]

	ForEachAgent(cell, function(cell, player)
		if player.money > owner.money then
			owner = player
		end
	end)

	cell.owner = PositionOfStrategy( owner ) 

	return owner
end

-------------------------------------------------------------------------
-- FUNCTIONS FOR MANIPULATING CELLULAR SPACES
-------------------------------------------------------------------------

function Populate(cs)
	local quantity = PLAYERS_PROPORTION * table.getn(STRATEGIES)

	ForEachCell(cs, function(cell)
		for i = 1, quantity, 1 do
			AddAgent( cell, NewPlayer() )
		end
		return true
	end)
end

-- players randomly distributed over the cells
--function Populate(cs)
	--local quantity = PLAYERS_PROPORTION * NumberOfCells(cs) * table.getn(STRATEGIES)
--
--	for i = 1, quantity, 1 do
--		AddAgent( GetRandomCell(cs), NewPlayer() )
--	end
--end

-- use the internal__ variables and clean them
function ShowState(cs)
	ForEachCell(cs, function(cell)
		ForEachAgent(cell, function(cell, player)
			local p = PositionOfStrategy(player)
 
			money__  [p] = money__  [p] + player.money
			balance__[p] = balance__[p] + player.balance
		end)

		if( NumberOfAgents(cell) > 0 ) then
			local p = PositionOfStrategy( Owner(cell) )
			owners__[p] = owners__[p] + 1
		else
			cell.owner = 0
		end
		return true
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

	for i = 1, qtty_strategies__, 1 do
		movements__[i] = 0
		owners__   [i] = 0
		money__    [i] = 0
		balance__  [i] = 0
	end

end

function ShowHeader(cs)
	k = PLAYERS_PROPORTION * NumberOfCells(cs)
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

--------------------------------------------------------------------------
-- RUNNING THE GAME
--------------------------------------------------------------------------

cs = CellularSpace{
	database = "c:\\mobility.mdb",
	layer    = "cells",
	theme    = "cells",
	select   = { "object_id_" , "Col", "Lin"}
}

cs:load()
CreateMooreNeighbourhood(cs)

ApplyNeighbourhoodConstraint(cs, 0, function(cell, neigh) return cell ~= neigh; end)

InitAgents(cs)
Populate(cs)

ShowHeader(cs)
ShowState(cs)


--for i = 1, TURNS, 1 do
changed = true
while changed do
	changed = false
	ForEachCell(cs, RunTurn)
	ForEachCell(cs, EndTurn)
	
	SynchronizeAgents()

	ShowState(cs)
--	if i == 1 or i == 2 or i == 3 then
--		cs:save( i, "ownercells", {"owner"} );
--	end
end

--cs:save( TURNS, "ownercells", {"owner"} );
