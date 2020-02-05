Param(
    [string]$EnvName,
    [string]$State 
    )
if ($State -eq 'create') {
    if (Test-Path .\$EnvName){
        cd .\$EnvName
        terraform init
        terraform apply -auto-approve
        terraform output -json >> output.json
    }
    else{
        Copy-Item -Recurse .\Cloud_DevOps\ .\$EnvName
        (Get-Content .\$EnvName\global_variables.tf) | ForEach-Object {
        $_.replace('#EnvironmentName#', $EnvName) #.replace('somethingElse1', 'somethingElse2') placeholder #EnvironmentName# in global variables.tf is replaced by $EnvName variable
        } | Set-Content .\$EnvName\global_variables.tf
        cd .\$EnvName
        terraform init
        terraform apply -auto-approve
        terraform output -json >> output.json
    }
}
elseif ($State -eq 'destroy') {
    cd .\$EnvName
    terraform init
    terraform destroy -auto-approve
    cd ..\.
    Remove-Item .\$EnvName -Recurse -Force
}
