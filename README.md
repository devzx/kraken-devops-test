# Kraken DevOps Test

## Docker-ayes

Please view the included `Dockerfile`

## k8s FTW

Please view the file named `statefulset.yaml`

## All the continuouses

Please view the file named `.travis.yml`

## Script kiddies

Get a list of the current countries green listed for quarentine free entry in to the UK, most of my time was spent on questions 1, 2, 3, and 6

Referenced https://data36.com/web-scraping-tutorial-episode-1-scraping-a-webpage-with-bash/ and a lot of Stack Overflow

`html2text` will need to be installed for the below command to work

```
$ curl -s https://www.gov.uk/guidance/red-amber-and-green-list-rules-for-entering-england \
| html2text \
| sed -n '/^Green list/,$p' \
| sed -n '/Countries on the green watchlist or moving to amber/q;p' \
| tail -n+2 \
| sed -E 's/Green.*|Currently.*|4am.*//g' \
| grep -E -v '^ '

Anguilla
Antarctica/British
Antarctic Territory
Antigua and Barbuda
Austria
Australia
...
```

## Script grown-ups

Referenced https://github.com/anaskhan96/soup it's fairly basic, it prints out all the countries in each list, most of my time was spent on questions 1, 2, 3 and 6.
Relevant files are `go.mod`, `go.sum`, `main.go`, `main_test.go` and the `testdata/` folder

### Test

```
$ go test
```

### Run

```
$ go run main.go
```

## Terraform lovers unite

Relevant files are all located in the `terraform/` folder

### To run the terraform module

```
$ cd terraform
$ terraform init
$ terraform plan --out=plan
$ terraform apply plan

Apply complete! Resources: 6 added, 0 changed, 0 destroyed.

Outputs:
role_arn = "arn:aws:iam::<account_id>:role/prod-ci-role"

```

### To test assuming the role

Using the credentials generated from the prod-ci user

```
$ aws sts get-caller-identity

{
    "UserId": "REDACTED",
    "Account": "REDACTED",
    "Arn": "arn:aws:iam::<account_id>:user/prod-ci"
}
```

Assuming the role

```
$ aws sts assume-role --role-arn <output_from_the_module> --role-session-name test-assume

{
    "Credentials": {
        "AccessKeyId": "REDACTED",
        "SecretAccessKey": "REDACTED",
        "SessionToken": "REDACTED",
        "Expiration": "2021-08-07T23:24:19+00:00"
    },
    "AssumedRoleUser": {
        "AssumedRoleId": "REDACTED:test-assume",
        "Arn": "arn:aws:sts::REDACTED:assumed-role/prod-ci/test-assume"
    }
}
```

Using credentials returned from the above call set the following environment variables

```
export AWS_ACCESS_KEY_ID=<key_from_previous_command>
export AWS_SECRET_ACCESS_KEY<secret_key_from_previous_command>
export AWS_SESSION_TOKEN=<session_token_from_previous_command>
```

Verify assume

```
$ aws sts get-caller-identity
{
    "UserId": "AROAXXL4UC6IDSKIBDYR6:test-assume",
    "Account": "REDACTED",
    "Arn": "arn:aws:sts::REDACTED:assumed-role/prod-ci/test-assume"
}
```
