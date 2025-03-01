# Azure PowerShell Automation Project

## Overview

This PowerShell script automates the deployment of a **Windows Server 2022 Virtual Machine (VM) in Azure** while applying **security best practices**. It ensures that WWF or any organization can efficiently deploy and secure cloud infrastructure with minimal manual intervention.

### **Key Features:**

✅ **Deploys an Azure Virtual Machine** (Windows Server 2022) ✅ **Configures Network Security Groups (NSG)** to restrict access ✅ **Locks down RDP access** to a specific IP for security ✅ **Enables Azure Backup for disaster recovery compliance** ✅ **Generates a status report** on VM configuration and deployment

---

## **Prerequisites**

1. **Azure Subscription** - You must have an active Azure account.
2. **Azure PowerShell Module** - Ensure you have the necessary module installed:
   ```powershell
   Install-Module -Name Az -AllowClobber -Scope CurrentUser
   ```
3. **Login to Azure**:
   ```powershell
   Connect-AzAccount
   ```

---

## **How to Use**

1. **Download the Script:** Clone this repository or download the script file (`Deploy-AzureVM.ps1`).
2. **Modify Configuration Variables** in the script (e.g., VM name, resource group, security settings).
3. **Run the Script**:
   ```powershell
   .\Deploy-AzureVM.ps1
   ```

---

## **Security Measures Implemented**

- **Restricted RDP Access:** Only allows RDP (Port 3389) from a specified IP.
- **Network Security Groups (NSG):** Blocks unauthorized inbound/outbound traffic.
- **Azure Backup Integration:** Ensures VM data is protected against failures.
- **Locally Redundant Storage (LRS):** Used for backup and recovery compliance.


## **Why This Project?**

This project demonstrates expertise in **PowerShell automation**, **Azure administration**, and **security best practices**, which are crucial for a Cloud Infrastructure Engineer role. It reduces operational overhead, improves security, and ensures disaster recovery compliance.



