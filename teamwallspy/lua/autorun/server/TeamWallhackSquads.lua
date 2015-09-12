function ulx.squad(calling_ply, squadid)
	if SERVER then
		calling_ply:SetNWString("TeamWallhackSquad", squadid)
		calling_ply:SendLua([[TeamWallhackPrintSquad("]]..squadid..[[")]])
	end
end
local Squad = ulx.command( "Zombie Survival", "ulx squad", ulx.squad, "!squad", true )
Squad:addParam{ type=ULib.cmds.StringArg, hint="SquadID, nothing for default", ULib.cmds.optional }
Squad:defaultAccess( ULib.ACCESS_ADMIN )
Squad:help( "Join a specific squad." )