$HCPU = "x86_64"
$HABI = "WIN64"
$HOS  = "Windows"

$dir = Get-Location
. "$dir\funcs.ps1"


$useem, $cpus = use_emulator $args 10
if ( $useem -eq $TRUE ){
    $HCPU = "vp64"
    $HABI = "VP64"
    $HOS  = "Windows"
    Write-Output "Using emulator", $useem, $cpus
}

if ( $cpus -gt 16){
	$cpus = 16
}




for ($cpu = $cpus - 1; $cpu -ge 0; $cpu--){
	$links=""
	for ($lcpu = 0; $lcpu -lt $cpus; $lcpu++)
	{
		$c1 = zero_pad $cpu
		$c2 = zero_pad $lcpu

		$links += add_link $c1 $c2 $links
	}
	boot_cpu_gui $cpu "$links"
}





