#Powershell KMS Activator
---

I needed a script to ensure that Windows and Office installations on staff laptops
would stay activated as they transitioned to remote work because of COVID-19.

Usually staff would be on-site and would be working on desktop computers permanently 
connected to the University network.

My University uses the Cisco AnyConnect Secure Mobility Client for VPN access.

I am sure that this script can be modified to be used with other clients.


###Follow the instructions below to setup this script:
---

+ Open the Windows Task Scheduler.
+ Go to **Action > Create Task**
+ Under the **General** tab Change ***User or Group*** to *SYSTEM* (if appropriate).
⋅⋅1. Ensure that *Run with highest privileges* is checked.
⋅⋅2. Pick your OS in the ***Configure for:*** dropdown.

+ Under the **Triggers** tab click ***New...*** and in the *Begin the task:* dropdown select *On an event*.
⋅⋅1. Under settings select *Basic*.
⋅⋅2. For the ***Log:*** field select *Cisco AnyConnect Secure Mobility Client* in the dropdown.
⋅⋅3. For the ***Source:*** field select *acvpnagent* in the dropdown.
⋅⋅4. For the ***Event ID:*** field type is *2039* and finally hit *OK*.

+ Under the **Actions** tab click ***New...*** and in the *Action:* dropdown select *Start a program*.
⋅⋅1. For the ***Program/script*** field provide your path to powershell. Usually this path is `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
⋅⋅2. For the ***Add arguments (optional)*** field type the path to the **pshell_kms_activator** script as: `-WindowStyle Hidden -ExecutionPolicy Bypass -file "C:\your_path_to_script\pshell_kms_activator.ps1"`
⋅⋅3. For the ***Start in (optional)*** field the path to your script as: `C:\your_path_to_script\`
⋅⋅4. Finally click *OK*.

+ Configure the **Conditions** and **Settings** tabs as per your circumstances. I unchecked both ***Power*** options under
   **Conditions**. I left everything else unchanged.
