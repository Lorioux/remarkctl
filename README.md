# Google Cloud Resources Remarker CTL (WIP)

Remark CTL is a tool to automate the google cloud resources [bulk-]export into terraform (infrastructure as code). The tool helps replicating, side-by-side,  the Google Cloud resource hierarchy. Practitioners could leverage this tool for an accelerated, repeatable, automateable and user-friendly resource configurations export, and infrastructure updating - while ensuring IaC practice for any Terraform Supported Resources, either by terraform provider google (TPG) or google-beta (TPB). 

## Core capabilities
* Natively integrated with Terraform framework only (at least for now)
* Natively integrated with Terraform google and google-beta providers
* Natively integrated with Google Cloud SDK

## Core features
* Generate organization resources inventory (a.k.a Catalogus)
* Generate organization resource hierarchy  (a.k.a Organization tree)
* Generate resources's Terraform configurations template
* Generate resource's state as Terraform states (e.g. Import organization scope resource states)

## Common use case
* Google Cloud Users, whom are unfamiliar to Google Cloud terraform providers (a.k.a TPG and TPB), may want to start by navigating the Google Cloud Console to provision resources, to accelerate the learn pace and flatten the learning curve, then export all resources into terraform.
* Google Cloud Users, whom posses multiple unmanaged resources as result of the innovatiion freedom given too their cloud team members, may want to have a central enterprise-wide resources state and inventory at IT leading level.
* Google Cloud Users, whom want to use an automateable, and user-friendly tool as an alternative of the existing `gcloud beta resource-config` *limited to:*
```
# Currently supported resource types.
┌─────────────────────────────┬──────────────┬─────────┬──────┐
│           KRM KIND          │ BULK EXPORT? │ EXPORT? │ IAM? │
├─────────────────────────────┼──────────────┼─────────┼──────┤
│ ArtifactRegistryRepository  │ x            │ x       │ x    │
│ BigQueryDataset             │ x            │ x       │      │
│ BigQueryTable               │ x            │ x       │ x    │
│ ComputeAddress              │ x            │ x       │      │
│ ComputeBackendService       │ x            │ x       │      │
│ ComputeDisk                 │ x            │ x       │ x    │
│ ComputeFirewall             │ x            │ x       │      │
│ ComputeHealthCheck          │ x            │ x       │      │
│ ComputeImage                │ x            │ x       │ x    │
│ ComputeInstance             │ x            │ x       │ x    │
│ ComputeInstanceGroup        │ x            │ x       │      │
│ ComputeInstanceTemplate     │ x            │ x       │      │
│ ComputeNetwork              │ x            │ x       │      │
│ ComputeNetworkEndpointGroup │ x            │ x       │      │
│ ComputeRoute                │ x            │ x       │      │
│ ComputeRouter               │ x            │ x       │      │
│ ComputeSubnetwork           │ x            │ x       │ x    │
│ DNSManagedZone              │ x            │ x       │      │
│ DNSPolicy                   │ x            │ x       │      │
│ Folder                      │ x            │ x       │ x    │
│ IAMServiceAccount           │ x            │         │ x    │
│ IAMServiceAccountKey        │              │         │      │
│ KMSCryptoKey                │ x            │         │ x    │
│ KMSKeyRing                  │ x            │ x       │ x    │
│ LoggingLogSink              │ x            │         │      │
│ Project                     │ x            │ x       │ x    │
│ PubSubSubscription          │ x            │ x       │ x    │
│ PubSubTopic                 │ x            │ x       │ x    │
│ Service                     │ x            │ x       │      │
│ StorageBucket               │ x            │         │ x    │
└─────────────────────────────┴──────────────┴─────────┴──────┘
```

## Unsupported and WIP
* Unable to create a catalogue based on Google Cloud resource relationships, for instance, unable to remark a GCP cluster reither than each Cluster's Node. The relational cataloguing is only support by SCC premium users.
* (WIP) Still not support a few of terraform import `ID` patterns autonomousty/programmatically. For instance, it will display some import error for a couple of resources, as the ID parsing pattern differ from the majority of TPG and TPB resource import ID patterns.


## How it works (step-by-step)
There are two ways you can use this tool, either by cloning this repository and requesting access to the core source code in the submodules - ``"./kitabus"``, or by executing the pre-build docker image. 
* Recommendation: executing through the docker image

### Pre-requisites
* **Service Accounts**. Prepare a service account for impersonation and grant the rigth permissions (a.k.a least-privileges).
    1. `roles/resourcemanager.organizationViewer`
    1. `roles/cloudasset.viewer`
    1. (*Other*) `roles/ANY_ROLE_AS_REQUIRED_WHEN_RUNNING_THIS_TOOL_AT_THE_FIRST_TIME`
    1. **IF** you want update a *`Terraform`* managed resource, please ensure your have the right permissions
* **(Optional) Terraform executable**. *IF* you are running in a local machince ensure you have the latest `terraform binary` installed.
* **Google Cloud SDK**. *IF* you are running locally please install the google cloud sdk and ensure you are authenticated. Also, you will need to config your `gcloud cli` with the right billing project.
* **Docker executable**. *IF* you are running the pre-build docker image.
* **(Optional) Repository access token**. *IF* you are running from the source code locally `you will need to request a access to a private github/lorioux/kitabus repository (at least for now)`. *NOT Applied* for IF you run the command from a pre-build docker image.



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

# Set the billing project
export PROJECT_ID='<PROJECT_ID>'
```
```bash
# Configure the billing project and authenticate
gcloud config set project $PROJECT_ID
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
export GCLOUD_AUTH_CMD='gcloud auth login --project $PROJECT_ID --account $GCLOUD_UACC'
export GCLOUD_UACC='<GOOGLE_CLOUD_USER_ACCOUNT>'
export CATALOGUS_IMAGE=<docker.io/devopsxpro/remarker:latest>
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

### Example output running the Remark CTL
```bash
# Example output structure - IF I run the 
remarkctl auto --scope $SCOPE --kind compute.*Subnetwork

---

cloudxaxasxs.yyyyyy.zzz                         # Cloud Identity AS-IS
├── Infrastructure                              # Folder in the GCP org    
│   └── Development                             # Folder in the GCP org   
│       └── xxxxx-dev-net-spoke-yyyyyy          # Project in the GCP org   
│           └── .ACTIVE                         # Container for Active resources (local Folder)
│               ├
│               (TRUNCATED)
├── Onboarding Host Project
│   └── .ACTIVE
│       ├── .BASE
│       │   └── .subnetwork                     # Configuration base subnetwork attributes inputs. ANY change here imply change on the Terraform managed resource 
│       ├── compute                             # Compute module
│       │   └── Subnetwork.tf                   # Subnetwork TF resource definition
│       ├── compute_module.tf                   # Compute module definition
│       ├── .FAILED_SIGNATURES
│       (TRUNCATED)
└── Sandbox                                     # Folder in the GCP org
    ├── cloud-xxxxxx-labs                       # Project in the GCP org
    │   └── (TRUNCATED)
    ├── devopsxxxsxs-studio                     # Project in the GCP org
    │   └── (TRUNCATED)
    ├── edge-xsxsxsxs-cloud-zone                # Project in the GCP org
    │   └── (TRUNCATED)
    └── genios-xaxasxasx-zzz                    # Project in the GCP org
        └── .ACTIVE
            ├── .BASE
            │   └── .subnetwork
            ├── compute
            │   └── Subnetwork.tf
            ├── compute_module.tf
            ├── .FAILED_SIGNATURES              # File containing signatures of failed terraform resource imports
            ├── providers.tf
            ├── .terraform
            │   ├── modules
            │   └── providers
            ├── .terraform.lock.hcl
            ├── terraform.tfstate
            └── .TF_IMPORT_SIGNATURES           # File containing signatures of terraform resource to import
```

### Example output running *`gcloud beta resource-config bulk-export`*
```bash
gcloud beta resource-config bulk-export --organization=$ORGID \
--resource-format=terraform \
--path "cloudxaxasxs.yyyyyy.zzz" \
--resource-types="ComputeSubnetwork"

----
# The OUTPUT tree is simple BUT it gets complex when you export everything.
cloudxaxasxs.yyyyyy.zzz
└── projects
    ├── cloudlabs-371516
    │   └── ComputeSubnetwork
    │       ├── asia-northeast2
    │       │   └── notino-subnet-1.tf
    │       ├── europe-central2
    │       │   └── subn-euro.tf
    │       ├── europe-west3
    │       │   └── cloud-ids.tf
    │       ├── us-central1
    │       │   ├── notino-subnet.tf
    │       │   └── subn-us.tf
    │       └── us-west2
    │           └── notino-subnet-usw2.tf
    ├── cw-dev-net-spoke-000
    │   └── ComputeSubnetwork
    │       └── europe-west1
    │           └── dev-pf-00.tf
    ├── devops-studio-359213
    │   └── ComputeSubnetwork
    │       ├── europe-southwest1
    │       │   └── euro-svpc-connector.tf
    │       ├── europe-west3
    │       │   ├── mailsubnet-euro.tf
    │       │   └── testing-euro.tf
    │       └── us-central1
    │           ├── mailsubn-us.tf
    │           └── testing-us.tf
    └── genios-371611
        └── ComputeSubnetwork
            └── us-central1
                └── nva-us-central1.tf
```