function Mostrar-Banner {
  Clear-Host
  Write-Host ""
  Write-Host "=========================================" -ForegroundColor Cyan
  Write-Host "         WINDOWS CLEANER TOOL" -ForegroundColor Cyan
  Write-Host "=========================================" -ForegroundColor Cyan
  Write-Host "    Maintenance | Cleanup | Support" -ForegroundColor DarkGray 
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

do {
  Mostrar-Banner

  Menu-Opcoes "1" "Limpar TEMP do Usuario"
  Menu-Opcoes "2" "Limpar TEMP do Windows"
  Menu-Opcoes "3" "Limpar Prefetch"
  Menu-Opcoes "4" "Limpar cache DNS"
  Menu-Opcoes "5" "Esvaziar Lixeira"
  Menu-Opcoes "6" "Limpeza completa" "Yellow"
  Menu-Opcoes "0" "Sair" "Red"

  Write-Host""
  $opcao = Read-Host "Escolha uma opcao"

  switch ($opcao){
    1 { LimparUserTemp }
    0 { Write-Host "Encerrando... " -ForegroundColor Yellow}
    default {
      Status "Opcao invalida." "ERROR"
      Retornar
    }
  }
} while ($opcao -ne 0)