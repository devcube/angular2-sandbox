# Parameters
$relativeDir = "server\wwwroot"
$fullDir = (Join-Path $PSScriptRoot $relativeDir) + "\"
$ftpWithDir = "ftp://host/folder/subfolder/"
$user = "username"
$pass = "password"
$logging = $true
$tracing = $false

# Load functions from separate file
. "$PSScriptRoot\FtpFunctions.ps1"

Log "Pushing latest code to git (azure branch)"
# Push code (but not wwwroot contents) to azure using GIT
# See more here: https://azure.microsoft.com/en-us/documentation/articles/web-sites-create-web-app-using-vscode/
# And this article for subtree push of server folder: http://stackoverflow.com/questions/28151672/git-push-only-a-subdirectory-to-a-remote-branch
git subtree push --prefix server azure master

# Build webpack files for production
Log "Building webpack production build..."
npm run build:prod

# Since the wwroot contents is not checked into git, upload these files using ftp

# Remove all files except web.config from ftpWithDir
$excludeFiles = ("web.config")
Log "Removing all files from $ftpWithDir (except $excludeFiles)..."
$dummyReturnValue = Delete-FtpDirectoryRecursively $ftpWithDir $user $pass $excludeFiles

# Upload all files from relativeDir to ftpWithDir
Log "Uploading files from $relativeDir to $ftpWithDir..."
Upload-LocalDirToFtp $relativeDir $ftpWithDir $user $pass