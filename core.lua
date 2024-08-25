#!/usr/bin/env lua

-- Gets the path to the dir for the lua script
local exec_path = arg[0]
local path_len = string.len(exec_path) - string.len("core.lua")
local path = string.sub(exec_path, 0, path_len)

-- The first arg passed (excluding the exe path)
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

  -- Removes the "tye-" from the start of the ident
  local raw_ident = string.sub(ident, 5, string.len(ident))

  local command = string.format(
    "nixos-rebuild switch -I nixos-config=/home/tye/nixos/system/%s.nix --flake /home/tye/nixos/#%s --impure",
    raw_ident, ident)
  io.write(command)

  -- home manager switch
elseif base_arg == "hm-switch" then
  local ident = get_ident()
  if ident == nil then
    os.exit(1)
  end

  local command = string.format("home-manager switch --flake /home/tye/nixos/#%s", ident)
  io.write(command)

  -- undefined system switch
elseif base_arg == "undefined-sys-switch" then
  io.write(
    "nixos-rebuild switch -I nixos-config=/home/tye/nixos/system/undefined.nix --flake /home/tye/nixos/#undefined --impure")

  -- undefined home manager switch
elseif base_arg == "undefined-hm-switch" then
  io.write(
    "home-manager switch --flake /home/tye/nixos/#undefined")

  -- Prints the logo to sout
elseif base_arg == "logo" then
  print(LOGO)
else
  print(HELP_TEXT)
end
