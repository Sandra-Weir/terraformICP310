#!/bin/bash
#LOGFILE=/tmp/loadimage.log
#exec  > $LOGFILE 2>&1

#"sudo /tmp/icp-bootmaster-scripts/load-image.sh ${var.icp-version} ${var.install_dir}/images/${basename(var.icp_source_file)}  ${var.icp_source_path} ${var.icp_source_file}",

echo "=================================================="
echo "=== Load ICP image for CE, CN, or EE"
echo "=== Parameter 1 (icp-version) : $1"
echo "=== Parameter 2 (full target) : $2"
echo "=== Parameter 3 (image path)  : $3"
echo "=== Parameter 4 (image file)  : $4"
echo "=================================================="

version=$1
target=$2
img_path=$3
img_file=$4

icp_sourcedir=/opt/ibm/cluster/images

if [[ "$3" == */ ]]
then
   img_new=$3$4
else
   img_new=$3/$4
fi

echo "=== Target image location: $target"

if [[ "${img_path}" != "" ]]; then
  echo "=== Image at path: $img_path" 

  # Decide which protocol to use
  if [[ "${img_path:0:3}" == "nfs" ]]; 
  then

    echo "=== img_new  $img_new"
    # Combine the filename and path
    nfs_mount=$(dirname ${img_new:4})

    echo "=== NFS mount $nfs_mount"
    
    image_file="${icp_sourcedir}/${img_file}"
    echo "=== New image_file $image_file"

    echo "=== Target location $sourcedir"
    mkdir -p ${icp_sourcedir}

    # Mount
    sudo mount.nfs $nfs_mount $icp_sourcedir
  
  elif [[ "${image_location:0:4}" == "http" ]]; then
    # Figure out what we should name the file
    # filename="ibm-cloud-private-x86_64-${tag%-ee}.tar.gz"
    mkdir -p ${sourcedir}
    wget --continue -O ${sourcedir}/${filename} "${image_location#http:}"
    image_file="${sourcedir}/${filename}"
  fi
fi

source /tmp/icp-bootmaster-scripts/functions.sh
parse_icpversion ${version}
echo "registry=${registry:-not specified} org=$org repo=$repo tag=$tag"


echo "=== image_file ::  $image_file"
if [[ "$image_file" != "" ]]; then
  echo "=== Untar the EE image intall file"
  tar xf ${image_file} -O | sudo docker load
else
  echo "=== Going the CE route"
  # If we don't have an image locally we'll pull from docker registry
  if [[ -z $(docker images -q ${registry}${registry:+/}${org}/${repo}:${tag}) ]]; then
    # If this is a private registry we may need to log in
    if [[ ! -z "$username" ]]; then
      docker login -u ${username} -p ${password} ${registry}
    fi 
    # ${registry}${registry:+/} adds <registry>/ only if registry is specified
    docker pull ${registry}${registry:+/}${org}/${repo}:${tag}
  fi
fi


echo "=================================================="
echo "=== End of Load ICP image for CE, CN, or EE"
echo "=================================================="
