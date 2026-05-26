$Host.UI.RawUI.WindowTitle = "Windows Cleaner"

function Mostrar-Banner {
  Clear-Host
  Write-Host ""
  Write-Host "=========================================" -ForegroundColor Cyan
  Write-Host "         WINDOWS CLEANER TOOL" -ForegroundColor Cyan
  Write-Host "=========================================" -ForegroundColor Cyan
  Write-Host "    Maintenance | Cleanup | Support" -ForegroundColor DarkGray 
  Write-Host ""
}

function Show-Section {
    param([string]$Title)

    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "         $Title" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Menu-Opcoes {
  param(
    [string]$Number,
    [string]$Text,
    [string]$Color = "Cyan"
  )

  Write-Host "[$Number] " -NoNewLine -ForegroundColor $Color
  Write-Host $Text -ForegroundColor White

}

function Retornar {
  Write-Host ""
  Pause
}

function Status {
  param(
    [string]$Message,
    [string]$Type = "INFO"
  )

  if ($Type -eq "OK"){
    Write-Host "[OK] $Message" -ForegroundColor Green
  }
  elseif ($Type -eq "WARNING"){
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
  }
  elseif ($Type -eq "ERROR"){
    Write-Host "[ERROR] $Message" -ForegroundColor Red
  }
  else {
    Write-Host "[*] $Message" -ForegroundColor Gray
  }
}

function LimparUserTemp {
    Status "Limpando TEMP do Usuario..." "INFO"
    $path = $env:TEMP 

    try {
      Remove-Item "$path\*" -Recurse -Force -ErrorActio SilentlyContinue
      Status "TEMP do Usuario limpo com sucesso." "OK"
    } 
    catch {
      Status "Erro ao limpar TEMP do Usuario." "ERROR"
    }
    Retornar
}

function LimparWinTemp {
    Status "Limpando TEMP do Windows..." "INFO"
    $path = "C:\Windows\temp"

    try {
      Remove-Item "$path\*" -Recurse -Force -ErrorActio SilentlyContinue
      Status "TEMP do Windows limpo com sucesso." "OK"
    } 
    catch {
      Status "Erro ao limpar TEMP do Windows. Tente executar como administrador" "ERROR"
    }
    Retornar
}

function LimparPrefetch {
    Status "Limpando Prefetch..." "INFO"

    $path = "C:\Windows\Prefetch"

    if (!(Test-Path $path)) {
        Status "Pasta Prefetch nao encontrada." "WARNING"
        Retornar
        return
    }

    $filesBefore = Get-ChildItem $path -Force -ErrorAction SilentlyContinue
    $countBefore = $filesBefore.Count

    Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue

    $filesAfter = Get-ChildItem $path -Force -ErrorAction SilentlyContinue
    $countAfter = $filesAfter.Count

    $removed = $countBefore - $countAfter

    if ($removed -gt 0) {
        Status "$removed arquivos removidos da Prefetch." "OK"
    }
    else {
        Status "Nenhum arquivo removido. Alguns arquivos podem estar em uso ou exigir administrador." "WARNING"
    }

    Retornar
}

function LimparCacheDNS {

   Status "Limpando cache DNS..." "INFO"

    try {

        ipconfig /flushdns | Out-Null

        Status "Cache DNS limpo com sucesso." "OK"
    }
    catch {

        Status "Erro ao limpar cache DNS." "ERROR"
    }

    Retornar
}

function LimparLixeira {

    Status "Esvaziando lixeira..." "INFO"

    try {

        Clear-RecycleBin -Force -ErrorAction SilentlyContinue

        Status "Lixeira esvaziada com sucesso." "OK"
    }
    catch {

        Status "Erro ao esvaziar lixeira." "ERROR"
    }

    Retornar
}


function LimparCacheChrome {

    Status "Limpando cache do Google Chrome..." "INFO"

    $paths = @(
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
        "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    Status "Cache do Chrome limpo." "OK"
}

function LimparCacheEdge {

    Status "Limpando cache do Microsoft Edge..." "INFO"

    $paths = @(
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache",
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache"
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    Status "Cache do Edge limpo." "OK"
}

function LimparCacheFirefox {

    Status "Limpando cache do Firefox..." "INFO"

    $path = "$env:APPDATA\Mozilla\Firefox\Profiles"

    if (Test-Path $path) {
        Remove-Item "$path\*\cache2\*" -Recurse -Force -ErrorAction SilentlyContinue
    }

    Status "Cache do Firefox limpo." "OK"
}

function LimparMenuNavegadores {

    do {

        Clear-Host

        Show-Section "LIMPEZA DE NAVEGADORES"

        Menu-Opcoes "1" "Google Chrome"
        Menu-Opcoes "2" "Microsoft Edge"
        Menu-Opcoes "3" "Mozilla Firefox"
        Menu-Opcoes "4" "Limpar todos" "Yellow"

        Write-Host ""

        Menu-Opcoes "0" "Voltar" "Red"

        Write-Host ""

        $browserOption = Read-Host "Escolha uma opcao"

        switch ($browserOption) {

            1 {
                LimparCacheChrome
                Retornar
            }

            2 {
                LimparCacheEdge
                Retornar
            }

            3 {
                LimparCacheFirefox
                Retornar
            }

            4 {
                LimparCacheChrome
                LimparCacheEdge
                LimparCacheFirefox

                Status "Todos os navegadores foram limpos." "OK"

                Retornar
            }

            0 {
                break
            }

            default {
                Status "Opcao invalida." "ERROR"
                retornar
            }
        }

    } while ($browserOption -ne 0)
}

function LimpezaCompleta {

    Status "Iniciando limpeza completa..." "WARNING"

    LimparUserTemp
    LimparWinTemp
    LimparPrefetch
    LimparCacheDNS
    LimparLixeira
    LimparCacheChrome
    LimparCacheEdge
    LimparCacheFirefox
    Write-Host ""
    Status "Limpeza completa finalizada." "OK"

    Retornar
}

do {
  Mostrar-Banner

  Menu-Opcoes "1" "Limpar TEMP do Usuario"
  Menu-Opcoes "2" "Limpar TEMP do Windows"
  Menu-Opcoes "3" "Limpar Prefetch"
  Menu-Opcoes "4" "Limpar cache DNS"
  Menu-Opcoes "5" "Esvaziar Lixeira"
  Menu-Opcoes "6" "Limpar cache dos navegadores" 
  Menu-Opcoes "7" "Limpeza Completa" "Yellow"
  Menu-Opcoes "0" "Sair" "Red"

  Write-Host""
  $opcao = Read-Host "Escolha uma opcao"

  switch ($opcao){
    1 { LimparUserTemp }
    2 { LimparWinTemp }
    3 { LimparPrefetch }
    4 { LimparCacheDNS }
    5 { LimparLixeira }
    6 { LimparMenuNavegadores }
    7 { LimpezaCompleta }
    0 { Write-Host "Encerrando... " -ForegroundColor Yellow}
    default {
      Status "Opcao invalida." "ERROR"
      Retornar
    }
  }
} while ($opcao -ne 0)