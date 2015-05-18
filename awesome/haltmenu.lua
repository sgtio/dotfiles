local haltmenu = {}


function haltmenu.haltdialog()
   command = io.popen('zenity --width=90 --height=200 --list --radiolist --text="Select logout action" --title="Logout" --column "Choice" --column "Action" TRUE Shutdown FALSE Reboot FALSE LogOut FALSE LockScreen FALSE Suspend')
   action = command:read('*a')
   command:close()
end

return haltmenu
