cmd.exe /c winrm quickconfig -q

cmd.exe /c winrm set winrm/config/service @{AllowUnencrypted="true"}
cmd.exe /c winrm set winrm/config/service/auth @{Basic="true"}

cmd.exe /c netsh advfirewall firewall set rule group="remote administration" new enable=yes

cmd.exe /c net stop winrm
cmd.exe /c net start winrm