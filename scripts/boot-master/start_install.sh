#!/bin/bash
source /tmp/icp-bootmaster-scripts/functions.sh

echo "=================================================="
echo "=== Start ICP install"
echo "=== Parameter 1 : $1"
echo "=== Parameter 2 : $2"
echo "=== Parameter 3 : $3"
echo "=================================================="

# Figure out the version
# This will populate $org $repo and $tag
parse_icpversion ${1}
echo "=== registry=${registry:-not specified} org=$org repo=$repo tag=$tag"

tag1=${1}
arch=${2}
verbosity=${3}

if [[ ${tag1:0:1} = '2' ]]
then 
	# version 2.x
	echo "=== ICP 2.x install"
    docker run -e LICENSE=accept -e ANSIBLE_CALLBACK_WHITELIST=profile_tasks,timer --net=host -t -v /opt/ibm/cluster:/installer/cluster ${registry}${registry:+/}${org}/${repo}:${tag1} install ${verbosity} 
else
	# version 3.x, add the -amd64 or -ppc64le to the inception name
	# now check for EE version
	if [[ "$tag1" == *-ee ]]
    then
	    echo "=== ICP 3.x EE install"
        docker run -e LICENSE=accept -e ANSIBLE_CALLBACK_WHITELIST=profile_tasks,timer --net=host -t -v /opt/ibm/cluster:/installer/cluster ${registry}${registry:+/}${org}/${repo}-${arch}:${tag1} install ${verbosity} 
    else
	    echo "=== ICP 3.x CE install"
        docker run -e LICENSE=accept -e ANSIBLE_CALLBACK_WHITELIST=profile_tasks,timer --net=host -t -v /opt/ibm/cluster:/installer/cluster ${registry}${registry:+/}${org}/${repo}:${tag1} install ${verbosity} 
    fi
fi
echo "=================================================="
echo "=== End of Start ICP install"
echo "=================================================="
