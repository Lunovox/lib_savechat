local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)

libSaveChat = {}

local cor = function(myCor)
	return core.get_color_escape_sequence(myCor)
end

libSaveChat.onSendWhisper = function(playername, param)
	if param~=nil and type(param)=="string" and param~="" then
		local fromPlayer = minetest.get_player_by_name(playername)
		if not fromPlayer then
			return true, "["..cor("#FF0000").."WHISPER:ERROR"..cor("#FFFFFF").."] Erro desconhecido!!!"
		end
		local fromPos = libSaveLogs.getPosResumed(fromPlayer:getpos())
		
		local toName, message = string.match(param, "([%a%d_]+) (.+)")
	
		if not toName or not message then
			--minetest.chat_send_player(playername,"/mail <jogador> <mensagem>")
			return true, cor("#00FF00").."/whisper <jogador> <mensagem> "..cor("#FFFFFF")..": Manda um sussurro (mensagem privada registrada) para um jogador específico!"
		end

		local toPlayer = minetest.get_player_by_name(toName)
		if not toPlayer then
			return true, "["..cor("#FF0000").."WHISPER:ERROR"..cor("#FFFFFF").."] O jogador '"..cor("#FFFF00")..toName..cor("#FFFFFF").."' não está online para receber o seu sussurro!"
		end
		local toPos = libSaveLogs.getPosResumed(toPlayer:getpos())
		
		
		if type(libSaveLogs.savePosOfSpeaker)=="boolean" and libSaveLogs.savePosOfSpeaker==true  then
			libSaveLogs.addLog(
				"<whisper:"
					..playername..minetest.pos_to_string(fromPos)
					.."→"
					..toName..minetest.pos_to_string(toPos)
				.."> "..message)
		else
			libSaveLogs.addLog("<whisper:"..playername.."→"..toName.."> "..message)
		end
		minetest.chat_send_player(
			toName, 
			cor("#00FF00").."Sussuro de '"..cor("#FFFF00")..playername..cor("#00FF00").."': "..cor("#FFFFFF")..message
		)
		--return true, "Sussuro de '"..playername.."': "..message
		return true
	end
	return true, cor("#00FF00").."/whisper <jogador> <mensagem> "..cor("#FFFFFF")..": Manda um sussurro (mensagem privada registrada) para um jogador específico!"
end
--]]


minetest.register_on_chat_message(function(playername, message)
	if type(message)=="string" and message~="" then
		local player = minetest.get_player_by_name(playername)
		if 
			type(libSaveLogs.savePosOfSpeaker)=="boolean" and libSaveLogs.savePosOfSpeaker==true 
			and player and player:is_player() --Verifica se o player ainda esta online!
		then
			local pos = player:getpos()
			libSaveLogs.addLog("<"..playername.."> "..message.." "..minetest.pos_to_string(libSaveLogs.getPosResumed(pos)))
		else
			libSaveLogs.addLog("<"..playername.."> "..message)
		end
	end
end)

minetest.register_chatcommand("msg", {
	params = "",
	description = cor("#00FF00").."/msg <jogador> <mensagem> "..cor("#FFFFFF")..": Manda um sussurro (mensagem privada registrada) para um jogador específico!",
	func = function(playername, param)
		return libSaveChat.onSendWhisper(playername, param)
	end,
})

minetest.register_chatcommand("whisper", {
	params = "",
	description = cor("#00FF00").."/whisper <jogador> <mensagem> "..cor("#FFFFFF")..": Manda um sussurro (mensagem privada registrada) para um jogador específico!",
	func = function(playername, param)
		return libSaveChat.onSendWhisper(playername, param)
	end,
})

minetest.register_chatcommand("pvt", {
	params = "",
	description = cor("#00FF00").."/pvt <jogador> <mensagem> "..cor("#FFFFFF")..": Manda um sussurro (mensagem privada registrada) para um jogador específico!",
	func = function(playername, param)
		return libSaveChat.onSendWhisper(playername, param)
	end,
})

minetest.log('action',"["..modname:upper().."] Carregado!")
