$notepad = "& ""C:\Program Files (x86)\Notepad++\notepad++.exe"""
$buildUtilPath = $MyInvocation.MyCommand.Path | Split-Path -Parent

$commands = [ordered]@{
	#Maven
	c = @{ label = "mvn Clean"; command = "mvn clean" }
	ci = @{ label = "mvn Clean Install"; command = "mvn clean install -DskipTests=true" }
	cit = @{ label = "mvn Clean Install Tests"; command = "mvn clean install" }
	i = @{ label = "mvn Install"; command = "mvn install -DskipTests=true" }
	t = @{ label = "mvn Test"; command = "mvn test" }
	
	conf = @{ label = "Edit config"; command = "$notepad ""$buildUtilPath\BuildUtil-cmds.ps1""" }	
}
