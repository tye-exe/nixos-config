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

-- The path within the /tmp folder to my stored values.
local TEMP_PATH = "/tmp/tye_nix_config/"

-- Path to the file storing identity.
local IDENTITY_FILE = path .. ".identity"
-- The possible valid identifiers.
local IDENTITIES = { "undefined", "tye-laptop", "tye-desktop" }


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
0 - undefined
1 - tye-laptop
2 - tye-desktop
:]])
    local num_input = io.read("*n")

    if num_input == nil then
      -- If invalid input was entered consume it.
      local text = io.read("*l")
      if text == "q" then
        os.exit()
      end

      print("Invalid option.")
      goto continue;
    end

    local chosen_ident = IDENTITIES[num_input + 1]
    print("Selected: " .. chosen_ident)
    set_ident(chosen_ident)
    break

    ::continue::
  end
end


-- Ensures that the path in the tmp folder exists
local function make_path()
  os.execute(("test -d %s || mkdir %s"):format(TEMP_PATH, TEMP_PATH))
end

-- Writes the path to TEMP_PATH folder before executing given command
local function execute(command)
  make_path()

  -- Path without trailing "/" char
  local path = path:sub(1, -2)
  local full_command = ("echo -n \"%s\" > %spath; %s"):format(path, TEMP_PATH, command)
  os.execute(full_command)
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

# Identity
"identity" - Set the identity of the system.
"identity-undefined" - Sets the identity to "undefined".
"identity-clear" - Clears the previously set identity.

# Misc
<anything else> - Shows this menu.

# Vanity
"logo" - Outputs the logo]]

-- The first arg passed.
local base_arg = arg[1]

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
    "sudo nixos-rebuild switch -I nixos-config=%ssystem/%s.nix --flake %s#%s --impure",
    path, raw_ident, path, ident)
  execute(command)

  -- home manager switch
elseif base_arg == "hm-switch" then
  local ident = get_ident()
  if ident == nil then
    os.exit(1)
  end

  local command = string.format("home-manager switch --flake %s#%s --impure", path, ident)
  execute(command)

  -- undefined system switch
elseif base_arg == "undefined-sys-switch" then
  local command = string.format(
    "sudo nixos-rebuild switch -I nixos-config=%ssystem/undefined.nix --flake %s#undefined --impure",
    path, path)
  execute(command)

  -- undefined home manager switch
elseif base_arg == "undefined-hm-switch" then
  local command = string.format("home-manager switch --flake %s#undefined --impure", path)
  execute(command)

  -- Sets identity to undefined
elseif base_arg == "identity-undefined" then
  print("Setting identity to undefined.")

  local previous = get_ident() or "none"
  print("Previous identity: \"" .. previous .. "\".")

  set_ident(IDENTITIES[1])

  -- Clears the current identity
elseif base_arg == "identity-clear" then
  print("Removing identity file.")

  local previous = get_ident() or "none"
  print("Previous identity: \"" .. previous .. "\".")

  os.remove(IDENTITY_FILE)

  -- Prints the logo to sout
elseif base_arg == "logo" then
  print(LOGO)
else
  print(HELP_TEXT)
end
