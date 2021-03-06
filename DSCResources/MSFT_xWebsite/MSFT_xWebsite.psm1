#requires -Version 4.0 -Modules CimCmdlets

# Load the Helper Module
Import-Module -Name "$PSScriptRoot\..\Helper.psm1" -Verbose:$false

# Localized messages
data LocalizedData
{
    # culture="en-US"
    ConvertFrom-StringData -StringData @'
ErrorWebsiteNotFound = The requested website "{0}" cannot be found on the target machine.
ErrorWebsiteDiscoveryFailure = Failure to get the requested website "{0}" information from the target machine.
ErrorWebsiteCreationFailure = Failure to successfully create the website "{0}". Error: "{1}".
ErrorWebsiteRemovalFailure = Failure to successfully remove the website "{0}". Error: "{1}".
ErrorWebsiteBindingUpdateFailure = Failure to successfully update the bindings for website "{0}". Error: "{1}".
ErrorWebsiteBindingInputInvalidation = Desired website bindings are not valid for website "{0}".
ErrorWebsiteCompareFailure = Failure to successfully compare properties for website "{0}". Error: "{1}".
ErrorWebBindingCertificate = Failure to add certificate to web binding. Please make sure that the certificate thumbprint "{0}" is valid. Error: "{1}".
ErrorWebsiteStateFailure = Failure to successfully set the state of the website "{0}". Error: "{1}".
ErrorWebsiteBindingConflictOnStart = Website "{0}" could not be started due to binding conflict. Ensure that the binding information for this website does not conflict with any existing website's bindings before trying to start it.
ErrorWebBindingInvalidIPAddress = Failure to validate the IPAddress property value "{0}". Error: "{1}".
ErrorWebBindingInvalidPort = Failure to validate the Port property value "{0}". The port number must be a positive integer between 1 and 65535.
ErrorWebBindingMissingBindingInformation = The BindingInformation property is required for bindings of type "{0}".
ErrorWebBindingMissingCertificateThumbprint = The CertificateThumbprint property is required for bindings of type "{0}".
ErrorWebBindingMissingSniHostName = The HostName property is required for use with Server Name Indication.
ErrorWebsitePreloadFailure = Failure to set Preload on Website "{0}". Error: "{1}".
ErrorWebsiteAutoStartFailure = Failure to set AutoStart on Website "{0}". Error: "{1}".
ErrorWebsiteAutoStartProviderFailure = Failure to set AutoStartProvider on Website "{0}". Error: "{1}".
ErrorWebsiteTestAutoStartProviderFailure = Desired AutoStartProvider is not valid due to a conflicting Global Property. Ensure that the serviceAutoStartProvider is a unique key."
VerboseSetTargetUpdatedPhysicalPath = Physical Path for website "{0}" has been updated to "{1}".
VerboseSetTargetUpdatedApplicationPool = Application Pool for website "{0}" has been updated to "{1}".
VerboseSetTargetUpdatedBindingInfo = Bindings for website "{0}" have been updated.
VerboseSetTargetUpdatedEnabledProtocols = Enabled Protocols for website "{0}" have been updated to "{1}".
VerboseSetTargetUpdatedState = State for website "{0}" has been updated to "{1}".
VerboseSetTargetWebsiteCreated = Successfully created website "{0}".
VerboseSetTargetWebsiteStarted = Successfully started website "{0}".
VerboseSetTargetWebsiteRemoved = Successfully removed website "{0}".
VerboseSetTargetWebsitePreloadEnabled = Successfully enabled Preload on website "{0}"
VerboseSetTargetWebsitePreloadRemoved = Successfully disabled Preload on website "{0}"
VerboseSetTargetWebsiteAutoStartEnabled = Successfully enabled AutoStart on website "{0}"
VerboseSetTargetWebsiteAutoStartRemoved = Successfully disabled AutoStart on website "{0}"
VerboseSetTargetWebsiteAutoStartProviderAdded = Successfully added AutoStartProvider on website "{0}"
VerboseSetTargetWebsiteAutoStartProviderRemoved = Successfully removed AutoStartProvider on website "{0}"
VerboseSetTargetUpdateLogPath = LogPath does not match and will be updated on Website "{0}".
VerboseSetTargetUpdateLogFlags = LogFlags do not match and will be updated on Website "{0}".
VerboseSetTargetUpdateLogPeriod = LogPeriod does not match and will be updated on Website "{0}".
VerboseSetTargetUpdateLogTruncateSize = TruncateSize does not match and will be updated on Website "{0}".
VerboseSetTargetUpdateLoglocalTimeRollover = LoglocalTimeRollover does not match and will be updated on Website "{0}".
VerboseSetTargetUpdateLogFormat = LogFormat is not in the desired state and will be updated on Website "{0}"
VerboseTestTargetFalseEnsure = The Ensure state for website "{0}" does not match the desired state.
VerboseTestTargetFalsePhysicalPath = Physical Path of website "{0}" does not match the desired state.
VerboseTestTargetFalseState = The state of website "{0}" does not match the desired state.
VerboseTestTargetFalseApplicationPool = Application Pool for website "{0}" does not match the desired state.
VerboseTestTargetFalseBindingInfo = Bindings for website "{0}" do not match the desired state.
VerboseTestTargetFalseEnabledProtocols = Enabled Protocols for website "{0}" do not match the desired state.
VerboseTestTargetFalseDefaultPage = Default Page for website "{0}" does not match the desired state.
VerboseTestTargetTrueResult = The target resource is already in the desired state. No action is required.
VerboseTestTargetFalseResult = The target resource is not in the desired state.
VerboseTestTargetFalsePreload = Preload for website "{0}" do not match the desired state.
VerboseTestTargetFalseAutoStart = AutoStart for website "{0}" do not match the desired state.
VerboseTestTargetFalseAutoStartProvider = AutoStartProvider for website "{0}" does not match the desired state.
VerboseTestTargetFalseSSLFlags = SSLFlags are not in the desired state.
VerboseTestTargetFalseAuthenticationInfo = AuthenticationInfo is not in the desired state.
VerboseTestTargetFalseLogPath = LogPath does match desired state on Website "{0}".
VerboseTestTargetFalseLogFlags = LogFlags does not match desired state on Website "{0}".
VerboseTestTargetFalseLogPeriod = LogPeriod does not match desired state on Website "{0}".
VerboseTestTargetFalseLogTruncateSize = LogTruncateSize does not match desired state on Website "{0}".
VerboseTestTargetFalseLoglocalTimeRollover = LoglocalTimeRollover does not match desired state on Website "{0}".
VerboseTestTargetFalseLogFormat = LogFormat does not match desired state on Website "{0}".
VerboseConvertToWebBindingIgnoreBindingInformation = BindingInformation is ignored for bindings of type "{0}" in case at least one of the following properties is specified: IPAddress, Port, HostName.
VerboseConvertToWebBindingDefaultPort = Port is not specified. The default "{0}" port "{1}" will be used.
VerboseConvertToWebBindingDefaultCertificateStoreName = CertificateStoreName is not specified. The default value "{0}" will be used.
VerboseTestBindingInfoSameIPAddressPortHostName = BindingInfo contains multiple items with the same IPAddress, Port, and HostName combination.
VerboseTestBindingInfoSamePortDifferentProtocol = BindingInfo contains items that share the same Port but have different Protocols.
VerboseTestBindingInfoSameProtocolBindingInformation = BindingInfo contains multiple items with the same Protocol and BindingInformation combination.
VerboseTestBindingInfoInvalidCatch = Unable to validate BindingInfo: "{0}".
VerboseUpdateDefaultPageUpdated = Default page for website "{0}" has been updated to "{1}".
WarningLogPeriod = LogTruncateSize has is an input as will overwrite this desired state on Website "{0}".
WarningIncorrectLogFormat = LogFormat is not W3C, as a result LogFlags will not be used on Website "{0}".
'@
}

function Get-TargetResource
{
    <#
    .SYNOPSYS
        The Get-TargetResource cmdlet is used to fetch the status of role or Website on the target machine.
        It gives the Website info of the requested role/feature on the target machine.
    #>
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name
    )

    Assert-Module

    $Website = Get-Website | Where-Object -FilterScript {$_.Name -eq $Name}

    if ($Website.Count -eq 0) # No Website exists with this name
    {
        $EnsureResult = 'Absent'
    }
    elseif ($Website.Count -eq 1) # A single Website exists with this name
    {
        $EnsureResult = 'Present'

        $CimBindings = @(ConvertTo-CimBinding -InputObject $Website.bindings.Collection)

        $AllDefaultPages = @(
            Get-WebConfiguration -Filter '//defaultDocument/files/*' -PSPath "IIS:\Sites\$Name" |
            ForEach-Object -Process {Write-Output -InputObject $_.value}
        )
        $CimAuthentication = Get-AuthenticationInfo -Site $Name
        $WebSiteAutoStartProviders = (Get-WebConfiguration -filter /system.applicationHost/serviceAutoStartProviders).Collection
        $WebConfiguration = $WebSiteAutoStartProviders |  Where-Object -Property Name -eq -Value $ServiceAutoStartProvider | Select-Object Name,Type
    }
    else # Multiple websites with the same name exist. This is not supported and is an error
    {
        $ErrorMessage = $LocalizedData.ErrorWebsiteDiscoveryFailure -f $Name
        New-TerminatingError -ErrorId 'WebsiteDiscoveryFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
    }

    # Add all website properties to the hash table
    return @{
        Ensure                   = $EnsureResult
        Name                     = $Name
        PhysicalPath             = $Website.PhysicalPath
        State                    = $Website.State
        ApplicationPool          = $Website.ApplicationPool
        BindingInfo              = $CimBindings
        DefaultPage              = $AllDefaultPages
        EnabledProtocols         = $Website.EnabledProtocols
        AuthenticationInfo       = $CimAuthentication
        PreloadEnabled           = $Website.applicationDefaults.preloadEnabled
        ServiceAutoStartProvider = $Website.applicationDefaults.serviceAutoStartProvider
        ServiceAutoStartEnabled  = $Website.applicationDefaults.serviceAutoStartEnabled
        ApplicationType          = $WebConfiguration.Type
        LogPath                  = $Website.logfile.directory
        LogFlags                 = [Array]$Website.logfile.LogExtFileFlags
        LogPeriod                = $Website.logfile.period
        LogtruncateSize          = $Website.logfile.truncateSize
        LoglocalTimeRollover     = $Website.logfile.localTimeRollover
        LogFormat                = $Website.logfile.logFormat
    }
}

function Set-TargetResource
{
    <#
    .SYNOPSYS
        The Set-TargetResource cmdlet is used to create, delete or configure a website on the target machine.
    #>
    [CmdletBinding()]
    param
    (
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [ValidateNotNullOrEmpty()]
        [String]
        $PhysicalPath,

        [ValidateSet('Started', 'Stopped')]
        [String]
        $State = 'Started',

        [ValidateLength(1, 64)] # The application pool name must contain between 1 and 64 characters
        [String]
        $ApplicationPool,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo,

        [String[]]
        $DefaultPage,

        [String]
        $EnabledProtocols,

        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationInfo,

        [Boolean]
        $PreloadEnabled,

        [Boolean]
        $ServiceAutoStartEnabled,

        [String]
        $ServiceAutoStartProvider,

        [String]
        $ApplicationType,

        [String]
        $LogPath,

        [ValidateSet('Date','Time','ClientIP','UserName','SiteName','ComputerName','ServerIP','Method','UriStem','UriQuery','HttpStatus','Win32Status','BytesSent','BytesRecv','TimeTaken','ServerPort','UserAgent','Cookie','Referer','ProtocolVersion','Host','HttpSubStatus')]
        [String[]]
        $LogFlags,

        [ValidateSet('Hourly','Daily','Weekly','Monthly','MaxSize')]
        [String]
        $LogPeriod,

        [ValidateRange('1048576','4294967295')]
        [String]
        $LogTruncateSize,

        [Boolean]
        $LoglocalTimeRollover,

        [ValidateSet('IIS','W3C','NCSA')]
        [String]
        $LogFormat
    )

    Assert-Module

    $Website = Get-Website | Where-Object -FilterScript {$_.Name -eq $Name}

    if ($Ensure -eq 'Present')
    {
        if ($null -ne $Website)
        {
            # Update Physical Path if required
            if ([string]::IsNullOrEmpty($PhysicalPath) -eq $false -and $Website.PhysicalPath -ne $PhysicalPath)
            {
                Set-ItemProperty -Path "IIS:\Sites\$Name" -Name physicalPath -Value $PhysicalPath -ErrorAction Stop
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedPhysicalPath -f $Name, $PhysicalPath)
            }

            # Update Application Pool if required
            if ($PSBoundParameters.ContainsKey('ApplicationPool') -and $Website.ApplicationPool -ne $ApplicationPool)
            {
                Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationPool -Value $ApplicationPool -ErrorAction Stop
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedApplicationPool -f $Name, $ApplicationPool)
            }

            # Update Bindings if required
            if ($PSBoundParameters.ContainsKey('BindingInfo') -and $null -ne $BindingInfo)
            {
                if (-not (Test-WebsiteBinding -Name $Name -BindingInfo $BindingInfo))
                {
                    Update-WebsiteBinding -Name $Name -BindingInfo $BindingInfo
                    Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedBindingInfo -f $Name)
                }
            }

            # Update Enabled Protocols if required
            if ($PSBoundParameters.ContainsKey('EnabledProtocols') -and $Website.EnabledProtocols -ne $EnabledProtocols)
            {
                Set-ItemProperty -Path "IIS:\Sites\$Name" -Name enabledProtocols -Value $EnabledProtocols -ErrorAction Stop
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedEnabledProtocols -f $Name, $EnabledProtocols)
            }

            # Update Default Pages if required
            if ($PSBoundParameters.ContainsKey('DefaultPage') -and $null -ne $DefaultPage)
            {
                Update-DefaultPage -Name $Name -DefaultPage $DefaultPage
            }

            # Update State if required
            if ($PSBoundParameters.ContainsKey('State') -and $Website.State -ne $State)
            {
                if ($State -eq 'Started')
                {
                    # Ensure that there are no other running websites with binding information that will conflict with this website before starting
                    if (-not (Confirm-UniqueBinding -Name $Name -ExcludeStopped))
                    {
                        # Return error and do not start the website
                        $ErrorMessage = $LocalizedData.ErrorWebsiteBindingConflictOnStart -f $Name
                        New-TerminatingError -ErrorId 'WebsiteBindingConflictOnStart' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
                    }

                    try
                    {
                        Start-Website -Name $Name -ErrorAction Stop
                    }
                    catch
                    {
                        $ErrorMessage = $LocalizedData.ErrorWebsiteStateFailure -f $Name, $_.Exception.Message
                        New-TerminatingError -ErrorId 'WebsiteStateFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidOperation'
                    }
                }
                else
                {
                    try
                    {
                        Stop-Website -Name $Name -ErrorAction Stop
                    }
                    catch
                    {
                        $ErrorMessage = $LocalizedData.ErrorWebsiteStateFailure -f $Name, $_.Exception.Message
                        New-TerminatingError -ErrorId 'WebsiteStateFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidOperation'
                    }
                }

                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedState -f $Name, $State)
            }

            # Set Authentication; if not defined then pass in DefaultAuthenticationInfo
            if ($PSBoundParameters.ContainsKey('AuthenticationInfo') -and (-not (Test-AuthenticationInfo -Site $Name -AuthenticationInfo $AuthenticationInfo)))
            {
                Set-AuthenticationInfo -Site $Name -AuthenticationInfo $AuthenticationInfo -ErrorAction Stop
            }

            # Update Preload if required
            if ($PSBoundParameters.ContainsKey('preloadEnabled') -and $Website.applicationDefaults.preloadEnabled -ne $PreloadEnabled)
            {
               Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationDefaults.preloadEnabled -Value $PreloadEnabled -ErrorAction Stop
            }

            # Update AutoStart if required
            if ($PSBoundParameters.ContainsKey('ServiceAutoStartEnabled') -and $Website.applicationDefaults.ServiceAutoStartEnabled -ne $ServiceAutoStartEnabled)
            {
                Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationDefaults.serviceAutoStartEnabled -Value $ServiceAutoStartEnabled -ErrorAction Stop
            }

            # Update AutoStartProviders if required
            if ($PSBoundParameters.ContainsKey('ServiceAutoStartProvider') -and $Website.applicationDefaults.ServiceAutoStartProvider -ne $ServiceAutoStartProvider)
            {
                if (-not (Confirm-UniqueServiceAutoStartProviders -ServiceAutoStartProvider $ServiceAutoStartProvider -ApplicationType $ApplicationType))
                {
                    Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationDefaults.serviceAutoStartProvider -Value $ServiceAutoStartEnabled -ErrorAction Stop
                    Add-WebConfiguration -filter /system.applicationHost/serviceAutoStartProviders -Value @{name=$ServiceAutoStartProvider; type=$ApplicationType} -ErrorAction Stop
                }
            }

            # Update LogFormat if Needed
            if ($PSBoundParameters.ContainsKey('LogFormat') -and `
                ($LogFormat -ne $Website.logfile.LogFormat))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogFormat -f $Name)
                Set-WebConfigurationProperty '/system.applicationHost/sites/siteDefaults/logfile' `
                    -name logFormat `
                    -value $LogFormat
            }

            # Update LogFlags if required
            if ($PSBoundParameters.ContainsKey('LogFlags') -and `
                (-not (Compare-LogFlags -Name $Name -LogFlags $LogFlags)))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogFlags -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.logFormat -Value 'W3C'
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.LogExtFileFlags -Value ($LogFlags -join ',')
            }

            # Update LogPath if required
            if ($PSBoundParameters.ContainsKey('LogPath') -and ($LogPath -ne $Website.logfile.LogPath))
            {

                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogPath -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.directory -value $LogPath
            }

            # Update LogPeriod if needed
            if ($PSBoundParameters.ContainsKey('LogPeriod') -and `
                ($LogPeriod -ne $Website.logfile.LogPeriod))
            {
                if ($PSBoundParameters.ContainsKey('LogTruncateSize'))
                    {
                        Write-Verbose -Message ($LocalizedData.WarningLogPeriod -f $Name)
                    }

                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogPeriod)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.period -Value $LogPeriod
            }

            # Update LogTruncateSize if needed
            if ($PSBoundParameters.ContainsKey('LogTruncateSize') -and `
                ($LogTruncateSize -ne $Website.logfile.LogTruncateSize))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogTruncateSize -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.truncateSize -Value $LogTruncateSize
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.period -Value 'MaxSize'
            }

            # Update LoglocalTimeRollover if neeed
            if ($PSBoundParameters.ContainsKey('LoglocalTimeRollover') -and `
                ($LoglocalTimeRollover -ne `
                 ([System.Convert]::ToBoolean($Website.logfile.LoglocalTimeRollover))))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLoglocalTimeRollover -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.localTimeRollover -Value $LoglocalTimeRollover
            }

        }
        else # Create website if it does not exist
        {
            if ([string]::IsNullOrEmpty($PhysicalPath)) {
                throw 'The PhysicalPath Parameter must be provided for a website to be created'
            }

            try
            {
                $PSBoundParameters.GetEnumerator() |
                Where-Object -FilterScript {
                    $_.Key -in (Get-Command -Name New-Website -Module WebAdministration).Parameters.Keys
                } |
                ForEach-Object -Begin {
                    $NewWebsiteSplat = @{}
                } -Process {
                    $NewWebsiteSplat.Add($_.Key, $_.Value)
                }

                # If there are no other websites, specify the Id Parameter for the new website.
                # Otherwise an error can occur on systems running Windows Server 2008 R2.
                if (-not (Get-Website))
                {
                    $NewWebsiteSplat.Add('Id', 1)
                }

                $Website = New-Website @NewWebsiteSplat -ErrorAction Stop
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetWebsiteCreated -f $Name)
            }
            catch
            {
                $ErrorMessage = $LocalizedData.ErrorWebsiteCreationFailure -f $Name, $_.Exception.Message
                New-TerminatingError -ErrorId 'WebsiteCreationFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidOperation'
            }

            Stop-Website -Name $Website.Name -ErrorAction Stop

            # Clear default bindings if new bindings defined and are different
            if ($PSBoundParameters.ContainsKey('BindingInfo') -and $null -ne $BindingInfo)
            {
                if (-not (Test-WebsiteBinding -Name $Name -BindingInfo $BindingInfo))
                {
                    Update-WebsiteBinding -Name $Name -BindingInfo $BindingInfo
                    Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedBindingInfo -f $Name)
                }
            }

            # Update Enabled Protocols if required
            if ($PSBoundParameters.ContainsKey('EnabledProtocols') -and $Website.EnabledProtocols -ne $EnabledProtocols)
            {
                Set-ItemProperty -Path "IIS:\Sites\$Name" -Name enabledProtocols -Value $EnabledProtocols -ErrorAction Stop
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdatedEnabledProtocols -f $Name, $EnabledProtocols)
            }

            # Update Default Pages if required
            if ($PSBoundParameters.ContainsKey('DefaultPage') -and $null -ne $DefaultPage)
            {
                Update-DefaultPage -Name $Name -DefaultPage $DefaultPage
            }

            # Start website if required
            if ($State -eq 'Started')
            {
                # Ensure that there are no other running websites with binding information that will conflict with this website before starting
                if (-not (Confirm-UniqueBinding -Name $Name -ExcludeStopped))
                {
                    # Return error and do not start the website
                    $ErrorMessage = $LocalizedData.ErrorWebsiteBindingConflictOnStart -f $Name
                    New-TerminatingError -ErrorId 'WebsiteBindingConflictOnStart' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
                }

                try
                {
                    Start-Website -Name $Name -ErrorAction Stop
                    Write-Verbose -Message ($LocalizedData.VerboseSetTargetWebsiteStarted -f $Name)
                }
                catch
                {
                    $ErrorMessage = $LocalizedData.ErrorWebsiteStateFailure -f $Name, $_.Exception.Message
                    New-TerminatingError -ErrorId 'WebsiteStateFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidOperation'
                }
            }

            # Set Authentication; if not defined then pass in DefaultAuthenticationInfo
            if ($PSBoundParameters.ContainsKey('AuthenticationInfo') -and (-not (Test-AuthenticationInfo -Site $Name -AuthenticationInfo $AuthenticationInfo)))
            {
                Set-AuthenticationInfo -Site $Name -AuthenticationInfo $AuthenticationInfo -ErrorAction Stop
            }

            # Update Preload if required
            if ($PSBoundParameters.ContainsKey('preloadEnabled'))
            {
               Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationDefaults.preloadEnabled -Value $PreloadEnabled -ErrorAction Stop
            }

            # Update AutoStart if required
            if ($PSBoundParameters.ContainsKey('ServiceAutoStartEnabled'))
            {
                Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationDefaults.serviceAutoStartEnabled -Value $ServiceAutoStartEnabled -ErrorAction Stop
            }

            # Update AutoStartProviders if required
            if ($PSBoundParameters.ContainsKey('ServiceAutoStartProvider'))
            {
                if (-not (Confirm-UniqueServiceAutoStartProviders -ServiceAutoStartProvider $ServiceAutoStartProvider -ApplicationType $ApplicationType))
                {
                    Set-ItemProperty -Path "IIS:\Sites\$Name" -Name applicationDefaults.serviceAutoStartProvider -Value $ServiceAutoStartEnabled -ErrorAction Stop
                    Add-WebConfiguration -filter /system.applicationHost/serviceAutoStartProviders -Value @{name=$ServiceAutoStartProvider; type=$ApplicationType} -ErrorAction Stop
                }
            }

            # Update LogFormat if Needed
            if ($PSBoundParameters.ContainsKey('LogFormat') -and `
                ($LogFormat -ne $Website.logfile.LogFormat))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogFormat -f $Name)
                Set-WebConfigurationProperty '/system.applicationHost/sites/siteDefaults/logfile' `
                    -name logFormat `
                    -value $LogFormat
            }

            # Update LogFlags if required
            if ($PSBoundParameters.ContainsKey('LogFlags') -and `
                (-not (Compare-LogFlags -Name $Name -LogFlags $LogFlags)))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogFlags -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.logFormat -Value 'W3C'
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.LogExtFileFlags -Value ($LogFlags -join ',')
            }

            # Update LogPath if required
            if ($PSBoundParameters.ContainsKey('LogPath') -and ($LogPath -ne $Website.logfile.LogPath))
            {

                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogPath -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.directory -value $LogPath
            }

            # Update LogPeriod if needed
            if ($PSBoundParameters.ContainsKey('LogPeriod') -and `
                ($LogPeriod -ne $Website.logfile.LogPeriod))
            {
                if ($PSBoundParameters.ContainsKey('LogTruncateSize'))
                    {
                        Write-Verbose -Message ($LocalizedData.WarningLogPeriod -f $Name)
                    }

                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogPeriod)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.period -Value $LogPeriod
            }

            # Update LogTruncateSize if needed
            if ($PSBoundParameters.ContainsKey('LogTruncateSize') -and `
                ($LogTruncateSize -ne $Website.logfile.LogTruncateSize))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLogTruncateSize -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.truncateSize -Value $LogTruncateSize
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.period -Value 'MaxSize'
            }

            # Update LoglocalTimeRollover if neeed
            if ($PSBoundParameters.ContainsKey('LoglocalTimeRollover') -and `
                ($LoglocalTimeRollover -ne `
                 ([System.Convert]::ToBoolean($Website.logfile.LoglocalTimeRollover))))
            {
                Write-Verbose -Message ($LocalizedData.VerboseSetTargetUpdateLoglocalTimeRollover -f $Name)
                Set-ItemProperty -Path "IIS:\Sites\$Name" `
                    -Name LogFile.localTimeRollover -Value $LoglocalTimeRollover
            }
        }
    }
    else # Remove website
    {
        try
        {
            Remove-Website -Name $Name -ErrorAction Stop
            Write-Verbose -Message ($LocalizedData.VerboseSetTargetWebsiteRemoved -f $Name)
        }
        catch
        {
            $ErrorMessage = $LocalizedData.ErrorWebsiteRemovalFailure -f $Name, $_.Exception.Message
            New-TerminatingError -ErrorId 'WebsiteRemovalFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidOperation'
        }
    }
}

function Test-TargetResource
{
    <#
    .SYNOPSYS
        The Test-TargetResource cmdlet is used to validate if the role or feature is in a state as expected in the instance document.
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [ValidateSet('Present', 'Absent')]
        [String]
        $Ensure = 'Present',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [String]
        $PhysicalPath,

        [ValidateSet('Started', 'Stopped')]
        [String]
        $State = 'Started',

        [ValidateLength(1, 64)] # The application pool name must contain between 1 and 64 characters
        [String]
        $ApplicationPool,

        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo,

        [String[]]
        $DefaultPage,

        [String]
        $EnabledProtocols,

        [Microsoft.Management.Infrastructure.CimInstance]
        $AuthenticationInfo,

        [Boolean]
        $PreloadEnabled,

        [Boolean]
        $ServiceAutoStartEnabled,

        [String]
        $ServiceAutoStartProvider,

        [String]
        $ApplicationType,

        [String]
        $LogPath,

        [ValidateSet('Date','Time','ClientIP','UserName','SiteName','ComputerName','ServerIP','Method','UriStem','UriQuery','HttpStatus','Win32Status','BytesSent','BytesRecv','TimeTaken','ServerPort','UserAgent','Cookie','Referer','ProtocolVersion','Host','HttpSubStatus')]
        [String[]]
        $LogFlags,

        [ValidateSet('Hourly','Daily','Weekly','Monthly','MaxSize')]
        [String]
        $LogPeriod,

        [ValidateRange('1048576','4294967295')]
        [String]
        $LogTruncateSize,

        [Boolean]
        $LoglocalTimeRollover,

        [ValidateSet('IIS','W3C','NCSA')]
        [String]
        $LogFormat
    )

    Assert-Module

    $InDesiredState = $true

    $Website = Get-Website | Where-Object -FilterScript {$_.Name -eq $Name}

    # Check Ensure
    if (($Ensure -eq 'Present' -and $null -eq $Website) -or ($Ensure -eq 'Absent' -and $null -ne $Website))
    {
        $InDesiredState = $false
        Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseEnsure -f $Name)
    }

    # Only check properties if website exists
    if ($Ensure -eq 'Present' -and $null -ne $Website)
    {
        # Check Physical Path property
        if ([string]::IsNullOrEmpty($PhysicalPath) -eq $false -and $Website.PhysicalPath -ne $PhysicalPath)
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalsePhysicalPath -f $Name)
        }

        # Check State
        if ($PSBoundParameters.ContainsKey('State') -and $Website.State -ne $State)
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseState -f $Name)
        }

        # Check Application Pool property
        if ($PSBoundParameters.ContainsKey('ApplicationPool') -and $Website.ApplicationPool -ne $ApplicationPool)
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseApplicationPool -f $Name)
        }

        # Check Binding properties
        if ($PSBoundParameters.ContainsKey('BindingInfo') -and $null -ne $BindingInfo)
        {
            if (-not (Test-WebsiteBinding -Name $Name -BindingInfo $BindingInfo))
            {
                $InDesiredState = $false
                Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseBindingInfo -f $Name)
            }
        }

        # Check Enabled Protocols
        if ($PSBoundParameters.ContainsKey('EnabledProtocols') -and $Website.EnabledProtocols -ne $EnabledProtocols)
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseEnabledProtocols -f $Name)
        }

        # Check Default Pages
        if ($PSBoundParameters.ContainsKey('DefaultPage') -and $null -ne $DefaultPage)
        {
            $AllDefaultPages = @(
                Get-WebConfiguration -Filter '//defaultDocument/files/*' -PSPath "IIS:\Sites\$Name" |
                ForEach-Object -Process {Write-Output -InputObject $_.value}
            )

            foreach ($Page in $DefaultPage)
            {
                if ($AllDefaultPages -inotcontains $Page)
                {
                    $InDesiredState = $false
                    Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseDefaultPage -f $Name)
                }
            }
        }

        # Check AuthenticationInfo
        if ($PSBoundParameters.ContainsKey('AuthenticationInfo') -and (-not (Test-AuthenticationInfo -Site $Name -AuthenticationInfo $AuthenticationInfo)))
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseAuthenticationInfo)
        }

        # Check Preload
        if($PSBoundParameters.ContainsKey('preloadEnabled') -and $Website.applicationDefaults.preloadEnabled -ne $PreloadEnabled)
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalsePreload -f $Name)
        }

        # Check AutoStartEnabled

        if($PSBoundParameters.ContainsKey('serviceAutoStartEnabled') -and $Website.applicationDefaults.serviceAutoStartEnabled -ne $ServiceAutoStartEnabled)
        {
            $InDesiredState = $false
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseAutoStart -f $Name)
        }

        # Check AutoStartProviders
        if($PSBoundParameters.ContainsKey('serviceAutoStartProvider') -and $Website.applicationDefaults.serviceAutoStartProvider -ne $ServiceAutoStartProvider)
        {
            if (-not (Confirm-UniqueServiceAutoStartProviders -serviceAutoStartProvider $ServiceAutoStartProvider -ApplicationType $ApplicationType))
            {
                $InDesiredState = $false
                Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseAutoStartProvider)
            }
        }

        # Check LogFormat
        if ($PSBoundParameters.ContainsKey('LogFormat'))
        {
            # Warn if LogFlags are passed in and Current LogFormat is not W3C
            if ($PSBoundParameters.ContainsKey('LogFlags') -and $LogFormat -ne 'W3C')
            {
                Write-Verbose -Message ($LocalizedData.WarningIncorrectLogFormat -f $Name)
            }
            # Warn if LogFlags are passed in and Desired LogFormat is not W3C
            if($PSBoundParameters.ContainsKey('LogFlags') -and $Website.logfile.LogFormat -ne 'W3C')
            {
                Write-Verbose -Message ($LocalizedData.WarningIncorrectLogFormat -f $Name)
            }
            # Check Log Format
            if ($LogFormat -ne $Website.logfile.LogFormat)
            {
                Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseLogFormat -f $Name)
                return $false
            }
        }

        # Check LogFlags
        if ($PSBoundParameters.ContainsKey('LogFlags') -and `
            (-not (Compare-LogFlags -Name $Name -LogFlags $LogFlags)))
        {
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseLogFlags)
            return $false
        }

        # Check LogPath
        if ($PSBoundParameters.ContainsKey('LogPath') -and `
            ($LogPath -ne $Website.logfile.LogPath))
        {
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseLogPath -f $Name)
            return $false
        }

        # Check LogPeriod
        if ($PSBoundParameters.ContainsKey('LogPeriod') -and `
            ($LogPeriod -ne $Website.logfile.LogPeriod))
        {
            if ($PSBoundParameters.ContainsKey('LogTruncateSize'))
            {
                Write-Verbose -Message ($LocalizedData.WarningLogPeriod -f $Name)
            }

            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseLogPeriod -f $Name)
            return $false
        }

        # Check LogTruncateSize
        if ($PSBoundParameters.ContainsKey('LogTruncateSize') -and `
            ($LogTruncateSize -ne $Website.logfile.LogTruncateSize))
        {
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseLogTruncateSize -f $Name)
            return $false
        }

        # Check LoglocalTimeRollover
        if ($PSBoundParameters.ContainsKey('LoglocalTimeRollover') -and `
            ($LoglocalTimeRollover -ne ([System.Convert]::ToBoolean($Website.logfile.LoglocalTimeRollover))))
        {
            Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseLoglocalTimeRollover -f $Name)
            return $false
        }
    }

    if ($InDesiredState -eq $true)
    {
        Write-Verbose -Message ($LocalizedData.VerboseTestTargetTrueResult)
    }
    else
    {
        Write-Verbose -Message ($LocalizedData.VerboseTestTargetFalseResult)
    }

    return $InDesiredState
}

#region Helper Functions

Function Compare-LogFlags
{
    <#
    .SYNOPSIS
        Helper function used to validate that the logflags status.
        Returns False if the loglfags do not match and true if they do
    .PARAMETER LogFlags
        Specifies flags to check
    .PARAMETER Name
        Specifies website to check the flags on
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String[]]
        [ValidateSet('Date','Time','ClientIP','UserName','SiteName','ComputerName','ServerIP','Method','UriStem','UriQuery','HttpStatus','Win32Status','BytesSent','BytesRecv','TimeTaken','ServerPort','UserAgent','Cookie','Referer','ProtocolVersion','Host','HttpSubStatus')]
        $LogFlags,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name

    )

    $CurrentLogFlags = (Get-Website -Name $Name).logfile.logExtFileFlags -split ',' | Sort-Object
    $ProposedLogFlags = $LogFlags -split ',' | Sort-Object

    if (Compare-Object -ReferenceObject $CurrentLogFlags -DifferenceObject $ProposedLogFlags)
    {
        return $false
    }

    return $true

}
function Confirm-UniqueBinding
{
    <#
    .SYNOPSIS
        Helper function used to validate that the website's binding information is unique to other websites.
        Returns False if at least one of the bindings is already assigned to another website.
    .PARAMETER Name
        Specifies the name of the website.
    .PARAMETER ExcludeStopped
        Omits stopped websites.
    .NOTES
        This function tests standard ('http' and 'https') bindings only.
        It is technically possible to assign identical non-standard bindings (such as 'net.tcp') to different websites.
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [Switch]
        $ExcludeStopped
    )

    $Website = Get-Website | Where-Object -FilterScript {$_.Name -eq $Name}

    if (-not $Website)
    {
        $ErrorMessage = $LocalizedData.ErrorWebsiteNotFound -f $Name
        New-TerminatingError -ErrorId 'WebsiteNotFound' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
    }

    $ReferenceObject = @(
        $Website.bindings.Collection |
        Where-Object -FilterScript {$_.protocol -in @('http', 'https')} |
        ConvertTo-WebBinding -Verbose:$false
    )

    if ($ExcludeStopped)
    {
        $OtherWebsiteFilter = {$_.Name -ne $Website.Name -and $_.State -ne 'Stopped'}
    }
    else
    {
        $OtherWebsiteFilter = {$_.Name -ne $Website.Name}
    }

    $DifferenceObject = @(
        Get-Website |
        Where-Object -FilterScript $OtherWebsiteFilter |
        ForEach-Object -Process {$_.bindings.Collection} |
        Where-Object -FilterScript {$_.protocol -in @('http', 'https')} |
        ConvertTo-WebBinding -Verbose:$false
    )

    # Assume that bindings are unique
    $Result = $true

    $CompareSplat = @{
        ReferenceObject  = $ReferenceObject
        DifferenceObject = $DifferenceObject
        Property         = @('protocol', 'bindingInformation')
        ExcludeDifferent = $true
        IncludeEqual     = $true
    }

    if (Compare-Object @CompareSplat)
    {
        $Result = $false
    }

    return $Result
}

function Confirm-UniqueServiceAutoStartProviders
{
    <#
    .SYNOPSIS
        Helper function used to validate that the AutoStartProviders is unique to other websites.
        returns False if the AutoStartProviders exist.
    .PARAMETER serviceAutoStartProvider
        Specifies the name of the AutoStartProviders.
    .PARAMETER ExcludeStopped
        Specifies the name of the Application Type for the AutoStartProvider.
    .NOTES
        This tests for the existance of a AutoStartProviders which is globally assigned. As AutoStartProviders
        need to be uniquely named it will check for this and error out if attempting to add a duplicatly named AutoStartProvider.
        Name is passed in to bubble to any error messages during the test.
    #>

    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $ServiceAutoStartProvider,

        [Parameter(Mandatory = $true)]
        [String]
        $ApplicationType
    )

    $WebSiteAutoStartProviders = (Get-WebConfiguration -filter /system.applicationHost/serviceAutoStartProviders).Collection

    $ExistingObject = $WebSiteAutoStartProviders | `
        Where-Object -Property Name -eq -Value $serviceAutoStartProvider | `
        Select-Object Name,Type

    $ProposedObject = @(New-Object -TypeName PSObject -Property @{
        name   = $ServiceAutoStartProvider
        type   = $ApplicationType
    })

    if(-not $ExistingObject)
        {
            return $false
        }

    if(-not (Compare-Object -ReferenceObject $ExistingObject -DifferenceObject $ProposedObject -Property name))
        {
            if(Compare-Object -ReferenceObject $ExistingObject -DifferenceObject $ProposedObject -Property type)
                {
                    $ErrorMessage = $LocalizedData.ErrorWebsiteTestAutoStartProviderFailure
                    New-TerminatingError -ErrorId 'ErrorWebsiteTestAutoStartProviderFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
                }
        }

    return $true

}

function ConvertTo-CimBinding
{
    <#
    .SYNOPSIS
        Converts IIS <binding> elements to instances of the MSFT_xWebBindingInformation CIM class.
    #>
    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [Object[]]
        $InputObject
    )
    begin
    {
        $CimClassName = 'MSFT_xWebBindingInformation'
        $CimNamespace = 'root/microsoft/Windows/DesiredStateConfiguration'
    }
    process
    {
        foreach ($Binding in $InputObject)
        {
            [Hashtable]$CimProperties = @{
                Protocol           = [String]$Binding.protocol
                BindingInformation = [String]$Binding.bindingInformation
            }

            if ($Binding.Protocol -in @('http', 'https'))
            {
                if ($Binding.bindingInformation -match '^\[(.*?)\]\:(.*?)\:(.*?)$') # Extract IPv6 address
                {
                    $IPAddress = $Matches[1]
                    $Port      = $Matches[2]
                    $HostName  = $Matches[3]
                }
                else
                {
                    $IPAddress, $Port, $HostName = $Binding.bindingInformation -split '\:'
                }

                if ([String]::IsNullOrEmpty($IPAddress))
                {
                    $IPAddress = '*'
                }

                $CimProperties.Add('IPAddress', [String]$IPAddress)
                $CimProperties.Add('Port',      [UInt16]$Port)
                $CimProperties.Add('HostName',  [String]$HostName)
            }
            else
            {
                $CimProperties.Add('IPAddress', [String]::Empty)
                $CimProperties.Add('Port',      [UInt16]::MinValue)
                $CimProperties.Add('HostName',  [String]::Empty)
            }

            if ([Environment]::OSVersion.Version -ge '6.2')
            {
                $CimProperties.Add('SslFlags', [String]$Binding.sslFlags)
            }

            $CimProperties.Add('CertificateThumbprint', [String]$Binding.certificateHash)
            $CimProperties.Add('CertificateStoreName',  [String]$Binding.certificateStoreName)

            New-CimInstance -ClassName $CimClassName -Namespace $CimNamespace -Property $CimProperties -ClientOnly
        }
    }
}

function ConvertTo-WebBinding
{
    <#
    .SYNOPSIS
        Converts instances of the MSFT_xWebBindingInformation CIM class to the IIS <binding> element representation.
    .LINK
        https://www.iis.net/configreference/system.applicationhost/sites/site/bindings/binding
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [AllowEmptyCollection()]
        [AllowNull()]
        [Object[]]
        $InputObject
    )
    process
    {
        foreach ($Binding in $InputObject)
        {
            $OutputObject = @{
                protocol = $Binding.Protocol
            }

            if ($Binding -is [Microsoft.Management.Infrastructure.CimInstance])
            {
                if ($Binding.Protocol -in @('http', 'https'))
                {
                    if (-not [String]::IsNullOrEmpty($Binding.BindingInformation))
                    {
                        if (-not [String]::IsNullOrEmpty($Binding.IPAddress) -or
                            -not [String]::IsNullOrEmpty($Binding.Port) -or
                            -not [String]::IsNullOrEmpty($Binding.HostName)
                        )
                        {
                            $IsJoinRequired = $true
                            Write-Verbose -Message ($LocalizedData.VerboseConvertToWebBindingIgnoreBindingInformation -f $Binding.Protocol)
                        }
                        else
                        {
                            $IsJoinRequired = $false
                        }
                    }
                    else
                    {
                        $IsJoinRequired = $true
                    }

                    # Construct the bindingInformation attribute
                    if ($IsJoinRequired -eq $true)
                    {
                        $IPAddressString = Format-IPAddressString -InputString $Binding.IPAddress -ErrorAction Stop

                        if ([String]::IsNullOrEmpty($Binding.Port))
                        {
                            switch ($Binding.Protocol)
                            {
                                'http'  {$PortNumberString = '80'}
                                'https' {$PortNumberString = '443'}
                            }

                            Write-Verbose -Message ($LocalizedData.VerboseConvertToWebBindingDefaultPort -f $Binding.Protocol, $PortNumberString)
                        }
                        else
                        {
                            if (Test-PortNumber -InputString $Binding.Port)
                            {
                                $PortNumberString = $Binding.Port
                            }
                            else
                            {
                                $ErrorMessage = $LocalizedData.ErrorWebBindingInvalidPort -f $Binding.Port
                                New-TerminatingError -ErrorId 'WebBindingInvalidPort' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidArgument'
                            }
                        }

                        $BindingInformation = $IPAddressString, $PortNumberString, $Binding.HostName -join ':'
                        $OutputObject.Add('bindingInformation', [String]$BindingInformation)
                    }
                    else
                    {
                        $OutputObject.Add('bindingInformation', [String]$Binding.BindingInformation)
                    }
                }
                else
                {
                    if ([String]::IsNullOrEmpty($Binding.BindingInformation))
                    {
                        $ErrorMessage = $LocalizedData.ErrorWebBindingMissingBindingInformation -f $Binding.Protocol
                        New-TerminatingError -ErrorId 'WebBindingMissingBindingInformation' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidArgument'
                    }
                    else
                    {
                        $OutputObject.Add('bindingInformation', [String]$Binding.BindingInformation)
                    }
                }

                # SSL-related properties
                if ($Binding.Protocol -eq 'https')
                {
                    if ([String]::IsNullOrEmpty($Binding.CertificateThumbprint))
                    {
                        $ErrorMessage = $LocalizedData.ErrorWebBindingMissingCertificateThumbprint -f $Binding.Protocol
                        New-TerminatingError -ErrorId 'WebBindingMissingCertificateThumbprint' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidArgument'
                    }

                    if ([String]::IsNullOrEmpty($Binding.CertificateStoreName))
                    {
                        $CertificateStoreName = 'MY'
                        Write-Verbose -Message ($LocalizedData.VerboseConvertToWebBindingDefaultCertificateStoreName -f $CertificateStoreName)
                    }
                    else
                    {
                        $CertificateStoreName = $Binding.CertificateStoreName
                    }

                    # Remove the Left-to-Right Mark character
                    $CertificateHash = $Binding.CertificateThumbprint -replace '^\u200E'

                    $OutputObject.Add('certificateHash',      [String]$CertificateHash)
                    $OutputObject.Add('certificateStoreName', [String]$CertificateStoreName)

                    if ([Environment]::OSVersion.Version -ge '6.2')
                    {
                        $SslFlags = [Int64]$Binding.SslFlags

                        if ($SslFlags -in @(1, 3) -and [String]::IsNullOrEmpty($Binding.HostName))
                        {
                            $ErrorMessage = $LocalizedData.ErrorWebBindingMissingSniHostName
                            New-TerminatingError -ErrorId 'WebBindingMissingSniHostName' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidArgument'
                        }

                        $OutputObject.Add('sslFlags', $SslFlags)
                    }
                }
                else
                {
                    # Ignore SSL-related properties for non-SSL bindings
                    $OutputObject.Add('certificateHash',      [String]::Empty)
                    $OutputObject.Add('certificateStoreName', [String]::Empty)

                    if ([Environment]::OSVersion.Version -ge '6.2')
                    {
                        $OutputObject.Add('sslFlags', [Int64]0)
                    }
                }
            }
            else
            {
                <#
                    WebAdministration can throw the following exception if there are non-standard bindings (such as 'net.tcp'):
                    'The data is invalid. (Exception from HRESULT: 0x8007000D)'

                    Steps to reproduce:
                    1) Add 'net.tcp' binding
                    2) Execute {Get-Website | ForEach-Object {$_.bindings.Collection} | Select-Object *}

                    Workaround is to create a new custom object and use dot notation to access binding properties.
                #>

                $OutputObject.Add('bindingInformation',   [String]$Binding.bindingInformation)
                $OutputObject.Add('certificateHash',      [String]$Binding.certificateHash)
                $OutputObject.Add('certificateStoreName', [String]$Binding.certificateStoreName)

                if ([Environment]::OSVersion.Version -ge '6.2')
                {
                    $OutputObject.Add('sslFlags', [Int64]$Binding.sslFlags)
                }
            }

            Write-Output -InputObject ([PSCustomObject]$OutputObject)
        }
    }
}

function Format-IPAddressString
{
    <#
    .SYNOPSYS
        Formats the input IP address string for use in the bindingInformation attribute.
    #>
    [CmdletBinding()]
    [OutputType([String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [AllowNull()]
        [String]
        $InputString
    )

    if ([String]::IsNullOrEmpty($InputString) -or $InputString -eq '*')
    {
        $OutputString = '*'
    }
    else
    {
        try
        {
            $IPAddress = [IPAddress]::Parse($InputString)

            switch ($IPAddress.AddressFamily)
            {
                'InterNetwork'
                {
                    $OutputString = $IPAddress.IPAddressToString
                }
                'InterNetworkV6'
                {
                    $OutputString = '[{0}]' -f $IPAddress.IPAddressToString
                }
            }
        }
        catch
        {
            $ErrorMessage = $LocalizedData.ErrorWebBindingInvalidIPAddress -f $InputString, $_.Exception.Message
            New-TerminatingError -ErrorId 'WebBindingInvalidIPAddress' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidArgument'
        }
    }

    return $OutputString
}

function Get-AuthenticationInfo
{
    <#
    .SYNOPSIS
        Helper function used to validate that the authenticationProperties for an Application.
    .PARAMETER Site
        Specifies the name of the Website.
    #>

    [CmdletBinding()]
    [OutputType([Microsoft.Management.Infrastructure.CimInstance])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Site
    )

    $authenticationProperties = @{}
    foreach ($type in @('Anonymous', 'Basic', 'Digest', 'Windows'))
    {
        $authenticationProperties[$type] = [String](Test-AuthenticationEnabled -Site $Site -Type $type)
    }

    return New-CimInstance `
            -ClassName MSFT_xWebApplicationAuthenticationInformation `
            -ClientOnly -Property $authenticationProperties
}

function Get-DefaultAuthenticationInfo
{
    <#
    .SYNOPSIS
        Helper function used to build a default CimInstance for AuthenticationInformation
    #>

    New-CimInstance -ClassName MSFT_xWebAuthenticationInformation `
        -ClientOnly `
        -Property @{Anonymous=$false;Basic=$false;Digest=$false;Windows=$false}
}

function Set-Authentication
{
    <#
    .SYNOPSIS
        Helper function used to set authenticationProperties for an Application.
    .PARAMETER Site
        Specifies the name of the Website.
    .PARAMETER Type
        Specifies the type of Authentication, Limited to the set: ('Anonymous','Basic','Digest','Windows').
    .PARAMETER Enabled
        Whether the Authentication is enabled or not.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Site,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Anonymous','Basic','Digest','Windows')]
        [String]$Type,

        [Boolean]$Enabled
    )

    Set-WebConfigurationProperty `
        -Filter /system.WebServer/security/authentication/${Type}Authentication `
        -Name enabled `
        -Value $Enabled `
        -Location $Site
}

function Set-AuthenticationInfo
{
    <#
    .SYNOPSIS
        Helper function used to validate that the authenticationProperties for an Application.
    .PARAMETER Site
        Specifies the name of the Website.
    .PARAMETER AuthenticationInfo
        A CimInstance of what state the AuthenticationInfo should be.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Site,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    foreach ($type in @('Anonymous', 'Basic', 'Digest', 'Windows'))
    {
        $enabled = ($AuthenticationInfo.CimInstanceProperties[$type].Value -eq $true)
        Set-Authentication -Site $Site -Type $type -Enabled $enabled
    }
}

function Test-AuthenticationEnabled
{
    <#
    .SYNOPSIS
        Helper function used to test the authenticationProperties state for an Application.
        Will return that value which will either [String]True or [String]False
    .PARAMETER Site
        Specifies the name of the Website.
   .PARAMETER Type
        Specifies the type of Authentication, Limited to the set: ('Anonymous','Basic','Digest','Windows').
    #>

    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Site,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Anonymous','Basic','Digest','Windows')]
        [String]$Type
    )


    $prop = Get-WebConfigurationProperty `
        -Filter /system.WebServer/security/authentication/${Type}Authentication `
        -Name enabled `
        -Location $Site
    return $prop.Value
}

function Test-AuthenticationInfo
{
    <#
    .SYNOPSIS
        Helper function used to test the authenticationProperties state for an Application.
        Will return that result which will either [boolean]$True or [boolean]$False for use in Test-TargetResource.
        Uses Test-AuthenticationEnabled to determine this. First incorrect result will break this function out.
    .PARAMETER Site
        Specifies the name of the Website.
    .PARAMETER AuthenticationInfo
        A CimInstance of what state the AuthenticationInfo should be.
    #>

    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]$Site,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Management.Infrastructure.CimInstance]$AuthenticationInfo
    )

    $result = $true

    foreach ($type in @('Anonymous', 'Basic', 'Digest', 'Windows'))
    {
        $expected = $AuthenticationInfo.CimInstanceProperties[$type].Value
        $actual = Test-AuthenticationEnabled -Site $Site -Type $type
        if ($expected -ne $actual)
        {
            $result = $false
            break
        }
    }

    return $result
}

function Test-BindingInfo
{
    <#
    .SYNOPSYS
        Validates the desired binding information (i.e. no duplicate IP address, port, and host name combinations).
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    $IsValid = $true

    try
    {
        # Normalize the input (helper functions will perform additional validations)
        $Bindings = @(ConvertTo-WebBinding -InputObject $BindingInfo | ConvertTo-CimBinding)
        $StandardBindings = @($Bindings | Where-Object -FilterScript {$_.Protocol -in @('http', 'https')})
        $NonStandardBindings = @($Bindings | Where-Object -FilterScript {$_.Protocol -notin @('http', 'https')})

        if ($StandardBindings.Count -ne 0)
        {
            # IP address, port, and host name combination must be unique
            if (($StandardBindings | Group-Object -Property IPAddress, Port, HostName) | Where-Object -FilterScript {$_.Count -ne 1})
            {
                $IsValid = $false
                Write-Verbose -Message ($LocalizedData.VerboseTestBindingInfoSameIPAddressPortHostName)
            }

            # A single port cannot be simultaneously specified for bindings with different protocols
            foreach ($GroupByPort in ($StandardBindings | Group-Object -Property Port))
            {
                if (($GroupByPort.Group | Group-Object -Property Protocol).Length -ne 1)
                {
                    $IsValid = $false
                    Write-Verbose -Message ($LocalizedData.VerboseTestBindingInfoSamePortDifferentProtocol)
                    break
                }
            }
        }

        if ($NonStandardBindings.Count -ne 0)
        {
            if (($NonStandardBindings | Group-Object -Property Protocol, BindingInformation) | Where-Object -FilterScript {$_.Count -ne 1})
            {
                $IsValid = $false
                Write-Verbose -Message ($LocalizedData.VerboseTestBindingInfoSameProtocolBindingInformation)
            }
        }
    }
    catch
    {
        $IsValid = $false
        Write-Verbose -Message ($LocalizedData.VerboseTestBindingInfoInvalidCatch -f $_.Exception.Message)
    }

    return $IsValid
}

function Test-PortNumber
{
    <#
    .SYNOPSYS
        Validates that an input string represents a valid port number.
        The port number must be a positive integer between 1 and 65535.
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [AllowNull()]
        [String]
        $InputString
    )

    try
    {
        $IsValid = [UInt16]$InputString -ne 0
    }
    catch
    {
        $IsValid = $false
    }

    return $IsValid
}

function Test-WebsiteBinding
{
    <#
    .SYNOPSIS
        Helper function used to validate and compare website bindings of current to desired.
        Returns True if bindings do not need to be updated.
    #>
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    $InDesiredState = $true

    # Ensure that desired binding information is valid (i.e. no duplicate IP address, port, and host name combinations).
    if (-not (Test-BindingInfo -BindingInfo $BindingInfo))
    {
        $ErrorMessage = $LocalizedData.ErrorWebsiteBindingInputInvalidation -f $Name
        New-TerminatingError -ErrorId 'WebsiteBindingInputInvalidation' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
    }

    try
    {
        $Website = Get-Website | Where-Object -FilterScript {$_.Name -eq $Name}

        # Normalize binding objects to ensure they have the same representation
        $CurrentBindings = @(ConvertTo-WebBinding -InputObject $Website.bindings.Collection -Verbose:$false)
        $DesiredBindings = @(ConvertTo-WebBinding -InputObject $BindingInfo -Verbose:$false)

        $PropertiesToCompare = 'protocol', 'bindingInformation', 'certificateHash', 'certificateStoreName'

        # The sslFlags attribute was added in IIS 8.0.
        # This check is needed for backwards compatibility with Windows Server 2008 R2.
        if ([Environment]::OSVersion.Version -ge '6.2')
        {
            $PropertiesToCompare += 'sslFlags'
        }

        if (Compare-Object -ReferenceObject $CurrentBindings -DifferenceObject $DesiredBindings -Property $PropertiesToCompare)
        {
            $InDesiredState = $false
        }
    }
    catch
    {
        $ErrorMessage = $LocalizedData.ErrorWebsiteCompareFailure -f $Name, $_.Exception.Message
        New-TerminatingError -ErrorId 'WebsiteCompareFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
    }

    return $InDesiredState
}

function Update-DefaultPage
{
    <#
    .SYNOPSIS
        Helper function used to update default pages of website.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [String]
        $Name,

        [Parameter(Mandatory = $true)]
        [String[]]
        $DefaultPage
    )

    $AllDefaultPages = @(
        Get-WebConfiguration -Filter '//defaultDocument/files/*' -PSPath "IIS:\Sites\$Name" |
        ForEach-Object -Process {Write-Output -InputObject $_.value}
    )

    foreach ($Page in $DefaultPage)
    {
        if ($AllDefaultPages -inotcontains $Page)
        {
            Add-WebConfiguration -Filter '//defaultDocument/files' -PSPath "IIS:\Sites\$Name" -Value @{value = $Page}
            Write-Verbose -Message ($LocalizedData.VerboseUpdateDefaultPageUpdated -f $Name, $Page)
        }
    }
}

function Update-WebsiteBinding
{
    <#
    .SYNOPSIS
        Updates website bindings.
    #>
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $false)]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $BindingInfo
    )

    # Use Get-WebConfiguration instead of Get-Website to retrieve XPath of the target website.
    # XPath -Filter is case-sensitive. Use Where-Object to get the target website by name.
    $Website = Get-WebConfiguration -Filter '/system.applicationHost/sites/site' |
        Where-Object -FilterScript {$_.Name -eq $Name}

    if (-not $Website)
    {
        $ErrorMessage = $LocalizedData.ErrorWebsiteNotFound -f $Name
        New-TerminatingError -ErrorId 'WebsiteNotFound' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
    }

    ConvertTo-WebBinding -InputObject $BindingInfo -ErrorAction Stop |
    ForEach-Object -Begin {

        Clear-WebConfiguration -Filter "$($Website.ItemXPath)/bindings" -Force -ErrorAction Stop

    } -Process {

        $Properties = $_

        try
        {
            Add-WebConfiguration -Filter "$($Website.ItemXPath)/bindings" -Value @{
                protocol = $Properties.protocol
                bindingInformation = $Properties.bindingInformation
            } -Force -ErrorAction Stop
        }
        catch
        {
            $ErrorMessage = $LocalizedData.ErrorWebsiteBindingUpdateFailure -f $Name, $_.Exception.Message
            New-TerminatingError -ErrorId 'WebsiteBindingUpdateFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
        }

        if ($Properties.protocol -eq 'https')
        {
            if ([Environment]::OSVersion.Version -ge '6.2')
            {
                try
                {
                    Set-WebConfigurationProperty -Filter "$($Website.ItemXPath)/bindings/binding[last()]" -Name sslFlags -Value $Properties.sslFlags -Force -ErrorAction Stop
                }
                catch
                {
                    $ErrorMessage = $LocalizedData.ErrorWebsiteBindingUpdateFailure -f $Name, $_.Exception.Message
                    New-TerminatingError -ErrorId 'WebsiteBindingUpdateFailure' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidResult'
                }
            }

            try
            {
                $Binding = Get-WebConfiguration -Filter "$($Website.ItemXPath)/bindings/binding[last()]" -ErrorAction Stop
                $Binding.AddSslCertificate($Properties.certificateHash, $Properties.certificateStoreName)
            }
            catch
            {
                $ErrorMessage = $LocalizedData.ErrorWebBindingCertificate -f $Properties.certificateHash, $_.Exception.Message
                New-TerminatingError -ErrorId 'WebBindingCertificate' -ErrorMessage $ErrorMessage -ErrorCategory 'InvalidOperation'
            }
        }

    }

}

#endregion

Export-ModuleMember -Function *-TargetResource
