# Sarkaria Infra

Run the following command to bring up a k3s cluster on the civo platform with nginx ingress controller, cert manager, metrics server, civo cluster autoscaler and argo cd preinstalled.

You must have access to aws and be able to interact with the s3 bucket for terraform state.

The ip address is for a firewall rule which restricts access to the k3s api server to only you're address.

```bash
TF_VAR_CLUSTER_NAME=<cluster-name> TF_VAR_MY_IP_ADDRESS=<ip-address> TF_VAR_CIVO_API_KEY=<api-key> terraform apply
```

## Setting up Argo CD

There are a few steps we need to follow before we can access argo cd correctly [see here](https://argo-cd.readthedocs.io/en/stable/operator-manual/ingress/#option-2-multiple-ingress-objects-and-hosts). Edit the config map and apply the yaml manifests in [.kubernetes/argocd](./.kubernetes/argocd/)

## Next steps

You're cluster is ready to host apps. Add your secrets and apply your manifests. Hook your repos up to argo cd via the ui and you will have a nice deployment pipeline.
