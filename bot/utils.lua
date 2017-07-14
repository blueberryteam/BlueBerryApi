local clock = os.clock
function sleep(time)  -- seconds
  local t0 = clock()
  while clock() - t0 <= time do end
end

function scandir(directory)
  local i, t, popen = 0, {}, io.popen
  for filename in popen('ls -a "'..directory..'"'):lines() do
    i = i + 1
    t[i] = filename
  end
  return t
end

function plugins_names( )
  local files = {}
  for k, v in pairs(scandir("plugins")) do
    -- Ends with .lua
    if (v:match(".lua$")) then
      table.insert(files, v)
    end
  end
  return files
end

function is_sudo(msg)
  local var = false
  -- Check users id in config
  for v,user in pairs(_config.sudo_users) do
    if user == msg.from.id then
      var = true
    end
  end
  return var
end

function is_owner(msg)
  local var = false
  local user_id = msg.from.id
  local chat_id = msg.chat.id
  local hash =  'owners:'..chat_id
  local owner = redis:sismember(hash, user_id)
  if owner then
    var = true
  end
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      var = true
    end
  end
  return var
end

function is_mod(msg)
  local var = false
  local user_id = msg.from.id
  local chat_id = msg.chat.id
  local hash =  'mod:'..chat_id
  local momod = redis:sismember(hash, user_id)
  local hashss =  'owners:'..chat_id
  local owner = redis:sismember(hashss, user_id)
  if momod then
    var = true
  end
  if owner then
    var = true
  end
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      var = true
    end
  end
  return var
end

function get_var_inline(msg)
if msg.query then
if msg.query:match("-%d+") then
msg.chat = {}
msg.chat.id = "-"..msg.query:match("%d+")
    end
elseif not msg.query then
msg.chat.id = msg.chat.id
end
match_plugins(msg)
end
function get_var(msg)
msg.reply = {}
msg.fwd_from = {}
 msg.data = {}
msg.id = msg.message_id
if msg.reply_to_message then
msg.reply_id = msg.reply_to_message.message_id
msg.reply.id = msg.reply_to_message.from.id
if msg.reply_to_message.from.last_name then
msg.reply.print_name = msg.reply_to_message.from.first_name..' '..msg.reply_to_message.from.last_name
else
msg.reply.print_name = msg.reply_to_message.from.first_name
end
msg.reply.first_name = msg.reply_to_message.from.first_name
msg.reply.last_name = msg.reply_to_message.from.last_name
msg.reply.username = msg.reply_to_message.from.username
end
if msg.from.last_name then
msg.from.print_name = msg.from.first_name..' '..msg.from.last_name
else
msg.from.print_name = msg.from.first_name
end
if msg.forward_from then
msg.fwd_from.id = msg.forward_from.id
msg.fwd_from.first_name = msg.forward_from.first_name
msg.fwd_from.last_name = msg.forward_from.last_name
if msg.forward_from.last_name then
msg.fwd_from.print_name = msg.forward_from.first_name..' '..msg.forward_from.last_name
else
msg.fwd_from.print_name = msg.forward_from.first_name
end
msg.fwd_from.username = msg.forward_from.username
end
match_plugins(msg)
end
