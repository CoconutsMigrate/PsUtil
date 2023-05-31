param ([string] $path)

. .\util.ps1

$global:commands = [ordered]@{ cb = @{ label = "dir"; command = "dir" }}
$global:sysCmds = [ordered]@{
    "-r" = { $global:commands = loadCommands };
    "-c" = { $args[0] };
    "-x" = { Exit }
}

function loadCommands() {
	if (isFile $PSScriptRoot\BuildUtil-cmds.ps1) {
		. $PSScriptRoot\BuildUtil-cmds.ps1
	}
	return $commands
}
$global:commands = loadCommands

function listCommands() {
	foreach ($cmd in $global:commands.GetEnumerator()) {
		$cmdp = $cmd.value
		Write-Host -ForegroundColor Cyan "$($cmd.Name.padRight(7)): $($cmdp.label)"
	}
	Write-Host -ForegroundColor Yellow "-r     : Reload configuration"
	Write-Host -ForegroundColor Yellow "-c ___ : Run the specified command"
	Write-Host -ForegroundColor Yellow "-d ___ : Details on the specified command"
	Write-Host -ForegroundColor Yellow "-x     : Exit"
}

function selectPath() {
	while ($path -eq "") {
		$query = browseFolder -prompt "Search Folder" -startFrom .
		if (isFolder $query) {
			$path = $query
		}
	}
	return $path
}
$path = selectPath

Push-Location $path

$userQuery = ""

function windowTitle( $title ) {
    $host.ui.RawUI.WindowTitle = "Build: $title"
}

function runCmd( $cmd ) {
	Write-Host "Running $cmd"
	Invoke-Expression -Command "$cmd"
}

function cmdDetails( $key ) {
	if ($global:commands.Contains($key)) {
		$c = $global:commands[$key]
		windowTitle -title "Details"
		Write-Host -ForegroundColor Yellow "Command Details"
		Write-Host
		Write-Host -ForegroundColor Yellow "Key     : $($key)"
		Write-Host -ForegroundColor Yellow "Label   : $($c.label)"
		if ($c.command -is [Array]) {
			Write-Host -ForegroundColor Yellow "Command : $($c.command[0])"
			for ($i = 0; $i -lt $c.command.length; $i++) {
				Write-Host -ForegroundColor Yellow "          $($c.command[$i])"
			}
		} else {
			Write-Host -ForegroundColor Yellow "Command : $($c.command)"
		}
	}
}

while ($true) {
	Write-Host
	Write-Host
	Write-Host -ForegroundColor Yellow "Path: $(Get-Location)"
	Write-Host
	Write-Host -ForegroundColor Green "###############################################"
	Write-Host
	listCommands
	$query = Read-Host -Prompt "Select command [$($userQuery)]"
	if ($query -ne "") {
		$userQuery = $query
	}
	clear
    Write-Host "Run at: $(Get-Date -Format "HH:mm:ss")"
    if ($global:commands.Contains($userQuery)) {
        $c = $global:commands[$userQuery]
        windowTitle -title $c.label
		if ($c.command -is [Array]) {
			for ($i = 0; $i -lt $c.command.length; $i++) {
				runCmd -cmd $c.command[$i]
				Write-Host
			}
		} else {
			runCmd -cmd $c.command
		}
		Write-Host "Finished at: $(Get-Date -Format "HH:mm:ss")"
    } elseif ($userQuery -eq "-r") {
		$global:commands = loadCommands
	} elseif ($userQuery -like "-c *") {
		$cmd = $userQuery -replace "^-c *"
        windowTitle -title $cmd
		runCmd -cmd $cmd
	} elseif ($userQuery -like "-d *") {
		$query = $userQuery -replace "^-d *"
		write-host
		foreach ($cmd in $global:commands.GetEnumerator()) {
			if ($cmd.Name -like $query) {
				cmdDetails -key $cmd.Name
			}
		}		
	} elseif ($userQuery -eq "-x") {
		exit
	}
}