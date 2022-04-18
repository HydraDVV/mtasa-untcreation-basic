function canPlayerAccessStaffManager(player)
	return exports.un_integration:isPlayerTrialAdmin(player) or exports.un_integration:isPlayerSupporter(player) or exports.un_integration:isPlayerVCTMember(player) or exports.un_integration:isPlayerLeadScripter(player) or exports.un_integration:isPlayerMappingTeamLeader(player)
end	