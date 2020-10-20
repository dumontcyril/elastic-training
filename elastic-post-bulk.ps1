<#
---------------------------------------------------------
Script d'injection de données en HTTP(S) / POST / BASIC
---------------------------------------------------------

Exemple: .\post.ps1 data.txt http://localhost:8080/JAXRS_SECURE_TOMCAT/jersey/secure/json user1 user1

#>

$File = $args[0]	# Nom du fichier contenant les données JSON à injecter
$Uri = $args[1]	# URI cible
$Username	= $args[2]	# user
$Password = $args[3]	# password
$Step = $args[4]	# nb de lignes à traiter en un seul POST

#
# Execution requête HTTP(S)/POST
#
function Post-Data ($Uri, $Data, $ContentType = "application/x-ndjson") {
	# header avec authentification BASIC
	$Headers = @{ Authorization = "Basic {0}" -f [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Username, $Password))) }
	# exécution requête POST
	$Res = Invoke-WebRequest -Uri $Uri -Headers $Headers -ContentType $ContentType -Method POST -Body $Data
	return $Res
}

#
# Préparation bloc commandes + données
#
function Gen-Data ($Lines, $Start, $Nb = $Step, $Command = "{`"index`": {}}") {
	$Newline = "`n"
	$Data = $Command + $Newline + $Lines[$Start] + $Newline
	$End = $Start + $Nb - 1
	if ($End -ge $Lines.Count) {
		$End = $Lines.Count - 1
	}
	For ($i = $Start + 1; $i -le $End; $i++) {
		$Data = $Data + $Newline + $Command + $Newline + $Lines[$i]
	}
	return $Data + $Newline
}

# réglages TLS pour HTTPS (si besoin)
[Net.ServicePointManager]::SecurityProtocol = 'Tls12, Tls11, Tls, Ssl3' 

# Lit le fichier 
$JsonData = Get-Content $File
Write-Host "Nb de lignes: " $JsonData.Count
# Traite chaque ligne du fichier 
For ($i = 0; $i -lt $JsonData.Count; $i += $Step) {
	$Data = Gen-Data -Lines $JsonData -Start $i
	# Write-Host $Data
	$Res = Post-Data -Uri $Uri -Data $Data
}
