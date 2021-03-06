[CmdletBinding(PositionalBinding=$false)]
[OutputType([void])]
param()

Trace-VstsEnteringInvocation $MyInvocation
try {
    $debugOnly = Get-VstsInput -Name "debugOnly" -AsBool

    if ($debugOnly) {
        $debug = Get-VstsTaskVariable -Name "system.debug" -AsBool
    }

    if (!$debugOnly -or ($debugOnly -and $debug)) {
        Import-Module "$PSScriptRoot/ps_modules/Tools" -NoClobber

        Set-HostBufferSize -Width 300

        Get-UnsafeData "Variables" { Get-ChildItem "Env:/" } `
        | Sort-Object "Key" `
        | Format-Table @(
            "Key" | New-Property -Name "Variable"
            "Value"
        ) -AutoSize -Wrap
    }
} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
