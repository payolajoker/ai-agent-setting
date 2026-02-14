#Requires -Version 7.0

param(
  [string]$Remote = "origin",
  [string]$Branch = "",
  [string]$RepoRoot = ""
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

function Write-Status($Message) {
  Write-Host "[codex-sync] $Message" -ForegroundColor Cyan
}

function Convert-ToTomlString($Value) {
  if ($null -eq $Value) {
    return '""'
  }
  $s = [string]$Value
  $s = $s.Replace('\', '\\').Replace('"', '\"')
  return '"' + $s + '"'
}

function Escape-TomlTableName([string]$Name) {
  $n = $Name.Replace('\', '\\').Replace('"', '\"')
  return '"' + $n + '"'
}

function Convert-ToTomlArray($Values) {
  if ($null -eq $Values -or $Values.Count -eq 0) {
    return "[]"
  }
  $parts = @()
  foreach ($v in $Values) {
    if ($v -is [bool]) {
      $parts += if ($v) { "true" } else { "false" }
    } elseif ($v -is [int] -or $v -is [long] -or $v -is [double] -or $v -is [float]) {
      $parts += [string]$v
    } else {
      $parts += Convert-ToTomlString($v)
    }
  }
  return "[" + ($parts -join ", ") + "]"
}

function Get-McpServerNamesFromToml($TomlText) {
  $names = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
  foreach ($line in ($TomlText -split "`r?`n")) {
    if ($line -match '^\s*\[mcp_servers\."(.+)"\]$') {
      $null = $names.Add($matches[1])
    } elseif ($line -match '^\s*\[mcp_servers\.([A-Za-z0-9_-]+)\]$') {
      $null = $names.Add($matches[1])
    }
  }
  return $names
}

function Convert-JsonMcpServersToToml($JsonPath, $ServerNameToConfig) {
  if (-not (Test-Path $JsonPath)) {
    return
  }

  try {
    $raw = Get-Content $JsonPath -Raw
    if ([string]::IsNullOrWhiteSpace($raw)) { return }
    $obj = $raw | ConvertFrom-Json -ErrorAction Stop
  } catch {
    Write-Status "Failed to parse MCP JSON source: $JsonPath"
    return
  }

  if ($null -eq $obj) {
    return
  }

  if ($obj.PSObject.Properties.Name -contains "mcpServers") {
    $obj = $obj.mcpServers
  }

  foreach ($p in $obj.PSObject.Properties) {
    $name = $p.Name
    $cfg = $p.Value
    if ($null -eq $cfg) { continue }
    if ($cfg.PSObject.Properties.Name -notcontains "command" -and
        $cfg.PSObject.Properties.Name -notcontains "url" -and
        $cfg.PSObject.Properties.Name -notcontains "bearer_token_env_var" -and
        $cfg.PSObject.Properties.Name -notcontains "env" -and
        $cfg.PSObject.Properties.Name -notcontains "headers") {
      continue
    }

    $section = @()
    $section += "[mcp_servers.$(Escape-TomlTableName $name)]"
    $escapedName = Escape-TomlTableName $name

    if ($cfg.PSObject.Properties.Name -contains "command" -and -not [string]::IsNullOrWhiteSpace([string]$cfg.command)) {
      $section += "command = $(Convert-ToTomlString $cfg.command)"
    }

    if ($cfg.PSObject.Properties.Name -contains "url" -and -not [string]::IsNullOrWhiteSpace([string]$cfg.url)) {
      $section += "url = $(Convert-ToTomlString $cfg.url)"
    }

    if ($cfg.PSObject.Properties.Name -contains "bearer_token_env_var" -and -not [string]::IsNullOrWhiteSpace([string]$cfg.bearer_token_env_var)) {
      $section += "bearer_token_env_var = $(Convert-ToTomlString $cfg.bearer_token_env_var)"
    }

    if ($cfg.PSObject.Properties.Name -contains "args") {
      $args = @()
      foreach ($a in @($cfg.args)) {
        if ($null -ne $a) { $args += [string]$a }
      }
      if ($args.Count -gt 0) {
        $section += "args = $(Convert-ToTomlArray $args)"
      }
    }

    if ($cfg.PSObject.Properties.Name -contains "env") {
      $section += ""
      $section += "[mcp_servers.$escapedName.env]"
      foreach ($envProp in @($cfg.env.PSObject.Properties)) {
        if ($null -ne $envProp) {
          $section += "$($envProp.Name) = $(Convert-ToTomlString $envProp.Value)"
        }
      }
    }

    $block = [string]::Join("`n", $section) + "`n"
    $ServerNameToConfig[$name] = $block
  }
}

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
  $scriptDir = Split-Path -Parent $PSCommandPath
  $RepoRoot = Split-Path -Parent $scriptDir
}

if (-not (Test-Path (Join-Path $RepoRoot ".git"))) {
  throw "Not a git repository: $RepoRoot"
}

Push-Location $RepoRoot
try {
  Write-Status "Checking git remote: $Remote"
  if (-not (git remote | Where-Object { $_ -eq $Remote })) {
    Write-Status "Remote '$Remote' is not configured."
    throw "Git remote '$Remote' not found."
  }

  $currentBranch = git rev-parse --abbrev-ref HEAD
  $targetBranch = if ([string]::IsNullOrWhiteSpace($Branch)) { $currentBranch } else { $Branch }

  Write-Status "Sync start: $targetBranch"
  if ($currentBranch -ne $targetBranch) {
    Write-Status "Switching to branch: $targetBranch"
    git checkout $targetBranch
  }

  Write-Status "Pulling latest from $Remote/$targetBranch"
  try {
    git pull --ff-only "$Remote" "$targetBranch"
  } catch {
    Write-Status "Pull skipped (no upstream or non-fast-forward): $($_.Exception.Message)"
  }

  $sourceHome = Join-Path $HOME ".codex"
  $destCodex = Join-Path $RepoRoot "codex"
  if (-not (Test-Path $sourceHome)) {
    throw "Source Codex home not found: $sourceHome"
  }

  Write-Status "Copying GLOBAL_CODEX.md"
  Copy-Item -Path (Join-Path $sourceHome "GLOBAL_CODEX.md") -Destination (Join-Path $destCodex "GLOBAL_CODEX.md") -Force

  Write-Status "Copying config.toml"
  Copy-Item -Path (Join-Path $sourceHome "config.toml") -Destination (Join-Path $destCodex "config.toml") -Force

  $codexConfigPath = Join-Path $destCodex "config.toml"
  $tomlText = Get-Content $codexConfigPath -Raw -ErrorAction Stop
  $existingMcpNames = Get-McpServerNamesFromToml $tomlText
  $additionalMcpSections = [hashtable]::new([System.StringComparer]::OrdinalIgnoreCase)

  # Merge MCP sources from Claude-format files (if present).
  Convert-JsonMcpServersToToml (Join-Path $HOME ".claude.json") $additionalMcpSections
  Convert-JsonMcpServersToToml (Join-Path $HOME ".claude\\mcp-servers.json") $additionalMcpSections

  if ($additionalMcpSections.Count -gt 0) {
    $toAppend = @()
    foreach ($kv in $additionalMcpSections.GetEnumerator() | Sort-Object Name) {
      if (-not $existingMcpNames.Contains($kv.Key)) {
        $toAppend += "# Added from Claude MCP source"
        $toAppend += $kv.Value.TrimEnd("`n")
        $toAppend += ""
      }
    }

    if ($toAppend.Count -gt 0) {
      Write-Status "Importing MCP sections from Claude JSON files"
      $newText = $tomlText
      if (-not ($newText -match "`r?`n$")) {
        $newText += "`n"
      }
      $newText += "`n" + ($toAppend -join "`n")
      Set-Content -Path $codexConfigPath -Value $newText
    }
  }

  $sourceSkills = Join-Path $sourceHome "skills"
  $destSkills = Join-Path $destCodex "skills"
  if (Test-Path $sourceSkills) {
    Write-Status "Syncing skills/"
    if (Test-Path $destSkills) {
      Remove-Item -Recurse -Force $destSkills
    }
    Copy-Item -Path $sourceSkills -Destination $destSkills -Recurse -Force
  } else {
    Write-Status "No local skills directory found at $sourceSkills"
  }

  $status = git status --short -- codex
  if (-not $status) {
    Write-Status "No changes to sync."
    return
  }

  Write-Status "Changes detected. Committing..."
  git add codex
  $message = "chore: sync codex global settings"
  git commit -m $message
  Write-Status "Pushing to $Remote/$targetBranch"
  git push "$Remote" "$targetBranch"
  Write-Status "Sync completed."
} finally {
  Pop-Location
}
