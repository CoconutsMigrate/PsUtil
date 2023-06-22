#
#   /-------------\ 
#   | Sample text |
#   \-------------/
#
function banner( $label ) {
	$pad = "-".PadRight($label.length + 2, "-")
	Write-Host
	Write-Host "   /$pad\"
	Write-Host "   | $label |"
	Write-Host "   \$pad/"
	Write-Host
}

function askYesNo( [string] $label, [string] $default ) {
	banner -label $label
	$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes"
	$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No"
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
	$defVal = if (('false', 'f', '0', 'no', 'n').contains($default.toLower())) { 1 } else { 0 }
	return (($host.ui.PromptForChoice("", "", $options, $defVal)) -eq 0)
}

function browseFolder([string] $prompt="Browse Folder", [string] $startFrom) {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
		Description = $prompt
		SelectedPath = $startFrom
	}
	if ($foldername.ShowDialog() -eq "OK") {
		return $foldername.SelectedPath
    } else {
		return $startFrom
    }
}

function isFile( [string] $file ) {
	return (($file -ne "") -and (Test-Path $file) -and ((Get-Item $file) -is [System.IO.FileInfo]))
}

function isFolder( [string] $file ) {
	return (($file -ne "") -and (Test-Path $file) -and ((Get-Item $file) -is [System.IO.DirectoryInfo]))
}
