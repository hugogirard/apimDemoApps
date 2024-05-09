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

## Run the GitHub Action

Once you have created the secrets, you can run the GitHub Action called **Create Azure Resources**.  The GitHub Action will create the resources in Azure.

# Create the App Registration for the API

In the Azure Portal on the resource group called **rg-apim-demo** you have a web app called **fibo-api**.  You will need to create an App Registration for this web app.  You can do this by following the steps below.

1. Go to the Azure Portal and navigate to the resource group called **rg-apim-demo**.
2. Find the web app called **fibo-api** and click on it to open its settings.
3. In the left-hand menu, under the **Settings** section, click on **Authentication / Authorization**.
4. In the **Authentication / Authorization** settings, click **Add identity provider**.
5. Select **Microsoft** as an identity provider.
6. In client application requirements, select **Allow request from any application**.
7. In the option **Uauthenticated requests** select **HTTP 401 Unauthorized: recommended for APIs**.
8. Click **Add** to save the changes.

You will see a **App (client) ID**, copy the value, you will need it for a secret.

## Modify the App Registration in Microsoft Entra ID

In the Azure Portal, go to the App Registration you created for the API.  You will need to modify the App Registration.

1. Go to the **Manifest** section.
2. Find the **accessTokenAcceptedVersion** and change the value to **2**.
3. Click **Save** to save the changes.

## Create a new secret in the GitHub repository

Create a new **Secret** called **AUDIENCE_FIBO_API** with the value of the **App (client) ID** you copied earlier.

## Run the GitHub Action

Once you have created the secrets, you can run the GitHub Action called **Deploy Fibonaci Web Api**.  The GitHub Action will deploy the web API.

