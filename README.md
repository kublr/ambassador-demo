# Kublr, Kubernetes and Ambassador automation demo

## 1. Pre-requisites

* Kublr 1.20.1+
* Kubernetes 1.19+
* AWS and/or Azure account
* `kubectl` 1.19+
* `jq`
* `curl`
* `bash`

You can follow this demo implementing steps manually based on the instructions below, or just by running
the scripts in the `hacks/` directory. The script may also provide useful insight and code templates for
your own automation implementations.

The scripts are written in bash and assume that you have `kubectl`, `jq`, and `curl` tools available on the
command path.


If you are planning to use the scripts, run `. devops-demo/hacks/00-prep-env.sh` first.
Check the script output for the instructions on adjusting it to your configuration, and re-run with correct
parameters and environment variables set.

## 2. Deploy cluster

This project includes 2 cluster specifications that can be used almost without modifications (see below
for the required changes in the specs) to deploy the environment in AWS `us-east-1` region and Azure
`eastus` region.

Use an existing Kublr Control Plane to deploy the cluster(s) using one of the specs in the `env`
directory - `ambassador-demo-us-east-1.yaml`, or `ambassador-demo-eastus.yaml`.

1. The clusters are deployed into `default` Kublr space. You can use a different space, but then you will
   need to update it in the cluster specs you are using.

1. For AWS cluster: create an AWS secret named `aws` in the space.

1. For Azure cluster: create an Azure secret named `azure` and a public SSH key secret named `ssh-pub`
   in the space.

1. Start creating a new cluster in Kublr UI, click "Customize specification" and replace yaml in the dialog
   that opens with one of the provided specifications.

### 2.1. Optional changes

Some of the other parameters that **MAY** be changed:

1. If you want to use a different space in Kublr rather than `default`, change the space in
   [L4](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L4)

1. If you want to use a different AWS region and availability zones:

   1. Change the region in
      [L10](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L10)

   1. Change AZs in
      [L14](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L14) and
      [L48](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L48) and

   1. Change EFS Mount Targets in
      [L19-L24](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L19-L24)

      Here most importantly the designations of target subnets must be changed according to the AZs used.

      Kublr uses AZ numbering convention where AZs ending with `a` (e.g. `us-east-1a`) are numbered `0`, `b` - `1`, `c` - `2` etc.
      Therefore if you want to use, for example, AZs `us-west-2c`, then the Mount Target
      name(s) should be changed to `DevOpsDemoEFSMT2` in the spec line
      [L19](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L19),
      correspondingly, and the subnet name(s) should be `SubnetNodePublic2` in the spec line
      [L24](https://github.com/kublr/ambassador-demo/blob/f/env/ambassador-demo-us-east-1.yaml#L24),
      correspondingly.

Other possible variation points that you may or may not want to modify or experiment with:
- AMIs or Azure images used
- instance types
- the size of the cluster

## 3. Prepare the local environment and download cluster kubeconfig files

When clusters are deployed and functional you can either use Kublr UI to download kubeconfig files locally, or
use the provided scripts.

Set environment variables that specify access to your Kublr Control Plane:

```
export KCP_URL=https://my-kcp.example.com
export KCP_USERNAME=admin
export KCP_PASSWORD='***'

. scripts/00-prep.sh
```

Run script to download the kuubeconfig files:

```
./scripts/15-get-kubeconfig.sh
```

Verify that you can connect to the cluster(s):

```
kubectl --context=ambassador-demo-eastus    get nodes
kubectl --context=ambassador-demo-us-east-1 get nodes
```
