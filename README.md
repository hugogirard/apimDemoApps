# Introduction



# apimDemoApps
Simple demo for Azure API Management


## Create Github Secrets

You will need to create some [GitHub repository secrets](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-codespaces#adding-secrets-for-a-repository) first.  Here the list of secrets you will need to create.

| Secret Name | Value | Link
|-------------|-------|------|
| AZURE_CREDENTIALS | The service principal credentials needed in the Github Action | [GitHub Action](https://github.com/marketplace/actions/azure-login)
| AZURE_SUBSCRIPTION | The subscription ID where the resources will be created |
| TENANT_ID | The Microsoft Entra ID Tenant ID |
| PUBLISHER_EMAIL | The Admin Email related to the instance of APIM, can be your personal email |
| PA_TOKEN | Needed to create GitHub repository secret within the GitHub action |  [Github Action](https://github.com/gliech/create-github-secret-action) |

# Run Fibonacci API

```bash
dotnet user-secrets init
dotnet user-secrets set "COSMOS_CONNECTION_STRING" ""
```

AUDIENCE_FIBO_API