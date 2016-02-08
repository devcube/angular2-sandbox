# https://gallery.technet.microsoft.com/scriptcenter/PowerShell-FTP-Client-db6fe0cb
# Once you extract to your module path, for example:
# C:\WINDOWS\System32\WindowsPowerShell\v1.0\Modules
# the module can be loaded and used. Below is an example connection
# to a FTP server and its contents listed.

Import-Module c:\WINDOWS\System32\WindowsPowerShell\v1.0\Modules\PSFTP\PSFTP.psm1

# $FTPServer = 'xyz.ftp.azurewebsites.windows.net'
# $FTPUsername = 'username'
# $FTPPassword = 'password'
$FTPSecurePassword = ConvertTo-SecureString -String $FTPPassword -asPlainText -Force
$FTPCredential = New-Object System.Management.Automation.PSCredential($FTPUsername,$FTPSecurePassword)

Set-FTPConnection -Credentials $FTPCredential -Server $FTPServer -Session MySession -UsePassive
$Session = Get-FTPConnection -Session MySession

Get-FTPChildItem -Session $Session -Path / #-Recurse

# Push code (but not wwwroot contents) to azure using GIT
# See more here: https://azure.microsoft.com/en-us/documentation/articles/web-sites-create-web-app-using-vscode/
# And this article for subtree push of server folder: http://stackoverflow.com/questions/28151672/git-push-only-a-subdirectory-to-a-remote-branch
git subtree push --prefix server azure master
