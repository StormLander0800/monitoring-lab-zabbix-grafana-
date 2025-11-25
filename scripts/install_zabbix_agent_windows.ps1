<#
.SYNOPSIS
  Script de instalação silenciosa do Zabbix Agent em Windows.

.DESCRIPTION
  Baixa (ou usa um MSI previamente copiado) e instala o Zabbix Agent
  configurando o servidor Zabbix, agente ativo e hostname.

.PARAMETER ZabbixServer
  IP ou hostname do servidor Zabbix.

.PARAMETER Hostname
  Nome do host que aparecerá no Zabbix (padrão: COMPUTERNAME).

.PARAMETER MsiPath
  Caminho para o MSI do agente Zabbix (se já estiver disponível localmente).

.EXAMPLE
  .\install_zabbix_agent_windows.ps1 -ZabbixServer 192.168.4.212

#>

param (
    [Parameter(Mandatory = $true)]
    [string]$ZabbixServer,

    [Parameter(Mandatory = $false)]
    [string]$Hostname = $env:COMPUTERNAME,

    [Parameter(Mandatory = $false)]
    [string]$MsiPath = "C:\Temp\zabbix_agent-7.0.x-windows-amd64-openssl.msi"
)

Write-Host "Iniciando instalação do Zabbix Agent..." -ForegroundColor Cyan

# Cria pasta temporária se necessário
$msiDir = Split-Path $MsiPath
if (-not (Test-Path $msiDir)) {
    New-Item -Path $msiDir -ItemType Directory -Force | Out-Null
}

# TODO: opcional - baixar o MSI de um repositório interno/URL se não existir
if (-not (Test-Path $MsiPath)) {
    Write-Host "MSI não encontrado em $MsiPath." -ForegroundColor Yellow
    Write-Host "Copie o instalador do Zabbix Agent para este caminho ou ajuste o parâmetro -MsiPath." -ForegroundColor Yellow
    exit 1
}

# Monta linha de comando do msiexec
$arguments = @(
    "/i `"$MsiPath`"",
    "SERVER=$ZabbixServer",
    "SERVERACTIVE=$ZabbixServer",
    "HOSTNAME=$Hostname",
    "/qn",
    "/norestart"
) -join " "

Write-Host "Instalando agente com parâmetros:" -ForegroundColor Cyan
Write-Host $arguments

$process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -PassThru

if ($process.ExitCode -eq 0) {
    Write-Host "Zabbix Agent instalado com sucesso." -ForegroundColor Green
} else {
    Write-Host "Falha na instalação do Zabbix Agent. Código de saída: $($process.ExitCode)" -ForegroundColor Red
    exit $process.ExitCode
}

# Reinicia o serviço para garantir que está rodando
Write-Host "Reiniciando serviço do Zabbix Agent..." -ForegroundColor Cyan
Try {
    Restart-Service -Name "Zabbix Agent" -ErrorAction Stop
    Write-Host "Serviço Zabbix Agent reiniciado com sucesso." -ForegroundColor Green
}
Catch {
    Write-Host "Não foi possível reiniciar o serviço Zabbix Agent: $_" -ForegroundColor Red
}
