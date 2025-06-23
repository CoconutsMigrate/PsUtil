. .\util.ps1

$global:param = @{ query = ""; include = "*.*"; exclude = ""; context = 0; showLines = $true; showNumbers = $true; showNames = $true }

function logo() {
	banner -label "Search Files v1.3"
}


function setParam() {
	do {
		$enteredQuery = $false
		logo
		Write-Host "Path                       [$(Get-Location)]"
		Write-Host "Context lines -c <n>       [$($param.context)]"
		Write-Host "File Include -i <include>  [$($param.include)]"
		Write-Host "Regex Exclude -e <exclude> [$($param.exclude)]"
		Write-Host "Show Found Lines -s        [$($param.showLines)]"
		Write-Host "Show Line Numbers -l       [$($param.showNumbers)]"
		Write-Host "Show File Names -n         [$($param.showNames)]"
		$query = Read-Host "Query                      [$($param.query)]"
		if ($query.startsWith("-c")) {
			$query = $query -replace "-c *"
			$param.context = [int]$query
		} elseif ($query.startsWith("-i")) {
			$query = $query -replace "-i *"
			if ($query -ne "") {
				$param.include = $query
			} else {
				$param.include = "*.*"
			}
		} elseif ($query.startsWith("-e")) {
			$query = $query -replace "-e *"
			$param.exclude = $query
		} elseif ($query.startsWith("-s")) {
			$param.showLines = -not $param.showLines
		} elseif ($query.startsWith("-l")) {
			$param.showNumbers = -not $param.showNumbers
		} elseif ($query.startsWith("-n")) {
			$param.showNames = -not $param.showNames
		} elseif ($query -ne "") {
			$param.query = $query
			$enteredQuery = $true
		} elseif ($query -eq "") {
			$enteredQuery = ($param.query -ne "")
		}
	} until ($enteredQuery)

}

Push-Location "$args"
$dir = Split-Path -Path (Get-Location) -Leaf
$host.ui.RawUI.WindowTitle = "[$($dir)] Search Folder"
while ( $true ) {
	setParam
	if ($param.query -ne "") {
		Clear
		logo
		Write-Host -foregroundColor Green "Query: $($param.query)"
		$lastPath = ""
		if ($param.exclude -eq "") {
			$out = Get-ChildItem -Recurse -Include $param.include | Select-String -Context $param.context -Pattern $param.query
		} else {
			$out = Get-ChildItem -Recurse -Include $param.include | ? { $_.FullName -notMatch $param.exclude } | Select-String -Context $param.context -Pattern $param.query
		}
		
		foreach ($item in $out) {
			if ($item.Path -ne $lastPath -and $param.showNames) {
				Write-Host
				Write-Host -ForegroundColor Cyan $item.Path
				$lastPath = $item.Path
			}
			if ($param.showLines) {
				foreach ($pre in $item.Context.PreContext) {
					Write-Host "|     $($pre)"
				}
				$lineNo = $item.LineNumber.toString().padRight(5) + " "
				if (-not $param.showNumbers) {
					$lineNo = ""
				}
				Write-Host -ForegroundColor Yellow "$($lineNo)$($item.Line)"
				
				foreach ($post in $item.Context.PostContext) {
					Write-Host "|     $($post)"
				}
				if ($param.context -gt 0) {
					Write-Host
				}
			}
		}		
	}
}
Pop-Location