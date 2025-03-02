# Import Active Directory Module

#Description: This script detects the user's department, deletes currente mapped drives & maps new drives. 
Import-Module ActiveDirectory

# Get the logged-in user's username
$User = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name # calls the GetCurrent() method from the WindowsIdentity class.
$User = $User.Split("\")[-1]  # Extract only the username. [-1] gets the last element in the array

# Get department value from Active Directory
$Department = (Get-ADUser -Identity $User -Properties Department).Department




# Define department-based drive mappings (multiple drives per department)
$DriveMappings = @{
    "IT"        = @(
                    @{DriveLetter="X:"; Path="\\Server\ITPublic"},
                    @{DriveLetter="Y:"; Path="\\Server\ITSecure"},
                    @{DriveLetter="Z:"; Path="\\Server\ITProjects"}
                  )
    "Finance"   = @(
                    @{DriveLetter="X:"; Path="\\Server\FinanceReports"},
                    @{DriveLetter="Y:"; Path="\\Server\FinanceShared"},
                    @{DriveLetter="Z:"; Path="\\Server\FinanceArchive"}
                  )
    "HR"        = @(
                    @{DriveLetter="X:"; Path="\\Server\HRPolicies"},
                    @{DriveLetter="Y:"; Path="\\Server\HRTraining"},
                    @{DriveLetter="Z:"; Path="\\Server\HREmployeeRecords"}
                  )
    "Marketing" = @(
                    @{DriveLetter="X:"; Path="\\Server\MarketingAds"},
                    @{DriveLetter="Y:"; Path="\\Server\MarketingCampaigns"},
                    @{DriveLetter="Z:"; Path="\\Server\MarketingDesigns"}
                  )
}

# Remove all existing mapped drives
$MappedDrives = Get-WmiObject Win32_MappedLogicalDisk | Select-Object DeviceID # Return all mapped drives & Select drive letters
foreach ($Drive in $MappedDrives) { # for each drive letter in mapped drives variable
    Remove-PSDrive -Name $Drive.DeviceID.Replace(":", "") -Force -ErrorAction SilentlyContinue  # removed without prompting user
}

# Check if department exists
if ($ADUser -and $ADUser.Department) {
    $Department = $ADUser.Department
    Write-Host "User: $User | Department: $Department"

    # Check if department exists in drivemappings array
    if ($DriveMappings.ContainsKey($Department)) {
        foreach ($Drive in $DriveMappings[$Department]) {
            New-PSDrive -Name $Drive.DriveLetter.Replace(":", "") -PSProvider FileSystem -Root $Drive.Path -Persist # Map drives
            Write-Host "Mapped $($Drive.DriveLetter) to $($Drive.Path) for department $Department"
        }
    } else {
        Write-Host "No drive mapping found for department: $Department"
    }
} else {
    Write-Host "Department information not found for user: $User"
}
