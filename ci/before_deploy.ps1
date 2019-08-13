# This script takes care of packaging the build artifacts that will go in the
# release zipfile

$SRC_DIR = $PWD.Path
$STAGE = [System.Guid]::NewGuid().ToString()

Set-Location $ENV:Temp
New-Item -Type Directory -Name $STAGE
Set-Location $STAGE

$ZIP = "$SRC_DIR\zeusFreestyle.zip"

7z a "$ZIP" $SRC_DIR\missions\*

Push-AppveyorArtifact "$ZIP"

Remove-Item *.* -Force
Set-Location ..
Remove-Item $STAGE
Set-Location $SRC_DIR
