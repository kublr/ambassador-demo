# Prepare common env vars to use

export KCP_DOMAIN="${KCP_DOMAIN-"my-kcp.example.com"}"

export KCP_URL="${KCP_URL-"https://${KCP_DOMAIN}"}"
export KCP_USERNAME="${KCP_USERNAME:-"admin"}"
export KCP_PASSWORD="${KCP_PASSWORD:-""}"

export KCP_SPACE="${KCP_SPACE:-"default"}"
export KCP_CLUSTER1="${KCP_CLUSTER1:-"ambassador-demo-us-east-1"}"
export KCP_CLUSTER2="${KCP_CLUSTER2:-"ambassador-demo-eastus"}"

if [ -z "${KCP_URL}" ] ; then
    echo "ERROR: KCP_URL environment variable is not defined"
    return 1
fi

if [ -z "${KCP_PASSWORD}" ] ; then
    echo "ERROR: KCP_PASSWORD environment variable is not defined"
    return 1
fi

export KUBECONFIG="$(pwd)/config-${KCP_CLUSTER1}.yaml:$(pwd)/config-${KCP_CLUSTER2}.yaml"

echo "KCP_DOMAIN=${KCP_DOMAIN}"
echo
echo "KCP_URL=${KCP_URL}"
echo "KCP_USERNAME=${KCP_USERNAME}"
echo "KCP_PASSWORD=***"
echo
echo "KCP_SPACE=${KCP_SPACE}"
echo "KCP_CLUSTER1=${KCP_CLUSTER1}"
echo "KCP_CLUSTER2=${KCP_CLUSTER2}"
echo
