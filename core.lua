#!/usr/bin/env lua

-- Gets the path to the dir for the lua script
local exec_path = arg[0]
-- Removes the filename from the path
local path = exec_path:match(".*/")

-- If the path isn't absolute, find absolute path
if path:sub(1, 1) ~= "/" then
  -- Gets the cwd to find the full path
  local working_dir = io.popen("pwd"):read() .. "/"
  path = working_dir .. path
end

-- The first arg passed.
local base_arg = arg[1]

-- Path to the file storing identity.
local IDENTITY_FILE = path .. ".identity"
-- The possible valid identifiers.
local IDENTITIES = { "tye-laptop", "tye-desktop" }


-- Matches the chosen identity against the existing ones
local function match_ident(identity)
  for _, ident in pairs(IDENTITIES) do
    if ident == identity then
      return ident
    end
  end
  return nil
end

-- Test if the file exists.
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- Gets the identity stored in the ident file.
local function get_ident()
  local file;

  if not file_exists(IDENTITY_FILE) then
    return nil
  else
    file = io.open(IDENTITY_FILE, "r")
  end

  local value = file:read "*a"
  return match_ident(value)
end

-- Sets the identity stored in the ident file.
local function set_ident(identity)
  local file = io.open(IDENTITY_FILE, "w")
  file:write(identity)
end

local function generate_identity()
  while get_ident() == nil do
    io.write(
      [[Select your identity:
q - quit
1 - tye-laptop
2 - tye-desktop
:]])
    local chosen_ident = IDENTITIES[io.read("*n")]

    if chosen_ident == nil then
      -- If invalid input was entered consume it.
      local text = io.read("*l")
      if text == "q" then
        os.exit()
      end

      print("Invalid option.")
      goto continue;
    end

    print("Selected: " .. chosen_ident)
    set_ident(chosen_ident)
    break

    ::continue::
  end
end

-- Select operation:

-- It looks cool, okay?
--
-- From: https://ascii-generator.site/t/
-- Font: sub-zero
-- Text: "tye - nix"
local LOGO =
[[
------------------------------------------------------------------
 ______   __  __     ______           __   __     __     __  __
/\__  _\ /\ \_\ \   /\  ___\         /\ "-.\ \   /\ \   /\_\_\_\
\/_/\ \/ \ \____ \  \ \  __\         \ \ \-.  \  \ \ \  \/_/\_\/_
   \ \_\  \/\_____\  \ \_____\        \ \_\\"\_\  \ \_\   /\_\/\_\
    \/_/   \/_____/   \/_____/         \/_/ \/_/   \/_/   \/_/\/_/

------------------------------------------------------------------
]]
-- The options for the program args
--
--
-- Help text:
-- From: https://ascii-generator.site/t/
-- Font: sub-zero
-- Text: "help"
local HELP_TEXT = [[
------------------------------------------
 __  __     ______     __         ______
/\ \_\ \   /\  ___\   /\ \       /\  == \
\ \  __ \  \ \  __\   \ \ \____  \ \  _-/
 \ \_\ \_\  \ \_____\  \ \_____\  \ \_\
  \/_/\/_/   \/_____/   \/_____/   \/_/

------------------------------------------
# Nix switch commands
"sys-switch" - Outputs the command to perform a nixos system switch.
"hm-switch" - Outputs the command to perform a home-manager switch.
"undefined-sys-switch" - Outputs the command to perform a nixos system switch for an undefined identity.
"undefined-hm-switch" - Outputs the command to perform a home-manager switch for an undefined identity.

# Misc
"identity" - Set the identity of the system.
<anything else> - Shows this menu.

# Vanity
"logo" - Outputs the logo]]

if base_arg == "identity" then
  os.remove(IDENTITY_FILE)
  generate_identity()

  -- system switch
elseif base_arg == "sys-switch" then
  local ident = get_ident()
  if ident == nil then
    os.exit(1)
  end

  -- Removes any characters proceeding the final non letter char.
  local raw_ident = string.match(ident, "%a*$")

  local command = string.format(
    "nixos-rebuild switch -I nixos-config=%ssystem/%s.nix --flake %s#%s --impure",
    path, raw_ident, path, ident)
  io.write(command)

  -- home manager switch
elseif base_arg == "hm-switch" then
  local ident = get_ident()
  if ident == nil then
    os.exit(1)
  end

  local command = string.format("home-manager switch --flake %s#%s", path, ident)
  io.write(command)

  -- undefined system switch
elseif base_arg == "undefined-sys-switch" then
  local command = string.format(
    "nixos-rebuild switch -I nixos-config=%ssystem/undefined.nix --flake %s#undefined --impure",
    path, path)

  io.write(command)

  -- undefined home manager switch
elseif base_arg == "undefined-hm-switch" then
  local command = string.format("home-manager switch --flake %s#undefined", path)

  io.write(command)

  -- Prints the logo to sout
elseif base_arg == "logo" then
  print(LOGO)
else
  print(HELP_TEXT)
end
