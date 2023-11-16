
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
	$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No")
	$defVal = if (('false', 'f', '0', 'no', 'n').contains($default.toLower())) { 1 } else { 0 }
	return (($host.ui.PromptForChoice("", "", $options, $defVal)) -eq 0)
}

#
# Usage: multiAsk "question" "&firstOptionWithF" "SecondOptionWith&T" "SomeOther&OptionWithO"
#
function multiAsk( [string] $label, [string] $p1, [string] $p2, [string] $p3, [string] $p4, [string] $p5, [string] $p6, [string] $p7, [string] $p8 ) {
	banner -label $label
	$arr = (@( $p1, $p2, $p3, $p4, $p5, $p6, $p7, $p8 )).Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
	$options = [System.Management.Automation.Host.ChoiceDescription[]] $arr
	return ($host.ui.PromptForChoice("", "", $options, 0))
}

function inputWithDefault( [string] $label, [string] $default ) {
	$val = Read-Host -Prompt "$($label) [$($default)]"
	if ($val -eq "") {
		$val = $default
	}
	return $val
}

function browseFolder([string] $prompt="Browse Folder", [string] $startFrom = ".") {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
		Description = $prompt
		SelectedPath = (Resolve-Path $startFrom).path
	}
	if ($foldername.ShowDialog() -eq "OK") {
		return $foldername.SelectedPath
    } else {
		return ""
    }
}

function browseFile([string] $prompt="Browse File", [string] $startFrom = ".", [string] $filter="All|*.*") {
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
	
	$openPath = (Resolve-Path $startFrom).path
	$fileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{
		Title = $prompt
		Multiselect = $false
		Filter = $filter
		InitialDirectory = $openPath
	}
	if ($fileBrowser.ShowDialog() -eq "OK") {
		return $fileBrowser.FileName
    } else {
		return ""
    }
}

function isFile( [string] $file ) {
	return (($file -ne "") -and (Test-Path $file) -and ((Get-Item $file) -is [System.IO.FileInfo]))
}

function isFolder( [string] $file ) {
	return (($file -ne "") -and (Test-Path $file) -and ((Get-Item $file) -is [System.IO.DirectoryInfo]))
}
