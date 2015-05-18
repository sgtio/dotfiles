local awful = require("awful")

local haltmenu = {}


function haltmenu.haltdialog()
   command = io.popen('zenity --width=90 --height=200 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE Shutdown FALSE Reboot FALSE LogOut FALSE LockScreen FALSE Suspend')
   action = command:read('*a')
   command:close()
   if action == "Shutdown" then
      awful.util.spawn_with_shell('systemctl halt')
   elseif action == "Reboot" then
      awful.util.spawn_with_shell('systemctl reboot')
   elseif action == "LogOut" then
      awesome.quit()
   elseif action == "Suspend" then
      awful.util.spawn_with_shell('systemctl suspend')
   elseif action == "LockScreen" then
      awful.util.spawn_with_shell('/home/sejo/.config/dotfiles/scripts/lock.sh')
   end   
end

return haltmenu
