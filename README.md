# Google Cloud Resources Remarker CTL (WIP)

Remark CTL is a tool to automate the google cloud resources [bulk-]export into terraform (infrastructure as code). The tool helps reproduce side-by-side  the Google Cloud resource hierarchy. Practitioners could leverage this tool for an accelerated, repeatable, automateable and manageable resource configurations export, and infrastructure updating - while ensuring IaC practice for any Terraform Supported Resources, either by terraform provider google (TPG) or google-beta (TPB). 

## Core capabilities
* Natively integrated with Terraform Plug-in Framework (TPF) only (at least for now)
* Natively integrated with Terraform google and google-beta providers 
* Natively integrated with Google Cloud SDK
* Automateable covering all TPG and TPB supported resources types (at least the stable versions)

## Core features
* Generate organization resources inventory (a.k.a Catalogus)
* Generate organization resource hierarchy  (a.k.a Organization tree)
* Generate resources's Terraform configurations template
* Generate resource's state as Terraform states (e.g. Import organization scope resource states)

|**Attention:**|
|---|
|When terraform imports resource the states are maintained at the scope of the container node (e.g. org., folder, project) for a specific Google Cloud Resource. For instance, if a project is under the organization/folder node, then its state will be kept in the .META (local folder) under the respective container (directory in the local File System). Similarly, a compute instance state is kept at project level in the .ACTIVE (local folder).|

## Common use case
* Google Cloud Users, whom are unfamiliar to Google Cloud terraform providers (a.k.a TPG and TPB), may want to start by navigating the Google Cloud Console to provision resources, to accelerate the learn pace and flatten the learning curve, then export all resources into terraform.
* Google Cloud Users, whom possess multiple unmanaged resources as result of the innovation freedom given to their cloud team members, may want to have a central enterprise-wide resources state and inventory at IT leading level.
* Google Cloud Users, whom possess multiple unmanaged resources, may want to have a central enterprise-wide resources state and inventory before adopting a robust IaC frameworks (such as fabric-fast).
* Google Cloud Users, whom want to use an automatable, and user-friendly tool as an alternative of the existing `gcloud beta resource-config` *limited (at least for now) to:*
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
* (WIP) Still not support a few of terraform google providers supported resources and a couple of resource import `ID` patterns autonomousty/programmatically. For instance, it will display some import error for a couple of resources, as its `ID pattern` parsing differ from the majority of `TPG and TPB resource ID patterns`.


## How it works (step-by-step)
There are two ways you can use this tool, either by cloning this repository and requesting access to the core source code in the submodules - ``"./kitabus"``, or by executing the pre-build docker image. 
* Recommendation: executing through the docker image

### Pre-requisites
* **Service Account**. Prepare a service account for impersonation and grant the rigth permissions (a.k.a least-privileges).
    1. `roles/resourcemanager.organizationViewer`
    1. `roles/cloudasset.viewer`
    1. (*Other*) `roles/ANY_ROLE_AS_REQUIRED_WHEN_RUNNING_THIS_TOOL_AT_THE_FIRST_TIME`
    1. **IF** you want to update a *`Terraform`* managed resource, please ensure your have the right permissions.
* **(Optional) Terraform executable**. *IF* you intend to run from the source code, please ensure you have the latest `terraform binary` installed.
* **Google Cloud SDK**. *IF* you are running locally please install the google cloud sdk and ensure you are authenticated. Also, you will need to config your `gcloud cli` with the right billing project.
* **Enable Cloud Asset API**. Run `gcloud services enable cloudasset.googleapis.com`
* **(Optional) Go executable**. *IF* you intend to run from this source code.
* **Docker executable**. *IF* you are running the pre-build docker image.
* **(Optional) Repository access token**. *IF* you intend to clone and run from this source code locally, `you will need to request the access token to a private github/lorioux/kitabus repository (at least for now)`. * **NOT Applied IF** * you run the pre-build docker image.


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

### Example using pre-build docker image
```bash
# Set the Environment variable to run the REMARKER 
export SCOPE="organizations/$(gcloud organizations list --filter 'display_name ~ xxxx' --format 'value(ID)')"
export KIND=".*Project,.*Subnetwork,compute.*Route" # (Opt) set a filter (use preffix .*) or unset it to retrieve everything. 
export WORKDIR="./:/dataplane:rw"                   # map the current dir into container work dir 
```
```bash
# Pull the docker image
docker pull docker.io/devopsxpro/remarker:latest
```
```bash
export REMARKER_CMD=docker run -v $WORKDIR -u 0 --rm $REMARKER_IMAGE  # OR
```
```bash
export REMARK_CMD="auto"                            # run it in auto mode
export IDENTITY="<domain>"                          # (Opt) CX Cloud Identity domain
export REMARKER_IMAGE="devopsxpro/remarker:latest"     
```


```bash
# Run 
docker run --rm -v $WORKDIR $REMARKER_IMAGE $REMARK_CMD --scope $SCOPE --kind $KIND -I $IDENTITY
```

## SIDE-BY-SIDE SAMPLE OUTPUTS AT A GLANCE
The outcome from the comparison is:
```bash
1) running remarkctl in auto mode you will get a simple directory three AS-IS your resource hierarchy and states are kept at resource parent node level. 
However, as per this version a few of  TF imports are not supported through remarkctl auto mode. Also some TF resource type templates are still not supported.
The process will run until the end and provide a list of failed TF import that you can handle manually. Example
|---Organization Domain
|   |---Folder Name
|       |---Project Name
|           |--Service Type (e.g. Compute)
|              |---[Subnework.tf, VPC.tf, Route.tf, ...]
|           |--Terraform States

2) running gcloud beta resource-config bulk-export, you will have: 
    a) multiple layers of resource IDs and then you need to figureout in which layer the terraform_import*.sh. will be appointing to run terraform import ..., b) do some workarounds.
```
### Running `Remark CTL`
```bash
# Example output structure - IF I run
# docker run --rm -v $WORKDIR $REMARKER_IMAGE $REMARK_CMD --scope $SCOPE --kind $KIND -I $IDENTITY
#OR
# remarkctl auto --scope $SCOPE --kind compute.*Subnetwork -I $IDENTITY
---

cloudxaxasxs.yyyyyy.zzz                         # Cloud Identity domain AS-IS
├── Infrastructure                              # Folder in the GCP org    
│   └── Development                             # Folder in the GCP org   
│       └── xxxxx-dev-net-spoke-yyyyyy          # Project in the GCP org   
│           └── .ACTIVE                         # Container for Active resources (local Folder)
│               ├
│               (TRUNCATED)
├── Onboarding Host Project
│   └── .ACTIVE
│       ├── .BASE                               # Container for resource specific base inputs
│       │   └── .subnetwork                     # Subnetwork resources' inputs. ANY change here force change on the respective resource.
│       ├── compute                             # Compute module
│       │   └── Subnetwork.tf                   # Subnetwork TF resource definition
│       ├── compute_module.tf                   # Compute resources module definition
│       (TRUNCATED)
└── Sandbox                                     # Folder in the GCP org
    ├── cloud-xxxxxx-labs                       # Project in the GCP org
    │   └── (TRUNCATED)
    ├── devopsxxxsxs-xxxxxxxxx                  # Project in the GCP org
    │   └── (TRUNCATED)
    ├── edge-xsxsxsxs-xxxxxx-zone               # Project in the GCP org
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
            ├── terraform.tfstate               # Terraform state file
            └── .TF_IMPORT_SIGNATURES           # File containing signatures of terraform resource to import
```

### Running *`gcloud beta resource-config bulk-export`*
```bash
gcloud beta resource-config bulk-export --organization=$ORGID \
--resource-format=terraform \
--path "cloudxaxasxs.yyyyyy.zzz" \
--resource-types="ComputeSubnetwork"

----
# The OUTPUT tree is simple, in this context, BUT it gets complex requiring workarounds when exporting everything at the organization scope.
cloudxaxasxs.yyyyyy.zzz
└── projects
    ├── cloudxxxxxxxxxxxxxxxxxxxxxxxxxxx
    │   └── ComputeSubnetwork
    │       ├── asia-northeast2
    │       │   └── xxxxxx-subnetxxxxx.tf
    │       ├── europe-central2
    │       │   └── subn-euro.tf
    │       ├── europe-west3
    │       │   └── cloud-ids.tf
    │       ├── us-central1
    │       │   ├── xxxxxxx-subnet.tf
    │       │   └── subn-us.tf
    │       └── us-west2
    │           └── vvvvvvvvv-subnet-usw2.tf
    ├── cw-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    │   └── ComputeSubnetwork
    │       └── europe-west1
    │           └── dev-pf-00.tf
    ├── devopsxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    │   └── ComputeSubnetwork
    │       ├── europe-southwest1
    │       │   └── euro-xxxxxxxxxxxx.tf
    │       ├── europe-west3
    │       │   ├── mailsubnet-euro.tf
    │       │   └── testing-euro.tf
    │       └── us-central1
    │           ├── mailxxxxxx-us.tf
    │           └── testing-us.tf
    └── geniosxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        └── ComputeSubnetwork
            └── us-central1
                └── nva-us-central1.tf
```