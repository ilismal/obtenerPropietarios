$avance = 1
$totalLíneas = "9999"
$urlWhois = 'http://whois.arin.net/rest'
Import-Csv .\logs.csv | ForEach-Object {
    Write-Progress -Activity "Obteniendo propietarios IPs" -Status "Consulta whois" -PercentComplete($avance/$totalLíneas*100)
    #Objeto para guardar los resultados
    $resultado = New-Object -TypeName PSObject
    #Dirección de origen
    $resultado | Add-Member -MemberType NoteProperty -Name Origen -Value $_."Src Addr" -Force
    #Dirección de destino
    $resultado | Add-Member -MemberType NoteProperty -Name Destino -Value $_."Dst Addr" -Force
    #País de destino
    $resultado | Add-Member -MemberType NoteProperty -Name País -Value $_.Country -Force
    #Propietario bloque IP destino
    $urlConsultaWhois = $urlWhois + "/ip/" + $_."Dst Addr"
    $respuestaConsulta = Invoke-RestMethod $urlConsultaWhois
    $titularIP = $respuestaConsulta.net.orgRef.name
    $resultado | Add-Member -MemberType NoteProperty -Name Titular -Value $titularIP -Force
    #Acción
    $resultado | Add-Member -MemberType NoteProperty -Name Acción -Value $_.Action -Force
    $resultado | Export-Csv logs_con_titulares_IP.csv -Append -Encoding UTF8
    $avance++                 
}
