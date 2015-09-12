function TeamWallhackPrintSquad(id)
	chat.AddText(Color(0,0,0),"[",Color(0,0,255),"TeamWallhack",Color(0,0,0),"]",Color(255,255,255),": Changed squad to \"",Color(100,255,100),id,Color(255,255,255),"\"")
end

timer.Simple(10, function()
	local function distance(pos1,pos2)
		return math.sqrt((pos1.x-pos2.x)^2+(pos1.y-pos2.y)^2+(pos1.z-pos2.z)^2)
	end
	local ChamsMat = CreateMaterial("Wallhack Material", "VertexLitGeneric", { ["$basetexture"] = "models/debug/debugwhite", ["$model"] = 1, ["$ignorez"] = 1 })
	surface.CreateFont("ZombieChams", {
		size = 12,
		weight = 5000,
		antialias = true,
		shadow = true,
		font = "TargetID"})
	local MySquad
	local TheirSquad

	hook.Add("RenderScreenspaceEffects", "ZombieTeamChams", function()
		MySquad = LocalPlayer():GetNWString("TeamWallhackSquad")
			cam.Start3D(EyePos(), EyeAngles())
			table.foreach(player.GetAll(), function(i, ENT)
				if ENT:Team() == LocalPlayer():Team() then
					if ENT:Health()>0 then
						TheirSquad = ENT:GetNWString("TeamWallhackSquad")
						if (MySquad == TheirSquad) or (TheirSquad == "") then
							render.MaterialOverride(ChamsMat)
							render.SuppressEngineLighting(true)
							local color = team.GetColor(ENT:Team())
							if TheirSquad == "" then
								render.SetColorModulation(color.r/255, color.g/255, color.b/255, 1)
								render.SetBlend(1/(distance(LocalPlayer():GetShootPos(),ENT:GetShootPos())/100))
							else
								render.SetColorModulation(.6, 0, .8, 1)
								render.SetBlend(1/(distance(LocalPlayer():GetShootPos(),ENT:GetShootPos())/200))
							end
							ENT:DrawModel()
							render.SetBlend(1)
							render.MaterialOverride()
							render.SetColorModulation(1, 1, 1)
							render.SuppressEngineLighting(false)
							if ENT:GetActiveWeapon():IsValid() then
								ENT:GetActiveWeapon():DrawModel()
							end
							ENT:DrawModel()
						end
					end
				end
			end)
		cam.End3D()
	end)


	local TColor
	hook.Add("HUDPaint", "ZombieTeamChams", function()
		MySquad = LocalPlayer():GetNWString("TeamWallhackSquad")
		table.foreach(player.GetAll(), function(i, ply)
			if (ply!=LocalPlayer()) and (ply:Team()==LocalPlayer():Team()) then
				TheirSquad = ply:GetNWString("TeamWallhackSquad")
				if (MySquad == TheirSquad) or (TheirSquad == "") then
					local pos = ply:EyePos()
					pos = pos:ToScreen()
					if TheirSquad == "" then
						TColor = team.GetColor(ply:Team())
						draw.DrawText(ply:Nick(), "ZombieChams", pos.x, pos.y -60, Color(TColor.r,TColor.g,TColor.b,255/(distance(LocalPlayer():GetShootPos(),ply:GetShootPos())/100)), 1)
					else
						draw.DrawText(ply:Nick(), "ZombieChams", pos.x, pos.y -60, Color( 153, 0, 204, 255/(distance(LocalPlayer():GetShootPos(),ply:GetShootPos())/200)), 1)
						draw.DrawText("Health: "..ply:Health(), "ZombieChams", pos.x, pos.y -51, Color( 255-ply:Health()*2.55, ply:Health()*2.55, 0, 255/(distance(LocalPlayer():GetShootPos(),ply:GetShootPos())/200)), 1)
					end
				end
			end
		end)
	end)
end)