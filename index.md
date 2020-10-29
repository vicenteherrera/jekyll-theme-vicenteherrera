---
layout: default
---

Configuration is loaded from `cloud-connector.yaml` file.

```yaml
rules:
  - secure:
      url: https://secure.sysdig.com
  - git:
      url: https://github.com/sysdiglabs/cloudtrail-rules
  - s3:
      bucket: bucket-name
  - directory:
      path: ./rules
  #- sysdigagent:
  #    ignoreTLSCertErrors: true
  #    collector: "collector.sysdigcloud.com:6443"
ingestors:
  - cloudtrail-sns-sqs:
      queueURL: https://sqs.REGION.amazonaws.com/XXXXX/cloud-connector-demo
      interval: 1m
  - cloudtrail-sns-http:
      url: /cloudtrail
  - cloudtrail-http:
      url: /audit
  - kubernetes-http:
      url: /k8s_audit
      cluster: minikube
  - eks:
      cluster: demo-kube-eks
      interval: 5m
notifiers:
  - console: {}
  - metrics: {}
  - cloudwatch:
      logGroup: cloud-connector-test
      logStream: test
  - securityhub:
      productArn: arn:aws:securityhub:eu-west-1:485156241564:product/485156241564/default
  - sysdigagent:
      ignoreTLSCertErrors: true
      collector: "collector.sysdigcloud.com:6443"
      defaultPolicyID: 30543
```

## Rule providers

You are able to have have different rule providers at the same time. Rules are
loaded in order. In this example rules are loaded and merged from secure, then
git, then a s3 bucket and finally a local directory.

Lists and macros can use the `append` feature to extend the behaviour from
rules loaded before them.

### secure

Loads the rules from the Sysdig Secure backend, using the HTTP API.

Parameters:

 * `url`: the Sysdig Secure prefix, i.e. `collector.sysdigcloud.com:6443`

### git

Loads the rules from a Git repository

If you need to clone a private repository you can pass the credentials here
https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/.

Parameters:

 * `url`: the git repository url, i.e. `https://github.com/sysdiglabs/cloudtrail-rules`
 * `username`: if you are using a private repository this is the git username to clone, is an optional parameter. But if are using a private repository you need to specify a password or GitHub token using the `RULE_PROVIDER_GIT_PASSWORD` environment variable.

### s3

Loads the rules from a S3 bucket. The provider will retrieve all the files
ending in .yaml and .yml recursively.  You may need to specify a path for the
files, so no other files conflict with them.

For example, if the files are saved in "cloud-connector-rules/rules.yaml", the
path should be "cloud-conector-rules".

Parameters:

 * `bucket`: the bucket name where the rules are stored.
 * `path`: the path where rules are loaded from. By default is empty assuming that all rules stored in the s3 bucket will be loaded.

### directory

Loads the set of rules from a directory specified by the `path` parameter.

### sysdigagent

Loads the rules from the Sysdig Secure backend, connecting as a Sysdig Agent.

The `AGENT_KEY` environment variable must be set.

Only policies with the `cloud-connector` tag will be loaded from Sysdig Secure.

Parameters:

 * `collector`: the collector address and port, i.e. `collector.sysdigcloud.com:6443`
 * `ignoreTLSCertErrors`: if set to `true`, ignore TLS certificate verification errors in the collector connection

## Ingestors

### cloudtrail-sns-sqs

Ingest from AWS SNS notifications over SQS on the queue specified by parameter `queueURL`. The Cloud Connector will pull events directly from SQS at specified interval.

Parameters:

* `queueURL`: the queueURL to subscribe.
* `interval`: this is time between each event retrieval. Must be an string parseable as a duration i.e.: "1m", "300s" ...

### cloudtrail-sns-http

Ingest from AWS SNS notifications over HTTP on the path specified by parameter `url`. The Cloud Connector will listen HTTP requests on port 5000.

The SNS notification will trigger retrieving the events from a S3 bucket.

### cloudtrail-http

Receive raw JSON events on the url specified by parameter `url`. The Cloud Connector will listen HTTP requests on port 5000.

### kubernetes-http

Receive Kubernetes Audit Log events on the url specified by parameter `url`. The Cloud Connector will listen HTTP requests on port 5000.

Parameters:

* `cluster`: the cluster name to subscribe

### eks

Retrieve Kubernetes Audit Log events using CloudWatchLogs. The Cloud Connector will pull events directly from CloudWatchLogs at specified interval.

Parameters:

* `cluster`: the cluster name to subscribe. This needs to be same name than the one used in CloudWatchLogs log group name. /aws/eks/**cluster**/cluster
* `interval`: this is time between each event retrieval. Must be an string parseable as a duration i.e.: "1m", "300s" ...

## Notifiers

### console

Simple notifier that writes alerts to the console.

### metrics

This notifier updates a per-alert counter and servers these counters as Prometheus metrics.

### sysdigagent

This notifier will send alerts as Policy Events to Sysdig Secure, establishing a connection as a Sysdig Agent.

Parameters:

 * `collector`: the collector address and port, i.e. `collector.sysdigcloud.com:6443`
 * `ignoreTLSCertErrors`: if set to `true`, ignore TLS certificate verification errors in the collector connection
 * `defaultPolicyID`: the ID of the policy in Sysdig Secure where the alerts should be reported by default, if the rule does not match any Policy

### cloudwatch

Send alerts to AWS CloudWatch.

Environment variable `AWS_REGION` must be set, and AWS credentials must be pre-configured.

Parameters:

 * `logGroup`: logGroup where alerts will be posted
 * `logStream`: stream where alerts will be logged

### securityhub

Send alerts to AWS SecurityHub.

Environment variable `AWS_REGION` must be set, and AWS credentials must be pre-configured.

Parameters:

 * `productArn`: product where findings will be posted, i.e. `arn:aws:securityhub:eu-west-1:485156241564:product/485156241564/default`
