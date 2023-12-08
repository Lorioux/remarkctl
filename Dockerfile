ARG GITHUB_REPO_PATH=kitabus
ARG GITHUB_USERNAME=lorioux
ARG GITHUB_TOKEN

FROM golang:1.20.5-alpine AS builder
WORKDIR /build
COPY . .
RUN apk --no-cache update \ 
&& apk add git \ 
&& git config --global \
url."https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_REPO_PATH}".insteadOf \
"https://github.com/${GITHUB_USERNAME}/${GITHUB_REPO_PATH}" \
&& go mod tidy && go mod vendor
RUN --mount=type=cache,target=/root/.cache/go-build \
CGO_ENABLED=0 go build -a -v -installsuffix cgo -o remarkctl .

FROM google/cloud-sdk:alpine AS sdk
RUN export SDK="/google-cloud-sdk" && mkdir -p /sdk/bin \
&& cp $SDK/bin/gcloud $SDK/bin/gcloud-crc32c $SDK/bin/git-credential-gcloud.sh /sdk/bin/ \
&& cp -r $SDK/lib $SDK/data $SDK/properties /sdk \
&& rm -fr $SDK/* \
&& cp -rf /sdk/* /google-cloud-sdk/ && rm -fr /sdk


FROM hashicorp/terraform:latest as terra


FROM alpine:latest
COPY --from=builder /build/remarkctl /bin
# COPY --from=builder /build/scripts/entrypoint.sh /bin
COPY --from=sdk /google-cloud-sdk/bin /usr/bin
COPY --from=sdk /google-cloud-sdk/lib /usr/lib
# COPY --from=sdk /google-cloud-sdk/data /usr/data
COPY --from=terra /bin/terraform /usr/bin
RUN apk --no-cache update \
&& apk --no-cache add ca-certificates python3 
# \
    
VOLUME ["/root/.config/gcloud/"]
VOLUME ["~/.config/gcloud/"]
WORKDIR /dataplane

ENTRYPOINT ["/bin/remarkctl"]
# CMD [ "remarkctl" ]
