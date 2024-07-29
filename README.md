# Ontwikkelingsbedrywighede

## Background
Ontwikkelingsbedrywighede is Afrikaans which means Development Operations (DevOps), I randomly chose Afrikaans, the purpose only to make the repository name unique but also to tell others that I'm learning DevOps, even though none of my followers understand it.

## Setup

### Prerequisites
- Terraform (1.9.2)
- AWS CLI (2.17.11)
- Python (3.8)
- Docker (27.0.3)

### Steps
#### Build and Run Dockerfile in Local
```sh
# Build 
docker build -t <image-name>:<tag> --no-cache --progress=plain . 2>&1 | tee docker-build.log

# Run and write log to a file
docker run --name <container-name> -d <image-name>:<tag> && docker logs -f <container-name> > docker-output.log 2>&1
```
Here is the `docker-output.log` snippet:
```log
2024-07-26T15:57:03Z Loading addresses from DNS seed dnsseed.koin-project.com
2024-07-26T15:57:13Z Loading addresses from DNS seed seed-a.litecoin.loshan.co.uk
2024-07-26T15:57:13Z Loading addresses from DNS seed dnsseed.thrasher.io
2024-07-26T15:57:23Z Loading addresses from DNS seed dnsseed.litecointools.com
2024-07-26T15:57:23Z Loading addresses from DNS seed dnsseed.litecoinpool.org
2024-07-26T15:57:23Z 47 addresses found from DNS seeds
2024-07-26T15:57:23Z dnsseed thread exit
2024-07-26T15:57:23Z New outbound peer connected: version: 70017, blocks=2727152, peer=0 (full-relay)
2024-07-26T15:57:24Z Synchronizing blockheaders, height: 2000 (~0.07%)
2024-07-26T15:57:34Z New outbound peer connected: version: 70017, blocks=2727152, peer=1 (full-relay)
2024-07-26T15:57:35Z New outbound peer connected: version: 70017, blocks=2727152, peer=2 (full-relay)
2024-07-26T15:57:36Z Synchronizing blockheaders, height: 3999 (~0.15%)
2024-07-26T15:57:37Z Synchronizing blockheaders, height: 5999 (~0.22%)
```

Read more in the `docker-output.log` file, or you can just generate it yourself by following the steps above.

#### Dockerfile CI (GitHub Actions)
Here's a detailed breakdown and documentation for the provided GitHub Actions (`dockerfile-ci.yml`) workflow setup. This CI/CD pipeline is designed to build and push a Docker image to Docker Hub when a pull request is made to the main branch.

##### Trigger
This workflow triggers on pull requests targeting the main branch:
```yaml
on:
  pull_request:
    branches: [main]
    paths:
      - 'Dockerfile'
```
##### Jobs
1. Login to Docker Hub
This step uses the `docker/login-action@v3` action to log into Docker Hub using credentials stored in GitHub Secrets and Variables.
```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ vars.DOCKERHUB_USERNAME }}
    password: ${{ secrets.DOCKERHUB_TOKEN }}
```
2. This step sets up Docker Buildx, which allows for advanced build features like multi-platform builds.
```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3
```
3. This step extracts a tag from the pull request description using a regular expression. If no tag is found, it defaults to `latest`.

```yaml
- name: Extract tag from PR description
  run: |
    echo "PR_DESCRIPTION=${{ github.event.pull_request.body }}" >> $GITHUB_ENV
    TAG=$(echo "${{ github.event.pull_request.body }}" | grep -oP '(?<=Tag: )\S+')
    echo "Extracting tag from PR description."
    if [ -z "$TAG" ]; then
    echo "Tag not found in PR description, defaulting to 'latest'."
    TAG="latest"
    fi
    echo "Using tag ${TAG}."
    echo "TAG=${TAG}" >> $GITHUB_ENV
```
4. This step builds the Docker image and pushes it to Docker Hub using the `docker/build-push-action@v6` action. The tag for the image is set based on the value extracted from the PR description.
```yaml
- name: Build and push
  uses: docker/build-push-action@v6
  with:
    push: true
    tags: ${{ vars.DOCKERHUB_USERNAME }}/litecoin:${{ env.TAG }}
```

#### Terraform
##### How to Build the Infrastructure?
Kindly check the custom S3 module in **terraform/modules/s3-bucket** first.
1. Ensure you already have the AWS secret key and access key in your local directory.
2. Create a profile in your AWS config and credentials file then adjust the variable `aws_profile` and other variables as you need in `variables.tf`.
3. Navigate to terraform directory.
4. Run `terraform init` to initialize all terraform resources.
5. Run `terraform plan -out=plan.tfplan` to create an execution plan.
6. Run `terraform apply "plan.tfplan"` to apply the execution plan.
7. Run `terraform show` to inspect the current state.
##### How to Test the Lambda Function?
1. After building the infrastructure, create two folders in the bucket: `source` and `destination`.
2. Upload any file (e.g. the Dockerfile in this repository) to the `source` folder in the bucket.
3. The S3 bucket notifications will trigger the lambda function, and then the lambda function will move the file from the `source` to the `destination` directory within the bucket.
4. Ah, there you go!

## Learning References
- https://docs.docker.com/build/building/best-practices/
- https://www.speedguide.net/port.php?port=9333
- https://security.stackexchange.com/questions/1687/
- https://medium.com/@arif.rahman.rhm/choosing-the-right-python-docker-image-slim-buster-vs-alpine-vs-slim-bullseye-5586bac8b4c9
- https://docs.docker.com/build/ci/github-actions/
- https://developer.hashicorp.com/terraform/language/modules/develop
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://www.reddit.com/r/Terraform/comments/zmrpwj/usage_of_this_in_terraform/
