function Log($text)
{
  if ($logging) {
    Write-Host $text
  }
}

function Trace($text)
{
  if ($tracing) {
    Write-Host $text
  }
}

function Create-FtpDirectory($ftpWithDir, $user, $pass) {
  $ftpRequest = [System.Net.FtpWebRequest]::Create("$ftpWithDir")
  $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
  $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
  $ftpRequest.UseBinary = $true
  $response = $ftpRequest.GetResponse();
  $response.Close();
}

function Upload-LocalDirToFtp($relativeDir, $ftpWithDir, $user, $pass)
{
  # Create webclient
  $webclient = New-Object System.Net.WebClient
  $webclient.Credentials = New-Object System.Net.NetworkCredential($user, $pass)

  foreach($item in (get-childitem (".\$relativeDir") -r)) {
    $relativePathToFile = ($item.FullName -replace [regex]::Escape($fullDir), "") # e.g. c:\git\myproject\server\wwwroot\assets\robots.txt => assets\robots.txt
    $uri = New-Object System.Uri($ftpWithDir + $relativePathToFile)

    if ($item.Attributes -eq "Directory") {
      Trace "Uploading folder $relativePathToFile"
      Create-FtpDirectory $uri  $user  $pass
    } else {
      Trace "Uploading file $relativePathToFile"
      $webclient.UploadFile($uri, $item.FullName)
    }
  }

}

function Delete-FtpFile($ftpWithFullPathToObject, $user, $pass)
{
  $ftpRequestDelete = [System.Net.FtpWebRequest]::Create("$ftpWithFullPathToObject")
  $ftpRequestDelete.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
  $ftpRequestDelete.Method = [System.Net.WebRequestMethods+Ftp]::DeleteFile
  $ftpRequestDelete.UseBinary = $true
  $responseDelete = $ftpRequestDelete.GetResponse();
  $responseDelete.Close();
}

function Delete-FtpDirectory($ftpWithFullPathToObject, $user, $pass)
{
  $ftpRequestDelete = [System.Net.FtpWebRequest]::Create("$ftpWithFullPathToObject")
  $ftpRequestDelete.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
  $ftpRequestDelete.Method = [System.Net.WebRequestMethods+Ftp]::RemoveDirectory
  $ftpRequestDelete.UseBinary = $true
  $responseDelete = $ftpRequestDelete.GetResponse();
  $responseDelete.Close();
}

function Delete-FtpDirectoryRecursively($ftpWithDir, $user, $pass, $excludeFiles) {
  $ftpRequestList = [System.Net.FtpWebRequest]::Create("$ftpWithDir")
  $ftpRequestList.Credentials = New-Object System.Net.NetworkCredential($user, $pass)
  $ftpRequestList.Method = [System.Net.WebRequestMethods+FTP]::ListDirectoryDetails

  $ftpRequestList.UseBinary = $False
  $ftpRequestList.KeepAlive = $False

  $ftpResponseList = $ftpRequestList.GetResponse()
  $responseStream = $ftpResponseList.GetResponseStream()

  # Create a nice Array of the detailed directory listing
  $streamReader = New-Object System.IO.Streamreader $responseStream
  $dirListing = (($streamReader.ReadToEnd()) -split [Environment]::NewLine)
  $streamReader.Close()

  # Remove last element (\n). Previously, this also removed "." and ".." as first two
  # elements but they are not listed now so we start at index 0
  $dirListing = $dirListing[0..($dirListing.Length-2)]

  $ftpResponseList.Close()

  $returnValue = $true;

  foreach ($curLine in $dirListing) {
    $lineTok = ($curLine -split '\ +')
    $curFile = $lineTok[8..($lineTok.Length-1)]
    if (-Not ($excludeFiles -contains $curFile))
    {
      $dirBool = ($lineTok -contains "<DIR>")
      If ($dirBool) {
        Trace "Parsing directory $($ftpWithDir)$($curFile)/"
        if (Delete-FtpDirectoryRecursively "$($ftpWithDir)$($curFile)/" $user $pass $excludeFiles) {
           # Delete-FtpDirectoryRecursively returns true if all objects could be removed, if so - delete the directory
          Trace "Removing empty directory $($ftpWithDir)$($curFile)/"
          Delete-FtpDirectory "$($ftpWithDir)$($curFile)/" $user $pass
        }
        else
        {
          Trace "Not removing non-empty directory $($ftpWithDir)$($curFile)/ (some files were excluded)"
        }
      } Else {
        Trace "Deleting file $($ftpWithDir)$($curFile)"
        Delete-FtpFile "$($ftpWithDir)$($curFile)" $user $pass
      }
    }
    else {
      Trace "Excluding $($ftpWithDir)$($curFile)"
      $returnValue = $false;
    }
  }

  return $returnValue;
}
