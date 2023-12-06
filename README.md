# Google Cloud Resources Remark CTL 

Remark CTL is a tool to automate the google cloud resources [bulk-]export into terraform (infrastructure as code). The tool helps replicating, side-by-side,  the Google Cloud resource hierarchy. Practitioners could leverage this tool for an accelerated, repeatable user-friendly resource configurations export, and infrastructure updating - while ensuring IaC practice for any Terraform Supported Resources, either by terraform provider google (TPG) or google-beta (TPB). 

## Core capability
* Natively integrated with Terraform framework only (at least for now)
* Natively integrated with Terraform google and google-beta providers
* Natively integrated with Google Cloud SDK

## Common use case
* Google Cloud Users, who are unfamiliar to Google Cloud terraform provider, may want to start by navigating the Google Cloud Console to provision resources, to accelerate the learn pace and flatten the learning curve, then export all resources into terraform.
* Google Cloud Users, who posses multiple unmanaged resources as result of the innovatiion freedom given too their cloud team members, may want to have a central enterprise-wide resources state and inventory at IT leading level.
* Google Cloud Users, who to use a much more user-friendly tool than the existing `gcloud beta resource-config`.

## Unsupported and WIP
* Unable to create a catalogue based on Google Cloud resource relationships, for instance, unable to remark a GCP cluster reither than each Cluster's Node. The relational cataloguing is only support by SCC premium users.
* (WIP) Still not support a few of terraform import `ID` patterns autonomousty/programmatically. For instance, it will display some import error for a couple of resources, as the ID parsing pattern differ from the majority of TPG and TPB resource import ID patterns.


## How it works (step-by-step)
There are two ways you can use this tool, either by cloning this repository and requesting access to the core source code in the submodules - ``"./kitabus"``, or by executing the pre-build docker image. 
* Recommendation: executing through the docker image

### Example running from source code 
```bash
# Print the usage message
go run . help   # from source code
```
```bash
# Set the required environment varialbles, and the scope
export SCOPE=<organizations/GOOGLE_CLOUD_ORG_ID>|<folders/FOLDER_ID>|<projects/PROJECT_ID>

# IF both set as comma-separated list (e.g. "<compute.*, iam.*Role>")
export KIND=<GOOGLE_CLOUD_SERVICE_TYPE OR GOOGLE_CLOUD_RESOURCE_TYPE OR BOTH>

# The path to output resource configuations (default: current working dir)
export WORKDIR="<PATH_FOR_OUTPUTS>"

# Set the service account for impersonation
export TF_IMPERSONATION_SA="<service_account_email>"
```
```bash
# Set the billing project and authenticate
gcloud config set project <PROJECT_ID>
gcloud auth login 
```
```bash
# Generate the project resources catalogue from the org level to bottom
go run . generate catalogue --scope "organizations/$ORG_ID" --kind ".*Project" --workdir "."
```
```bash
# Generate the organization resources hierarchy as a directory tree
go run . generate organization-tree --workdir "."
```
```bash
# Generate the resources' TF modules templates
go run . generate modules --workdir "."
```

```bash
# Generate import resources
go run . import state --workdir "."
```

### Example using a pre-build docker image

```bash
# Set the Environment variable to run the CATALOGUS 
export SCOPE="organizations/$(gcloud organizations list --filter 'display_name ~ xxxx' --format 'value(ID)')"
export KIND=".*Instance"
export WORKDIR="./:/dataplane"
```

```bash
# Run docker image as interactive command-line interface
export PROJECT_ID='<PROJECT_ID>'
export GCLOUD_AUTH_CMD='gcloud auth login --project $PROJECT_ID --account $GCLOUD_UACC'
export GCLOUD_UACC='<GOOGLE_CLOUD_USER_ACCOUNT>'
docker run --rm -v $WORKDIR \
-e GCLOUD_UACC="${GCLOUD_UACC}" \
-e KIND="${KIND}" \
-e SCOPE="${SCOPE}" \
-e PROJECT_ID="${PROJECT_ID}" \
-e GCLOUD_AUTH_CMD="${GCLOUD_AUTH_CMD}" \
-e CATALOGUS_CMD="${CATALOGUS_CMD}" -it ${CATALOGUS_IMAGE}:latest
```

```bash
# Run this in auto mode
# export CATALOGUS_CMD='remarkctl auto --override --scope $SCOPE --kind $KIND'
# eval $GCLOUD_AUTH_CMD 
# OR
# COPY the binary into your local environment and run
# cp /usr/bin/remarkctl . && exit
# 
# Execute locally
# remarkctl auto --scope $SCOPE --kind $KIND
```

### Expected Output
```bash
# Example output structure - IF I run the 
remarkctl auto --scope $SCOPE --kind compute.*Subnetwork

---

cloudxaxasxs.yyyyyy.zzz                         # Cloud Identity AS-IS
├── Infrastructure                              # Folder in the GCP org    
│   └── Development                             # Folder in the GCP org   
│       └── xxxxx-dev-net-spoke-yyyyyy          # Project in the GCP org   
│           └── .ACTIVE                         # Container for Active resources (local Folder)
│               ├── .BASE
│               ├── compute
│               ├── compute_module.tf
│               ├── .FAILED_SIGNATURES
│               ├── providers.tf
│               ├── .terraform
│               ├── .terraform.lock.hcl
│               ├── terraform.tfstate
│               └── .TF_IMPORT_SIGNATURES
├── Onboarding Host Project
│   └── .ACTIVE
│       ├── .BASE
│       │   └── .subnetwork                     # Configurations base arguments inputs, 
│       ├── compute                             # Compute module
│       │   └── Subnetwork.tf                   # Subnetwork TF resource definition
│       ├── compute_module.tf                   # Compute module definition
│       ├── .FAILED_SIGNATURES
│       ├── providers.tf
│       ├── .terraform
│       │   ├── modules
│       │   │   └── modules.json
│       │   └── providers
│       │       └── registry.terraform.io
│       ├── .terraform.lock.hcl
│       └── .TF_IMPORT_SIGNATURES
└── Sandbox
    ├── cloud-xxxxxx-labs
    │   └── .ACTIVE
    │       ├── .BASE
    │       │   └── .subnetwork
    │       ├── compute
    │       │   └── Subnetwork.tf
    │       ├── compute_module.tf
    │       ├── .FAILED_SIGNATURES
    │       ├── providers.tf
    │       ├── .terraform
    │       │   ├── modules
    │       │   └── providers
    │       ├── .terraform.lock.hcl
    │       ├── terraform.tfstate
    │       ├── terraform.tfstate.backup
    │       └── .TF_IMPORT_SIGNATURES
    ├── devopsxxxsxs-studio
    │   └── .ACTIVE
    │       ├── .BASE
    │       │   └── .subnetwork
    │       ├── compute
    │       │   └── Subnetwork.tf
    │       ├── compute_module.tf
    │       ├── .FAILED_SIGNATURES
    │       ├── providers.tf
    │       ├── .terraform
    │       │   ├── modules
    │       │   └── providers
    │       ├── .terraform.lock.hcl
    │       ├── terraform.tfstate
    │       ├── terraform.tfstate.backup
    │       └── .TF_IMPORT_SIGNATURES
    ├── edge-xsxsxsxs-cloud-zone
    │   └── .ACTIVE
    │       ├── .BASE
    │       │   └── .subnetwork
    │       ├── compute
    │       │   └── Subnetwork.tf
    │       ├── compute_module.tf
    │       ├── .FAILED_SIGNATURES
    │       ├── providers.tf
    │       ├── .terraform
    │       │   ├── modules
    │       │   └── providers
    │       ├── .terraform.lock.hcl
    │       ├── terraform.tfstate
    │       └── .TF_IMPORT_SIGNATURES
    └── genios-xaxasxasx-zzz
        └── .ACTIVE
            ├── .BASE
            │   └── .subnetwork
            ├── compute
            │   └── Subnetwork.tf
            ├── compute_module.tf
            ├── .FAILED_SIGNATURES
            ├── providers.tf
            ├── .terraform
            │   ├── modules
            │   └── providers
            ├── .terraform.lock.hcl
            ├── terraform.tfstate
            └── .TF_IMPORT_SIGNATURES
```