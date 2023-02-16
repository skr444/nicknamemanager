@{
    # Script module or binary module file associated with this manifest.
    RootModule = 'NickNameManager.psm1'
    
    # Version number of this module.
    ModuleVersion = '3.1.0'
    
    # ID used to uniquely identify this module
    GUID = 'c56a84bb-ec71-46b7-94b8-c3ea624c8793'

    # Author of this module
    Author = 'skr444'
    
    # Description of the functionality provided by this module
    Description = 'A collection of scripts that help to manage command line path aliases, so called nicknames.'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module
    FunctionsToExport = @(
        'Switch-Directory',
        'Open-Explorer',
        'Add-NickName',
        'Remove-NickName',
        'Import-NickNames',
        'Add-NickNameManagerToProfile'
    )

    # Cmdlets to export from this module
    CmdletsToExport = @()

    # Variables to export from this module
    VariablesToExport = @(
        'NickNameStoreFullpath'
    )

    # Aliases to export from this module
    AliasesToExport = "*"
}
