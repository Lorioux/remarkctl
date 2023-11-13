# Kitabus 

A tool to automate the google cloud resources export into terraform (infrastructure as code) replicating, side-by-side,  the GCloud resource hierarchy. Practitioners should leverage this tool for an accelerated, user-friendly resource configuration export, and repeatable infrastructure updating. Users who are unfamiliar to GCloud should start by navigating the GCloud console to provision resources, in user-friendly manner, then export all resources into terraform.

## How it works (step-by-step)
```bash
# Generate the resources catalogue from the org level
go run . -generate catalogue --scope "organizations/$ORG_ID" --kind ".*Project" --path "."
```
```bash
# Generate the organization resource hierarchy
go run . -generate orgtree --path "."
```
```bash
# Generate the resources' TF templates and import resource
go run . -generate modules --path "."
```

# Set the Github repository credentials
```sh
export GITHUB_TOKEN=$(gh auth token)
export DOCKER_USERNAME="devopsxpro"
export CATALOGUS_IMAGE=docker.io/${DOCKER_USERNAME}/catalogus
```

# Build and tag docker image
```sh
docker build --rm --build-arg GITHUB_TOKEN="$GITHUB_TOKEN" -t ${CATALOGUS_IMAGE}:latest -f Dockerfile
```

# Set the Environment variable to run the catalogus 
```sh
export SCOPE=organizations/$(gcloud organizations list --filter 'display_name ~ cloudw' --format 'value(ID)')
export KIND=".*Instance"
export WORKDIR="./:/dataplane"
```
# Run docker image as interactive command-line interface
```sh
export PROJECT_ID='cloudlabs-371516'
export CATALOGUS_CMD='remarctl generate auto --override --scope $SCOPE --kind $KIND'
export GCLOUD_AUTH_CMD='gcloud auth login --project $PROJECT_ID --account $GCLOUD_UACC'
export GCLOUD_UACC='orious@cloudwork.joonix.net'
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