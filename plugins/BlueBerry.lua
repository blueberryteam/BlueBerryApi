local function pre_process(msg)
if not is_mod(msg) then
if msg.photo then
if redis:hget("photo:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.sticker then
if redis:hget("sticker:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.forward_from then
if redis:hget("forward:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.text then
if msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") then
if redis:hget("link:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if redis:hget("english:lock",msg.chat.id) then
if msg.text:match("[A-Z]") or msg.text:match("[a-z]") then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.text:match("@") then
if redis:hget("username:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.text:match("#") then
if redis:hget("tag:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.text:match("[\216-\219][\128-\191]") then
if redis:hget("arabic:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.text:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.text:match("[Hh][Tt][Tt][Pp]://") or msg.text:match(".[Ii][Rr]") or msg.text:match(".[Cc][Oo][Mm]") or msg.text:match(".[Oo][Rr][Gg]") or msg.text:match(".[Ii][Nn][Ff][Oo]") or msg.text:match("[Ww][Ww][Ww].") or msg.text:match(".[Tt][Kk]") then
if redis:hget("webpage:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
end
------- caption -------
if msg.caption then
if msg.caption:match("^(.*)[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/(.*)$") or msg.caption:match("^(.*)[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/(.*)$") or msg.caption:match("^(.*)[Tt].[Mm][Ee]/(.*)$") or msg.caption:match("^(.*)[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/(.*)$") then
if redis:hget("link:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.caption:match("^(.*)@(.*)$") then
if redis:hget("username:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if msg.caption:match("^(.*)#(.*)$") then
if redis:hget("tag:lock",msg.chat.id) then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if redis:hget("english:lock",msg.chat.id) then
if msg.caption:match("(.*)[A-Z](.*)") or msg.caption:match("(.*)[a-z](.*)") then
delmsg(msg.chat.id, tonumber(msg.message_id))
end
end
if redis:hget("arabic:lock",msg.chat.id) then
if msg.caption:match("(.*)[\216-\219][\128-\191](.*)") then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
if redis:hget("webpage:lock",msg.chat.id) then
if msg.caption:match("(.*)[Hh][Tt][Tt][Pp][Ss]://(.*)") or msg.caption:match("(.*)[Hh][Tt][Tt][Pp]://(.*)") or msg.caption:match("(.*).[Ii][Rr](.*)") or msg.caption:match("(.*).[Cc][Oo][Mm](.*)") or msg.caption:match("(.*).[Oo][Rr][Gg](.*)") or msg.caption:match("(.*).[Ii][Nn][Ff][Oo](.*)") or msg.caption:match("(.*)[Ww][Ww][Ww].(.*)") or msg.caption:match("(.*).[Tt][Kk](.*)") then
del_msg(msg.chat.id, tonumber(msg.message_id))
end
end
end
end
    if not redis:hget("setflood",msg.chat.id) then
        MSG_NUM_MAX = 5
    else
        MSG_NUM_MAX = tonumber(redis:hget("setflood",msg.chat.id))
    end
    if not redis:hget("setfloodtime",msg.chat.id) then
        TIME_CHECK = 2
    else
        TIME_CHECK = tonumber(redis:hget("setfloodtime",msg.chat.id))
    end
	
    if msg.chat.type == 'supergroup' then
        --Checking flood
        if redis:hget("flood:lock",msg.chat.id) then
            -- Check flood
                if not is_sudo(msg) then
                    -- Increase the number of messages from the user on the chat
                    local hash = 'flood:'..msg.from.id..':msg-number'
                    local msgs = tonumber(redis:get(hash) or 0)
                    if msgs > MSG_NUM_MAX then
   if msg.from.username then
    user_name = "@"..msg.from.username
       else
    user_name = msg.from.first_name
   end
 if msg.new_chat_member and msg.from.id then
    return
  end
if redis:get('user:'..msg.from.id..':flooder') then
return
else
  send_msg(msg.chat.id, "`The user` [["..user_name.."]]:\n`flooding in The Group`\n`Condition:` *(kicked)* ",msg.message_id,"md")
    ban_user(msg.from.id, msg.chat.id)
	delmsg(msg.chat.id, tonumber(msg.message_id))
redis:setex('user:'..msg.from.id..':flooder', 15, true)
                       end
                    end
                    redis:setex(hash, TIME_CHECK, msgs+1)
             end
         end
	end
end
-------------------------------------
local function setting(msg)
    if redis:hget("link:lock",msg.chat.id) then
    lock_links = 'lock'
    else
    lock_links = 'unlock'
    end
    if redis:hget("tag:lock",msg.chat.id) then
    lock_tag = 'lock'
    else
    lock_tag = 'unlock'
    end
	if redis:hget("username:lock",msg.chat.id) then
    lock_username = 'lock'
    else
    lock_username = 'unlock'
    end
	if redis:hget("webpage:lock",msg.chat.id) then
    lock_webpage = 'lock'
    else
    lock_webpage = 'unlock'
    end
	if redis:hget("english:lock",msg.chat.id) then
    lock_english = 'lock'
    else
    lock_english = 'unlock'
    end
	if redis:hget("arabic:lock",msg.chat.id) then
    lock_arabic = 'lock'
    else
    lock_arabic = 'unlock'
    end	
	if redis:hget("forward:lock",msg.chat.id) then
    lock_forward = 'Mute'
    else
    lock_forward = 'Unmute'
    end
	if redis:hget("photo:lock",msg.chat.id) then
    lock_photo = 'Mute'
    else
    lock_photo = 'Unmute'
    end
	if redis:hget("sticker:lock",msg.chat.id) then
    lock_sticker = 'Mute'
    else
    lock_sticker = 'Unmute'
    end	
	return "`SuperGroup Settings:`\n*Lock links:* _["..lock_links.."]_\n*Lock Tag:* _["..lock_tag.."]_\n*Lock Username:* _["..lock_username.."]_\n*Lock Webpage:* _["..lock_webpage.."]_\n*Lock English:* _["..lock_english.."]_\n*Lock Arabic:* _["..lock_arabic.."]_\n`SuperGroup Mutes:`\n*Mute Forward :* _["..lock_forward.."]_\n*Mute Photo :* _["..lock_photo.."]_\n*Mute Sticker :* _["..lock_sticker.."]_"
	end
-----------------------------------
	local function Help(msg)
	return [[
	Help BlueBerryTeam

*/id* `[reply]`
_Show Your And Chat ID_
*=-=-=-=-=-=-=-=-=-=-*
*/info* 
_Show Your And Name_
*=-=-=-=-=-=-=-=-=-=-*
*/settings* 
_Show setting Group _
*=-=-=-=-=-=-=-=-=-=-*
*/lock* 
_link_
_tag_
_username_
_english_
_arabic_
_webpage_
_flood_
`If This Actions Lock, Bot Check Actions And Delete Them`
*=-=-=-=-=-=-=-=-=-=-*
*/unlock* 
_link_
_tag_
_username_
_english_
_arabic_
_webpage_
_flood_
`If This Actions Unlock, Bot Not Delete Them`
*=-=-=-=-=-=-=-=-=-=-*
*/mute* 
_forward_
_photo_
_sticker_
`If This Actions Mute, Bot Check Actions And Delete Them`
*=-=-=-=-=-=-=-=-=-=-*
*/unmute* 
_forward_
_photo_
_sticker_
`If This Actions Unmute, Bot Not Delete Them`
*=-=-=-=-=-=-=-=-=-=-*
*/clean* 
_banlist_
_ownerlist_
_modlist_
`Bot Clean Them`
*=-=-=-=-=-=-=-=-=-=-*
*/set* 
_link_
_rules_
`Bot Set Them`
*=-=-=-=-=-=-=-=-=-=-*
*/setowner* `[reply/id]`
_Set Group Owner_
*=-=-=-=-=-=-=-=-=-=-*
*/demowner* `[reply/id]`
_Remove User From Owner List_
*=-=-=-=-=-=-=-=-=-=-*
*/promote* `[reply/id]`
_Promote User To Group Admin_
*=-=-=-=-=-=-=-=-=-=-*
*/demote* `[reply/id]`
_Demote User From Group Admins List_
*=-=-=-=-=-=-=-=-=-=-*
*/ban* `[reply/id]`
_Ban User From Group_
*=-=-=-=-=-=-=-=-=-=-*
*/unban* `[reply/id]`
_UnBan User From Group_
*=-=-=-=-=-=-=-=-=-=-*
*/kick* `[reply/id]`
_Kick User From Group_
*=-=-=-=-=-=-=-=-=-=-*
*/ownerlist* 
_Show Your ownerlist Group_
*=-=-=-=-=-=-=-=-=-=-*
*/modlist* 
_Show Your modlist Group_
*=-=-=-=-=-=-=-=-=-=-*
*/banlist* 
_Show Your banlist Group_
*=-=-=-=-=-=-=-=-=-=-*
*/link* 
_Show Your link Group_
*=-=-=-=-=-=-=-=-=-=-*
*/rules* 
_Show Your rules Group_
*=-=-=-=-=-=-=-=-=-=-*
	]]
	end
-----------------------------------
local function manager(msg)
local text = '*Wlcome To BlueBerryApi Bot*'
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
   {text = "Go To Manager Group", callback_data="/lang"}
},{   
   {text = "close", callback_data="/close"}  
    }
 }
    send_key(msg.chat.id, text, keyboard, msg.message_id, 'md')

end
-----------------------------------
local function lang(msg)
local text = '*Wlcome To Manager Group BlueBerryApi Bot*'
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "GroupMod", callback_data="/groupmod"}
	},{
	{text = "Aboutًں“œ", callback_data="/dev"}
  },{
   {text = "Channelًں”–", url="https://t.me/BlueBerryTeam"}
  },{
   {text = "Close", callback_data="/close"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
-----------------------------------
local function Mod(msg)
local text = 'Gap Info'
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Adminlist", callback_data="/admins"}, {text = "OwnerList", callback_data="/owners"}
    },{
    {text = "ModList", callback_data="/mods"},  {text = "BanList", callback_data="/banss"}
    },{
    {text = "Rules", callback_data="/rules"},  {text = "Link", callback_data="/links"}
	},{
   {text = "Back To Manager Group", callback_data="/lang"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
-----------------------------------
local function Creator(msg)
local text = '*My Creator*'
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Soheil", url="https://t.me/So8eil"}, {text = "MrLucas", url="https://t.me/DeVe_TeLeGrAm"}
},{
   {text = "Backًں”™", callback_data="/groupmod"}, {text = "Home", callback_data="/lang"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
 -----------------------------------
local function run(msg, matches)
if matches[1] == "add" and is_sudo(msg) then
    if redis:sismember('adds:',msg.chat.id) then
        return "*SuperGroup* _is_ *already* _added_"
	else
		redis:sadd('adds:',msg.chat.id)
	    return "*SuperGroup* *has been* _added_"

end
end
if matches[1] == "rem" and is_sudo(msg) then
    if not redis:sismember('adds:',msg.chat.id) then
        return "*SuperGroup* _is_ *not* _added_"
	else
	redis:srem('adds:',msg.chat.id)
	return "*SuperGroup* *has been* _removed_"
end
end
if matches[1] == "info" then
        send_msg(msg.chat.id, "`Your Info`\n*Your ID:* _"..msg.from.id.."_\n*UserName:* @"..check_markdown(msg.from.username or "").."\n*First name:* _"..msg.from.first_name.."_",msg.message_id, 'md')
end
if matches[1] == "id" and  not msg.reply_to_message then
      return "*Supergroup* #ID: `"..msg.chat.id.."`\n*Your* #ID: `"..msg.from.id.."`"
end
if matches[1] == "id" and msg.reply_to_message then
 return "*User* #ID: "..msg.reply_to_message.from.id
end
if matches[1] == "settings" and is_mod(msg) then
 return setting(msg)
end
if matches[1] == "manager" and is_mod(msg) then
 return manager(msg)
end
if matches[1] == "/lang" and is_mod(msg) then
 return lang(msg)
end
if matches[1] == "/groupmod" and is_mod(msg) then
 return Mod(msg)
end
if matches[1] == "/dev" and is_mod(msg) then
 return Creator(msg)
end
if matches[1] == "help" and is_mod(msg) then
 return Help(msg)
end
if matches[1] == "blueberry" and is_mod(msg) then
return  _config.info_text
end
-------------------------
 if matches[1] == "setflood"and is_owner(msg)then
    if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 20 then
      send_msg(msg.chat.id, "_Wrong number, range is_ *[2-20]*",msg.message_id, 'md')
	  return false
end
    redis:hset("setflood",msg.chat.id,matches[2])
    send_msg(msg.chat.id, "_Group_ *flood* _sensitivity has been set to :["..matches[2].."]",msg.message_id, 'md')
end
 if matches[1] == "setfloodtime" and is_owner(msg) then
    if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 200 then
      send_msg(msg.chat.id, "_Wrong number, range is_ *[2-200]*",msg.message_id, 'md')
	  return false
end
    redis:hset("setfloodtime",msg.chat.id,matches[2])
    send_msg(msg.chat.id, "_Group_ *setfloodtime* _sensitivity has been set to :["..matches[2].."]",msg.message_id, 'md')
end
-------------------------
    if matches[1]:lower() == "rules" and is_mod(msg) then
        local rules = redis:get("grouprules"..msg.chat.id)
        if rules then
            return "Group Rules :\n"..rules
        else
            return "Default Rules :\n1-Don't Spam Or Flood\n2- Respect Each Other\n3- Don't Be Rude."
        end
    end
if matches[1]:lower() == "setrules" and is_mod(msg) then
  redis:set("grouprules"..msg.chat.id, matches[2])
    return "New Rules Applied."
 end
 
		if matches[1]:lower() == "link" and is_mod(msg) then
            local link = redis:get("grouplink"..msg.chat.id)
            if link then
                return "ظ„غŒظ†ع© ع¯ط±ظˆظ‡ :\n[ع©ظ„غŒع© ع©ظ†غŒط¯ "..msg.chat.title.." ط¨ط±ط§غŒ ظˆط±ظˆط¯ ط¨ظ‡ ع¯ط±ظˆظ‡]("..link..")"
            else
                return 'ظ„غŒظ†ع© ع¯ط±ظˆظ‡ ظ‡ظ†ظˆط² ط°ط®غŒط±ظ‡ ظ†ط´ط¯ظ‡ ط§ط³طھ ! \n ظ„ط·ظپط§ ط¨ط§ ط¯ط³طھظˆط± /setlink ط¢ظ† ط±ط§ ط°ط®غŒط±ظ‡ ع©ظ†غŒط¯'
            end
          end
		if matches[1]:lower() == "setlink" and is_mod(msg) then
		     redis:set("grouplink"..msg.chat.id, 'waiting')
              return 'ظ„ط·ظپط§ ظ„غŒظ†ع© ع¯ط±ظˆظ‡ ط±ط§ ط§ط±ط³ط§ظ„ ظ†ظ…ط§غŒغŒط¯ :'
          end
		if redis:get("grouplink"..msg.chat.id) == 'waiting' and is_mod(msg)then
        if msg.text:match("(https://telegram.me/joinchat/%S+)") or msg.text:match("(https://t.me/joinchat/%S+)") then
          local glink = msg.text:match("(https://telegram.me/joinchat/%S+)") or msg.text:match("(https://t.me/joinchat/%S+)")
          local hash = "grouplink"..msg.chat.id
          redis:set(hash,glink)
            return 'ظ„غŒظ†ع© ع¯ط±ظˆظ‡ ط«ط¨طھ ط´ط¯'
        end
      end
---------------------------
if matches[1] == "clean" and is_owner(msg) then
if matches[2] == "banlist" then
redis:del('banneds:'..msg.chat.id)
return "Banlist Is Now Cleaned."
end
if matches[2] == "ownerlist" and is_sudo(msg)then
redis:del('owners:'..msg.chat.id)
return "Ownerlist Is Now Cleaned."
end
if matches[2] == "modlist" and is_owner(msg) then
redis:del('mods:'..msg.chat.id)
return "Modlist Is Now Cleaned."
end
end

-----------LOCK----------
if matches[1] == "lock" and is_mod(msg) then
if matches[2] == "link" then
    if redis:hget("link:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Link Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Link Is Now Locked.*",msg.message_id, "md")
	redis:hset("link:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "tag" then
    if redis:hget("tag:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Tag Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Tag Is Now Locked.*",msg.message_id, "md")
	redis:hset("tag:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "username" then
    if redis:hget("username:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Username Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Username Is Now Locked.*",msg.message_id, "md")
	redis:hset("username:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "webpage" then
    if redis:hget("webpage:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Webpage Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Webpage Is Now Locked.*",msg.message_id, "md")
	redis:hset("webpage:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "english" then
    if redis:hget("english:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending English Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending English Is Now Locked.*",msg.message_id, "md")
	redis:hset("english:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "arabic" then
    if redis:hget("arabic:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Arabic Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Arabic Is Now Locked.*",msg.message_id, "md")
	redis:hset("arabic:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "flood" then
    if redis:hget("flood:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Flood Is Already Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Flood Is Now Locked.*",msg.message_id, "md")
	redis:hset("flood:lock",msg.chat.id,"supergroup")
end
end
end
--------------Unlock-------------
if matches[1] == "unlock" and is_mod(msg) then
if matches[2] == "link" then
    if not redis:hget("link:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Link Is Not Locked.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Link Is Now Unlocked.*",msg.message_id, "md")
  redis:del("link:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "tag" then
    if not redis:hget("tag:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Is Not Locked.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Tag Is Now Unlocked.*",msg.message_id, "md")
  redis:del("tag:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "username" then
    if not redis:hget("username:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Username Is Not Locked.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Username Is Now Unlocked.*",msg.message_id, "md")
  redis:del("username:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "webpage" then
    if not redis:hget("webpage:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Webpage Is Not Locked.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Webpage Is Now Unlocked.*",msg.message_id, "md")
  redis:del("webpage:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "english" then
    if not redis:hget("english:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending English Is Not Locked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending English Is Now Unlocked.*",msg.message_id, "md")
	redis:del("english:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "arabic" then
    if not redis:hget("arabic:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Arabic Is Now Unlocked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Arabic Is Now Unlocked.*",msg.message_id, "md")
	redis:del("arabic:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "flood" then
    if not redis:hget("flood:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Flood Is Now Unlocked.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Flood Is Now Unlocked.*",msg.message_id, "md")
	redis:del("flood:lock",msg.chat.id,"supergroup")
end
end
end
-----------mute----------
if matches[1] == "mute" and is_mod(msg) then
if matches[2] == "photo" then
    if redis:hget("photo:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Photo Is Already Muted.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Photo Is Now Muted.*",msg.message_id, "md")
	redis:hset("photo:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "sticker" then
    if redis:hget("sticker:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Sticker Is Already Muted.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Sticker Is Now Muted.*",msg.message_id, "md")
	redis:hset("sticker:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "forward" then
    if redis:hget("forward:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Forward Is Already Muted.*",msg.message_id, "md")
	else
	send_msg(msg.chat.id, "*Sending Forward Is Now Muted.*",msg.message_id, "md")
	redis:hset("forward:lock",msg.chat.id,"supergroup")
end
end
end
------------Unmute-------------
if matches[1] == "unmute" and is_mod(msg) then
if matches[2] == "photo" then
    if not redis:hget("photo:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Photo Is Not Muted.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Photo Is Now Muted.*",msg.message_id, "md")
  redis:del("photo:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "sticker" then
    if not redis:hget("sticker:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Sticker Is Already Unmuted.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Sticker Is Now Unmuted.*",msg.message_id, "md")
  redis:del("sticker:lock",msg.chat.id,"supergroup")
end
end
if matches[2] == "forward" then
    if not redis:hget("forward:lock",msg.chat.id) then
        send_msg(msg.chat.id, "*Sending Forward Is Already Unmuted.*",msg.message_id, "md")
  else
  send_msg(msg.chat.id, "*Sending Forward Is Now Unmuted.*",msg.message_id, "md")
  redis:del("forward:lock",msg.chat.id,"supergroup")
end
end
end
----------------------------------
		if matches[1]:lower() == "setowner" and is_sudo(msg)then
			local bash = 'owners:'..msg.chat.id
			if matches[2] and not msg.reply_to_message then
				local user_id = matches[2]
				if is_sudo1(user_id) then
     	        send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	        return false
	             end
              local user_info = redis:hgetall('user:'..matches[2])
              if user_info and user_info.username then
                local username = user_info.username
				if redis:sismember(bash,user_id) then
					return '*User* `'..matches[2]..' '..username..' is` *already* `owners group`'
				else
                    redis:sadd(bash,user_id)
					return "*User* `"..user_id.."` *added* `to owners group`" 
				end
            end	
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
			if is_sudo1(user_id) then
     	    send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	    return false
	        end
				if redis:sismember(bash,user_id) then
				return '*User* '..user_id..' *already* `owners group`'
			else
                redis:sadd(bash,user_id)
				return "*User* "..user_id.." *added* `to owners group`" 
			end
		end
	end
	if matches[1]:lower() == "demowner" and is_sudo(msg)then
			local bash = 'owners:'..msg.chat.id
			if matches[2] and not msg.reply_to_message then
				local user_id = matches[2]
				if is_sudo1(user_id) then
     	        send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	        return false
	            end
				if not redis:sismember(bash,user_id) then
					return '*User* `'..user_id..' is` *not* `owners group`'
				else
                    redis:srem(bash,user_id)
					return "*User* `"..user_id.."` *removed* ` owners group`" 
				end
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
			if is_sudo1(user_id) then
     	    send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	    return false
	        end
				if not redis:sismember(bash,user_id) then
				return '*User* '..user_id..' *not* `owners group`'
			else
                redis:srem(bash,user_id)
				return "*User* "..user_id.." *removed* `to owners group`" 
			end
		end
	end
		if matches[1]:lower() == "promote" and is_owner(msg) then
			local bash = 'mods:'..msg.chat.id
			if matches[2] and not msg.reply_to_message then
				local user_id = matches[2]
			if redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
             	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	        return false
	        end
				if redis:sismember(bash,user_id) then
					return '*User* `'..user_id..' is` *already* `promote group`'
				else
                    redis:sadd(bash,user_id)
					return "*User* `"..user_id.."` *added* `to promote group`" 
				end
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
			if redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
        	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
         	return false
	        end
				if redis:sismember(bash,user_id) then
				return '*User* '..user_id..' *already* `promote group`'
			else
                redis:sadd(bash,user_id)
				return "*User* "..user_id.." *added* `to promote group`" 
			end
		end
	end
	if matches[1]:lower() == "demote" and is_owner(msg) then
			local bash = 'mods:'..msg.chat.id
			if matches[2] and not msg.reply_to_message then
				local user_id = matches[2]
			if redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
     	        send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	        return false
	            end
				if not redis:sismember(bash,user_id) then
					return '*User* `'..user_id..' is` *not* `promote group`'
				else
                    redis:srem(bash,user_id)
					return "*User* `"..user_id.."` *removed* ` promote group`" 
				end
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
			if redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
     	    send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	    return false
	         end
				if not redis:sismember(bash,user_id) then
				return '*User* '..user_id..' *not* `promote group`'
			else
                redis:srem(bash,user_id)
				return "*User* "..user_id.." *removed* `to promote group`" 
			end
		end
	end
	
	if matches[1]:lower() == "ban" and is_mod(msg) then
			local bash = 'banneds:'..msg.chat.id
			if matches[2] and not msg.reply_to_message then
			local user_id = matches[2]
		if redis:sismember('mods:'..msg.chat.id,user_id) or redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
     	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	return false
	        end
				if redis:sismember(bash,user_id) then
				    ban_user(user_id, msg.chat.id)
					return '*User* `'..user_id..' is` *already* `ban`'
				else
                    redis:sadd(bash,user_id)
					ban_user(user_id, msg.chat.id)
					return "*User* `"..user_id.."` *added* `ban`" 
				end
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
		if redis:sismember('mods:'..msg.chat.id,user_id) or redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
     	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	return false
	        end
				if redis:sismember(bash,user_id) then
				ban_user(user_id, msg.chat.id)
				return '*User* '..user_id..' *already* `ban`'
			else
                redis:sadd(bash,user_id)
				ban_user(user_id, msg.chat.id)
				return "*User* "..user_id.." *added* ban" 
			end
		end
	end
	if matches[1]:lower() == "unban" and is_mod(msg)then
			local bash = 'banneds:'..msg.chat.id
			if matches[2] and not msg.reply_to_message then
				local user_id = matches[2]
		      if redis:sismember('mods:'..msg.chat.id,user_id) or redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
             	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	        return false
	            end
				if not redis:sismember(bash,user_id) then
				    unban_user(user_id, msg.chat.id)
					return '*User* `'..user_id..' is` *already* `unban`'
				else
                    redis:srem(bash,user_id)
					unban_user(user_id, msg.chat.id)
					return "*User* `"..user_id.."` *added* `unban`" 
				end
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
		if redis:sismember('mods:'..msg.chat.id,user_id) or redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
         	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	     return false
	        end
				if not redis:sismember(bash,user_id) then
				unban_user(user_id, msg.chat.id)
				return '*User* '..user_id..' *already* `unban`'
			else
                redis:srem(bash,user_id)
				unban_user(user_id, msg.chat.id)
				return "*User* "..user_id.." *added* unban" 
			end
		end
	end
	if matches[1]:lower() == "kick" and is_mod(msg) then
			if matches[2] and not msg.reply_to_message then
				local user_id = matches[2]
		if redis:sismember('mods:'..msg.chat.id,user_id) or redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
     	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	return false
	        end
				    ban_user(user_id, msg.chat.id)
				    unban_user(user_id, msg.chat.id)
					return "*User* `"..user_id.."` *added* `ban`" 
		elseif not matches[2] and msg.reply_to_message then
			local user_id = msg.reply_to_message.from.id
		if redis:sismember('mods:'..msg.chat.id,user_id) or redis:sismember('owners:'..msg.chat.id,user_id) or is_sudo1(user_id) then
     	send_msg(msg.chat.id, ":|",msg.message_id, 'md')
    	return false
	        end
				ban_user(user_id, msg.chat.id)
				unban_user(user_id, msg.chat.id)
				return "*User* "..user_id.." *added* ban" 
		end
	end
	
-----------------------------------------
	if matches[1]:lower() == "ownerlist" and is_owner(msg)then
        local bash = 'owners:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Owner User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*Ownerlist is Empty !*"
              end
		    return text
          end

	if matches[1]:lower() == "modlist" and is_owner(msg)then
        local bash = 'mods:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Mod User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*modlist is Empty !*"
              end
		    return text
          end

	if matches[1]:lower() == "banlist" and is_owner(msg)then
        local bash = 'banneds:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Ban User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*banlist is Empty !*"
              end
		    return text
          end 
-----------------------------------------
		  if matches[1] == '/owners' then
        local bash = 'owners:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Owner User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*Ownerlist is Empty !*"
              end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanowners"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanowners' then
redis:del('owners:'..msg.chat.id)
   text = "*Ownerlist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "> Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
  if matches[1] == '/mods' then
        local bash = 'mods:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Mod User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*modlist is Empty !*"
              end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanmods"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanmods' then
redis:del('mods:'..msg.chat.id)
   text = "*Modlist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
   if matches[1] == '/banss' then
       local bash = 'banneds:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Ban User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*banlist is Empty !*"
              end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanbanss"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanbanss' then
redis:del('banneds:'..msg.chat.id)
   text = "*Banlist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
    if matches[1] == '/Filters' then
        local hash = 'chat:'..msg.chat.id..':filters'
            if hash then
              local names = redis:hkeys(hash)
                text = '*Filter Word List:*\n'
              for i=1, #names do
                text = text..'> '..names[i]..'\n'
              end
              if #names == 0 then
                  text = "*Filterlist is Empty !*"
              end
			end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanFilters"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanFilters' then
    redis:del('chat:'..msg.chat.id..':filters')
	text = "*Filterlist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
     if matches[1] == '/gpbanss' then
       local bash = 'banall:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Global banned list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*gbanlist is Empty !*"
              end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleangpbanss"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleangpbanss' then
    redis:del('banall:'..msg.chat.id)
	text = "*Banalllist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
      if matches[1] == '/silents' then
        local bash = 'silent:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Silent User list*:\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*silentlist is Empty !*"
              end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleansilents"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleansilents' then
    redis:del('silent:'..msg.chat.id)
	text = "*Silentlist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
       if matches[1] == '/admins' then
        local bash = 'admins:'..msg.chat.id
        local list = redis:smembers(bash)
		text = "*Admin User list:*\n"
		for k,v in pairs(list) do
        local user_info = redis:hgetall('user:'..v)
              if user_info and user_info.username then
                local username = user_info.username
                text = text..k.." - @"..username.." ["..v.."]\n"
              else
                text = text..k.." - "..v.."\n"
              end
            end
            if #list == 0 then
                text = "*adminlist is Empty !*"
              end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanadminss"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanadminss' then
    redis:del('admins:'..msg.chat.id)
	text = "*Adminlist* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
         if matches[1] == '/rules' then
        local rules = redis:get("grouprules"..msg.chat.id)
        if rules then
            text = "Rules Group:\n"..rules
        else
            text = '*Default rules:*\n*1-* _Spam and Flood Prohibited_ \n*2-* _Send Link Prohibited_\n*3-* _Respect The Rules of the Group_'
        end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanrules"}
},{ 
    {text = "SetRules", callback_data="/setrules"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanrules' then
    redis:del('grouprules:'..msg.chat.id)
	text = "*Rules* _Cleaned up_"
	
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
        if matches[1] == '/links' then
		local text = 'local link'
           local link = redis:get("grouplink"..msg.chat.id)
            if link then
                text = "*Group link:*\n[Click Here To Join "..msg.chat.title.." ]("..link..")"
            else
                text = '_Link Not Set!_\n_set a link for group with using_ [/setlink]'
            end
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
    {text = "Clean", callback_data="/cleanlinks"}
},{ 
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
end
if matches[1] == '/cleanlinks' then
    redis:del('grouplink:'..msg.chat.id)
	text = "*Link* _Cleaned up_"
 keyboard = {} 
 keyboard.inline_keyboard = {
    {
  {text = "Back", callback_data="/groupmod"}
    }
 }
edit(msg.chat.id, msg.message_id, text, keyboard, "md")
 end
		end  
   
return {
	patterns ={
'^###cb:(/lang)',
'^###cb:(/groupmod)',
'^###cb:(/dev)',
'^###cb:(/owners)',
'^###cb:(/cleanowners)',
'^###cb:(/mods)',
'^###cb:(/cleanmods)',
'^###cb:(/banss)',
'^###cb:(/cleanbans)',
'^###cb:(/Filters)',
'^###cb:(/cleanFilters)',
'^###cb:(/gpbanss)',
'^###cb:(/cleangpbanss)',
'^###cb:(/silents)',
'^###cb:(/cleanadmins)',
'^###cb:(/admins)',
'^###cb:(/cleanadminss)',
'^###cb:(/links)',
'^###cb:(/cleanlinks)',
'^###cb:(/rules)',
'^###cb:(/setrules)',
"^[!/#](add)$",
"^[!/#](rem)$",
"^[!/#](id)$",
"^[!/#](info)$",
"^[!/#](help)$",
"^[!/#](lock) (.*)$",
"^[!/#](unlock) (.*)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
"^[!/#](settings)$",
"^[!/#](manager)$",
"^[!/#](ownerlist)$",
"^[!/#](banlist)$",
"^[!/#](modlist)$",
"^[!/#](setowner)$",
"^[!/#](setowner) (%d+)$",
"^[!/#](demowner)$",
"^[!/#](demowner) (%d+)$",
"^[!/#](promote)$",
"^[!/#](promote) (%d+)$",
"^[!/#](demote)$",
"^[!/#](demote) (%d+)$",
"^[!/#](ban)$",
"^[!/#](ban) (%d+)$",
"^[!/#](unban)$",
"^[!/#](unban) (%d+)$",
"^[!/#](kick)$",
"^[!/#](kick) (%d+)$",
"^[!/#](link)$",
"^[!/#](setlink)$",
"^[!/#](setrules) (.*)$",
"^[!/#](rules)$",
"^[!/#](clean) (.*)$",
"^[!/#](blueberry)$",
"^[!/#](setflood) (%d+)$",
"^[!/#](setfloodtime) (%d+)$",
"^(https://telegram.me/joinchat/%S+)$",
"^(https://t.me/joinchat/%S+)$",
},
	run=run,
	pre_process=pre_process
}
