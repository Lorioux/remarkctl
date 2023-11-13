# Remark CTL 

A tool to automate the google cloud resources [bulk-]export into terraform (infrastructure as code). The tool helps replicating, side-by-side,  the Google Cloud resource hierarchy. Practitioners should leverage this tool for an accelerated, user-friendly resource configuration export, and repeatable infrastructure updating. Users who are unfamiliar to Google Cloud should start by navigating the GCloud console to provision resources, in user-friendly manner, then export all resources into terraform. 

## How it works (step-by-step)
There are two way you can use this tool, either by cloning this repository to execute uncompiled Go source code. 
### Example running from source code 

```bash
# Print the usage message
go run . help
```
```bash
# Set the required environment varialbles
# This define the scope
export SCOPE=<organizations/GOOGLE_CLOUD_ORG_ID>|<folders/FOLDER_ID>|<projects/PROJECT_ID>

# IF both set as comma-separated list (e.g. "<compute.*, iam.*Role>")
export KIND=<GOOGLE_CLOUD_SERVICE_TYPE OR GOOGLE_CLOUD_RESOURCE_TYPE OR BOTH>

# The output dir (default: current working dir)
export WORKDIR="<PATH_FOR_OUTPUTS>"
```
```bash
# Generate the resources catalogue from the org level
go run . -generate catalogue --scope "organizations/$ORG_ID" --kind ".*Project" --workdir "."
```
```bash
# Generate the organization resource hierarchy
go run . -generate orgtree --workdir "."
```
```bash
# Generate the resources' TF templates and import resource
go run . -generate modules --workdir "."
```

### Example using a pre-build docker image

```bash
# Set the Environment variable to run the catalogus 
export SCOPE="organizations/$(gcloud organizations list --filter 'display_name ~ cloudw' --format 'value(ID)')"
export KIND=".*Instance"
export WORKDIR="./:/dataplane"
```

```bash
# Run docker image as interactive command-line interface
export PROJECT_ID='<PROJECT_ID>'
export CATALOGUS_CMD='remarctl generate auto --override --scope $SCOPE --kind $KIND'
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

```sh
eval $GCLOUD_AUTH_CMD
```