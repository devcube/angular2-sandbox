" "
"Pushing latest code to git (azure branch)"
# Push code (but not wwwroot contents) to azure using GIT
# See more here: https://azure.microsoft.com/en-us/documentation/articles/web-sites-create-web-app-using-vscode/
# And this article for subtree push of server folder: http://stackoverflow.com/questions/28151672/git-push-only-a-subdirectory-to-a-remote-branch
git subtree push --prefix server azure master

# Since the wwroot contents is not checked into git, upload these files using ftp

# https://gallery.technet.microsoft.com/scriptcenter/PowerShell-FTP-Client-db6fe0cb
# Once you extract to your module path, for example:
# C:\WINDOWS\System32\WindowsPowerShell\v1.0\Modules
# the module can be loaded and used. Below is an example connection
# to a FTP server and its contents listed.
# Examples here: http://tsimaile.blogspot.se/2013/12/powershell-ftp-module.html

Import-Module c:\WINDOWS\System32\WindowsPowerShell\v1.0\Modules\PSFTP\PSFTP.psm1

$FTPServer = 'xyz.ftp.azurewebsites.windows.net'
$FTPUsername = 'webapp\xyz'
$FTPPassword = 'xyz'
$FTPPath = "/site/wwwroot"
$FTPFullPath = "ftp://$FTPServer"
$LocalPath = "server\wwwroot"
$LocalUploadRoot = (Join-Path $PSScriptRoot $LocalPath) + "\"
$FTPSecurePassword = ConvertTo-SecureString -String $FTPPassword -asPlainText -Force
$FTPCredential = New-Object System.Management.Automation.PSCredential($FTPUsername,$FTPSecurePassword)

# Establish connection to FTP and suppress output (*>$null)
Set-FTPConnection -Credentials $FTPCredential -Server $FTPServer -Session MySession *>$null
$Session = Get-FTPConnection -Session MySession



# Remove all files (skip directories since they probably contain contents) except web.config (since that file is generated, not uploaded by this script)
" "
"Removing all files (not directories) from FTP/site/wwwroot, except web.config"
Get-FTPChildItem -Path $FTPPath -Recurse -Session $session | where-object {$_.Name -ne "web.config" -and $_.Dir -ne "DIR"} |
% {
  $FTPFile = ($_.FullName -replace [regex]::Escape($FTPFullPath), "") # e.g. ftp://server/dir1/dir2/file.txt => dir1/dir2/file.txt
  "Removing file: " + $FTPFile
  Remove-FTPItem -Path $FTPFile -Session $session *>$null
}

# # Remove all empty directories (DISABLED! Since this script cannot CREATE directories that have to be handled manually as of now)
# " "
# "Removing all directories (which are now empty) from FTP/site/wwwroot"
# Get-FTPChildItem -Path $FTPPath -Recurse -Session $session | where-object {$_.Name -ne "web.config" -and $_.Dir -eq "DIR"} |
# % {
#   $FTPFile = ($_.FullName -replace [regex]::Escape($FTPFullPath), "") # e.g. ftp://server/dir1/dir2/file.txt => dir1/dir2/file.txt
#   "Removing directory: " + $FTPFile
#   Remove-FTPItem -Path $FTPFile -Session $session *>$null
# }

# Upload all files from server/wwwroot to FTP/site/wwwroot
" "
"Uploading all files from server/wwwroot to FTP/site/wwwroot"
Get-ChildItem -File -Recurse -Path $LocalPath |
% {
  $RelativePathToFile = ($_.FullName -replace [regex]::Escape($LocalUploadRoot), "") # e.g. c:\git\myproject\server\wwwroot\assets\robots.txt => assets\robots.txt
  $UploadFolder = ($RelativePathToFile -replace [regex]::Escape($_.Name), "") # e.g. assets\robots.txt => assets\
  $FTPFile = $FTPPath + "/" + $UploadFolder.Replace("\", "/") # e.g. site/wwwroot/assets/
  "Uploading file: " + ($_.FullName -replace [regex]::Escape($PSScriptRoot), "") # e.g. c:\git\myproject\server\wwwroot\assets\robots.txt => server\wwwroot\assets\robots.txt
  Add-FTPItem -Path $FTPFile -LocalPath $_.FullName -Overwrite -Session $session *>$null
}
