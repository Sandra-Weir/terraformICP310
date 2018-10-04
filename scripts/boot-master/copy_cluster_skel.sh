#!/bin/bash
#LOGFILE=/tmp/copyclusterskel.log
#exec  > $LOGFILE 2>&1
echo "=================================================="
echo "=== Create boot node cluster directory"
echo "=== Parameter 1 (tag) : $1"
echo "=== Parameter 2 (arch): $2"
echo "=================================================="

tag1=$1
arch=$2

source /tmp/icp-bootmaster-scripts/functions.sh

# Figure out the version
# This will populate $org $repo and $tag
parse_icpversion ${1}
echo "org=$org repo=$repo tag=$tag"

# inception arch added for 3.x support, not used in 2.x

if [[ ${tag1:0:1} = '2' ]]
then 
	# version 2.x
	echo "2.x - ${org}/${repo}:${tag1} "
	docker run -e LICENSE=accept -v /opt/ibm:/data ${org}/${repo}:${tag1} cp -r cluster /data
else
	# version 3.x, add the -amd64 or -ppc64le to the inception name
	# now check for EE version
	if [[ "$tag1" == *-ee ]]
    then
		echo "3.x EE - ${org}/${repo}-${arch}:${tag1}"
		docker run -e LICENSE=accept -v /opt/ibm:/data ${org}/${repo}-${arch}:${tag1} cp -r cluster /data
    else
        echo "3.x CE - ${org}/${repo}-${arch}:${tag1}"
		docker run -e LICENSE=accept -v /opt/ibm:/data ${org}/${repo}:${tag1} cp -r cluster /data

    fi
fi

echo "=================================================="
echo "=== End of Create boot node cluster directory"
echo "=================================================="

