# Generate a new key if this is required
resource "tls_private_key" "icpkey" {
  count     = "${var.generate_key ? 1 : 0}"
  algorithm = "RSA"

  provisioner "local-exec" {
    command = "cat > privatekey.pem <<EOL\n${tls_private_key.icpkey.private_key_pem}\nEOL"
  }
}

## Actions that has to be taken on all nodes in the cluster
resource "null_resource" "icp-cluster" {
  count = "${var.cluster_size}"

  connection {
    host                = "${element(var.icp-ips, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  # Validate we can do passwordless sudo in case we are not root
  provisioner "remote-exec" {
    inline = [
      "sudo -n echo Test connection. It works.",
    ]
  }

  provisioner "file" {
    content     = "${var.generate_key ? tls_private_key.icpkey.public_key_openssh : file(var.icp_pub_keyfile)}"
    destination = "/tmp/icpkey"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/icp-common-scripts",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/common/"
    destination = "/tmp/icp-common-scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ${var.install_dir}/images; sudo chown -R ${var.ssh_user} ${var.install_dir}",
      "mkdir -p ~/.ssh",
      "cat /tmp/icpkey >> ~/.ssh/authorized_keys",
      "chmod a+x /tmp/icp-common-scripts/*",
      "/tmp/icp-common-scripts/prereqs.sh",
      "/tmp/icp-common-scripts/version-specific.sh ${var.icp-version}",
      "/tmp/icp-common-scripts/docker-user.sh",
      "sudo /tmp/icp-common-scripts/download_installer.sh ${var.icp_source_server} ${var.icp_source_user} ${var.icp_source_password} ${var.image_file} ${var.install_dir}/images/${basename(var.image_file)}",
    ]
  }
}

# Proxy Nodes
resource "null_resource" "icp-proxy" {
  count = "${var.proxy_size}"

  connection {
    host                = "${element(var.icp-proxy, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.boot-node}"
    bastion_user        = "${var.ssh_user}"
    bastion_private_key = "${var.ssh_key}"
  }

  # Validate we can do passwordless sudo in case we are not root
  provisioner "remote-exec" {
    inline = [
      "sudo -n echo Test connection. It works.",
    ]
  }

  provisioner "file" {
    content     = "${var.generate_key ? tls_private_key.icpkey.public_key_openssh : file(var.icp_pub_keyfile)}"
    destination = "/tmp/icpkey"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/icp-common-scripts",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/common/"
    destination = "/tmp/icp-common-scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ${var.install_dir}/images; sudo chown -R ${var.ssh_user} ${var.install_dir}",
      "mkdir -p ~/.ssh",
      "cat /tmp/icpkey >> ~/.ssh/authorized_keys",
      "chmod a+x /tmp/icp-common-scripts/*",
      "/tmp/icp-common-scripts/prereqs.sh",
      "/tmp/icp-common-scripts/version-specific.sh ${var.icp-version}",
      "/tmp/icp-common-scripts/docker-user.sh",
      "sudo /tmp/icp-common-scripts/download_installer.sh ${var.icp_source_server} ${var.icp_source_user} ${var.icp_source_password} ${var.image_file} ${var.install_dir}/images/${basename(var.image_file)}",
    ]
  }
}

# Management Nodes
resource "null_resource" "icp-management" {
  count = "${var.management_size}"

  connection {
    host                = "${element(var.icp-management, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.boot-node}"
    bastion_user        = "${var.ssh_user}"
    bastion_private_key = "${var.ssh_key}"
  }

  # Validate we can do passwordless sudo in case we are not root
  provisioner "remote-exec" {
    inline = [
      "sudo -n echo Test connection. It works.",
    ]
  }

  provisioner "file" {
    content     = "${var.generate_key ? tls_private_key.icpkey.public_key_openssh : file(var.icp_pub_keyfile)}"
    destination = "/tmp/icpkey"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/icp-common-scripts",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/common/"
    destination = "/tmp/icp-common-scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ${var.install_dir}/images; sudo chown -R ${var.ssh_user} ${var.install_dir}",
      "mkdir -p ~/.ssh",
      "cat /tmp/icpkey >> ~/.ssh/authorized_keys",
      "chmod a+x /tmp/icp-common-scripts/*",
      "/tmp/icp-common-scripts/prereqs.sh",
      "/tmp/icp-common-scripts/version-specific.sh ${var.icp-version}",
      "/tmp/icp-common-scripts/docker-user.sh",
      "sudo /tmp/icp-common-scripts/download_installer.sh ${var.icp_source_server} ${var.icp_source_user} ${var.icp_source_password} ${var.image_file} ${var.install_dir}/images/${basename(var.image_file)}",
    ]
  }
}

# VA Nodes
resource "null_resource" "icp-va" {
  count = "${var.va_size}"

  connection {
    host                = "${element(var.icp-va, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.boot-node}"
    bastion_user        = "${var.ssh_user}"
    bastion_private_key = "${var.ssh_key}"
  }

  # Validate we can do passwordless sudo in case we are not root
  provisioner "remote-exec" {
    inline = [
      "sudo -n echo Test connection. It works.",
    ]
  }

  provisioner "file" {
    content     = "${var.generate_key ? tls_private_key.icpkey.public_key_openssh : file(var.icp_pub_keyfile)}"
    destination = "/tmp/icpkey"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/icp-common-scripts",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/common/"
    destination = "/tmp/icp-common-scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ${var.install_dir}/images; sudo chown -R ${var.ssh_user} ${var.install_dir}",
      "mkdir -p ~/.ssh",
      "cat /tmp/icpkey >> ~/.ssh/authorized_keys",
      "chmod a+x /tmp/icp-common-scripts/*",
      "/tmp/icp-common-scripts/prereqs.sh",
      "/tmp/icp-common-scripts/version-specific.sh ${var.icp-version}",
      "/tmp/icp-common-scripts/docker-user.sh",
      "sudo /tmp/icp-common-scripts/download_installer.sh ${var.icp_source_server} ${var.icp_source_user} ${var.icp_source_password} ${var.image_file} ${var.install_dir}/images/${basename(var.image_file)}",
    ]
  }
}

# Worker Nodes
resource "null_resource" "icp-worker" {
  count = "${var.worker_size}"

  connection {
    host                = "${element(var.icp-worker, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.boot-node}"
    bastion_user        = "${var.ssh_user}"
    bastion_private_key = "${var.ssh_key}"
  }

  # Validate we can do passwordless sudo in case we are not root
  provisioner "remote-exec" {
    inline = [
      "sudo -n echo Test connection. It works.",
    ]
  }

  provisioner "file" {
    content     = "${var.generate_key ? tls_private_key.icpkey.public_key_openssh : file(var.icp_pub_keyfile)}"
    destination = "/tmp/icpkey"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/icp-common-scripts",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/common/"
    destination = "/tmp/icp-common-scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p ${var.install_dir}/images; sudo chown -R ${var.ssh_user} ${var.install_dir}",
      "mkdir -p ~/.ssh",
      "cat /tmp/icpkey >> ~/.ssh/authorized_keys",
      "chmod a+x /tmp/icp-common-scripts/*",
      "/tmp/icp-common-scripts/prereqs.sh",
      "/tmp/icp-common-scripts/version-specific.sh ${var.icp-version}",
      "/tmp/icp-common-scripts/docker-user.sh",
      "sudo /tmp/icp-common-scripts/download_installer.sh ${var.icp_source_server} ${var.icp_source_user} ${var.icp_source_password} ${var.image_file} ${var.install_dir}/images/${basename(var.image_file)}",
    ]
  }
}

######################################################
## Actions that needs to be taken on boot master only
######################################################
resource "null_resource" "icp-boot" {
  depends_on = ["null_resource.icp-cluster", "null_resource.icp-proxy", "null_resource.icp-management", "null_resource.icp-va", "null_resource.icp-worker"]

  # The first master is always the boot master where we run provisioning jobs from
  connection {
    host                = "${var.boot-node}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/icp-bootmaster-scripts",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/boot-master/"
    destination = "/tmp/icp-bootmaster-scripts"
  }

  # store config yaml if it was specified
  provisioner "file" {
    source = "${var.icp_config_file}"
    destination = "/tmp/config.yaml"
  }

  # JSON dump the contents of icp_configuration items
  provisioner "file" {
    content     = "${jsonencode(var.icp_configuration)}"
    destination = "/tmp/items-config.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/items-config.yaml",
      "chmod a+x /tmp/icp-bootmaster-scripts/*.sh",
      "sudo /tmp/icp-bootmaster-scripts/load-image.sh ${var.icp-version} ${var.install_dir}/images/${basename(var.icp_source_file)}  ${var.icp_source_path} ${var.icp_source_file}",
      "sudo mkdir -p ${var.install_dir}",
      "sudo chown ${var.ssh_user} ${var.install_dir}",
      "/tmp/icp-bootmaster-scripts/copy_cluster_skel.sh ${var.icp-version} ${var.icp-arch}",
      "sudo chown -R ${var.ssh_user} ${var.install_dir}/*",
      "chmod 600 ${var.install_dir}/ssh_key",
      "python /tmp/icp-bootmaster-scripts/load-config.py ${var.config_strategy}",
    ]
  }
  # Copy the provided or generated private key - order must be after remote exec code above
  provisioner "file" {
    content     = "${var.generate_key ? tls_private_key.icpkey.private_key_pem : file(var.icp_priv_keyfile)}"
    destination = "${var.install_dir}/ssh_key"
  }

  provisioner "file" {
    content     = "${join(",", var.icp-master)}"
    destination = "${var.install_dir}/masterlist.txt"
  }
  
  provisioner "remote-exec" {
    inline = [
      "cat ${var.install_dir}/masterlist.txt",
    ]
  }  
  
  provisioner "remote-exec" {
    inline = [
      "echo -n ${join(",", var.icp-worker)} > ${var.install_dir}/workerlist.txt",
      "cat ${var.install_dir}/workerlist.txt",
      "echo -n ${join(",", var.icp-proxy)} > ${var.install_dir}/proxylist.txt",
      "cat ${var.install_dir}/proxylist.txt",
      "echo -n ${join(",", var.icp-management)} > ${var.install_dir}/managementlist.txt",
      "cat ${var.install_dir}/managementlist.txt",
      "echo -n ${join(",", var.icp-va)} > ${var.install_dir}/valist.txt",
      "cat ${var.install_dir}/valist.txt",
      "/tmp/icp-bootmaster-scripts/generate_hostsfiles.sh",
      "/tmp/icp-bootmaster-scripts/start_install.sh ${var.icp-version} ${var.icp-arch}",
    ]
  }
}

resource "null_resource" "icp-proxy-scaler" {
  count      = "${var.proxy_size > 0 ? 1 : 0}"

  depends_on = ["null_resource.icp-proxy", "null_resource.icp-boot"]

  triggers {
    nodes = "${join(",", var.icp-proxy)}"
  }

  connection {
    host                = "${var.boot-node}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "file" {
    content     = "${join(",", var.icp-proxy)}"
    destination = "/tmp/proxylist.txt"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/boot-master/scalenodes.sh"
    destination = "/tmp/icp-bootmaster-scripts/scalenodes.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /tmp/icp-bootmaster-scripts/scalenodes.sh",
      "/tmp/icp-bootmaster-scripts/scalenodes.sh ${var.icp-version} proxy",
    ]
  }
}

resource "null_resource" "icp-management-scaler" {
  count      = "${var.management_size > 0 ? 1 : 0}"

  depends_on = ["null_resource.icp-management", "null_resource.icp-boot"]

  triggers {
    nodes = "${join(",", var.icp-management)}"
  }

  connection {
    host                = "${var.boot-node}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  # provisioner "file" {
  #   content     = "${join(",", var.icp-management)}"
  #   destination = "/tmp/managementlist.txt"
  # }

  provisioner "file" {
    source      = "${path.module}/scripts/boot-master/scalenodes.sh"
    destination = "/tmp/icp-bootmaster-scripts/scalenodes.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "echo -n ${join(",", var.icp-management)} > /tmp/managementlist.txt",
      "chmod a+x /tmp/icp-bootmaster-scripts/scalenodes.sh",
      "/tmp/icp-bootmaster-scripts/scalenodes.sh ${var.icp-version} management",
    ]
  }
}

resource "null_resource" "icp-worker-scaler" {
  count      = "${var.worker_size > 0 ? 1 : 0}"

  depends_on = ["null_resource.icp-worker", "null_resource.icp-boot"]

  triggers {
    nodes = "${join(",", var.icp-worker)}"
  }

  connection {
    host                = "${var.boot-node}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "file" {
    content     = "${join(",", var.icp-worker)}"
    destination = "/tmp/workerlist.txt"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/boot-master/scalenodes.sh"
    destination = "/tmp/icp-bootmaster-scripts/scalenodes.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /tmp/icp-bootmaster-scripts/scalenodes.sh",
      "/tmp/icp-bootmaster-scripts/scalenodes.sh ${var.icp-version} worker",
    ]
  }
}

resource "tls_private_key" "heketikey" {
  count     = "${var.install_gluster ? 1 : 0}"
  #count      = "${var.gluster_size > 0 ? 1 : 0}"
  algorithm = "RSA"

  provisioner "local-exec" {
    command = "cat > heketi_key <<EOL\n${tls_private_key.heketikey.private_key_pem}\nEOL"
  }
}


resource "null_resource" "create_gluster" {
  count = "${var.install_gluster ? var.gluster_size : 0}"
  #count      = "${var.gluster_size > 0 ? var.gluster_size : 0}"

  #depends_on = ["null_resource.icp-cluster", "null_resource.icp-boot"]

  connection {
    host                = "${element(var.gluster_ips, count.index)}"
    user                = "${var.ssh_user}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/common/prereqs.sh"
    destination = "/tmp/prereqs.sh"
  }
  provisioner "file" {
    source      = "${path.module}/scripts/gluster/creategluster.sh"
    destination = "/tmp/creategluster.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /root/.ssh && sudo chmod 700 /root/.ssh",
      "echo \"${tls_private_key.heketikey.public_key_openssh}\" | sudo tee -a /root/.ssh/authorized_keys && sudo chmod 600 /root/.ssh/authorized_keys",
      "chmod +x /tmp/prereqs.sh && /tmp/prereqs.sh",
      "chmod +x /tmp/creategluster.sh && sudo /tmp/creategluster.sh",
      "echo Installation of Gluster is Completed",
    ]
  }
}

resource "null_resource" "create_heketi" {
  count      = "${var.install_gluster ? 1 : 0}"
  #count      = "${var.gluster_size > 0 ? 1 : 0}"
  
  depends_on = ["null_resource.create_gluster"]

  connection {
    host = "${var.heketi_ip}"
    user = "${var.ssh_user}"

    #password = "${var.ssh_password}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "file" {
    content     = "${tls_private_key.heketikey.private_key_pem}"
    destination = "~/heketi_key"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/gluster/createheketi.sh"
    destination = "/tmp/createheketi.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "[ -f ~/heketi_key ] && sudo mkdir -p /etc/heketi && sudo mv ~/heketi_key /etc/heketi/ && sudo chmod 600 /etc/heketi/heketi_key",
      "[ -f /tmp/createheketi.sh ] && chmod +x /tmp/createheketi.sh && sudo /tmp/createheketi.sh ${var.heketi_admin_pwd}",
      "sleep 2",
      "sudo heketi-cli --user admin --secret ${var.heketi_admin_pwd} cluster create | tee /tmp/create_cluster.log",
    ]
  }
}

data "template_file" "create_node_script" {
  count = "${var.install_gluster ? var.gluster_size : 0}"
  #count      = "${var.gluster_size > 0 ? var.gluster_size : 0}"

  template = "${file("${path.module}/scripts/gluster/create_node.tpl")}"

  vars {
    nodeip           = "${element(var.gluster_svc_ips, count.index)}"
    nodefile         = "${format("/tmp/nodeid-%01d.txt", count.index + 1) }"
    device_name      = "${var.device_name}"
    heketi_admin_pwd = "${var.heketi_admin_pwd}"
  }
}

resource "null_resource" "create_node" {
  count      = "${var.install_gluster ? var.gluster_size : 0}"
  #count      = "${var.gluster_size > 0 ? var.gluster_size : 0}"
  depends_on = ["null_resource.create_gluster", "null_resource.create_heketi"]

  connection {
    host = "${var.heketi_ip}"
    user = "${var.ssh_user}"

    #password = "${var.ssh_password}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "file" {
    content     = "${element(data.template_file.create_node_script.*.rendered, count.index)}"
    destination = "/tmp/createnode-${count.index}.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/createnode-${count.index}.sh && sudo /tmp/createnode-${count.index}.sh",
    ]
  }
}

data "template_file" "glusterfs_secret" {
  count = "${var.install_gluster ? 1 : 0}"
  #count      = "${var.gluster_size > 0 ? 1 : 0}"

  template = "${file("${path.module}/scripts/gluster/glusterfs-secret.yaml.tpl")}"

  vars {
    heketi_admin_pwd = "${base64encode(var.heketi_admin_pwd)}"
  }
}

data "template_file" "storage_class" {
  count = "${var.install_gluster ? 1 : 0}"
  #count      = "${var.gluster_size > 0 ? 1 : 0}"

  template = "${file("${path.module}/scripts/gluster/storageclass.yaml.tpl")}"

  vars {
    heketi_svc_ip       = "${var.heketi_svc_ip}"
    gluster_volume_type = "${var.gluster_volume_type}"
  }
}

resource "null_resource" "create_storage_class" {
  count      = "${var.install_gluster ? 1 : 0}"
  #count      = "${var.gluster_size > 0 ? 1 : 0}"
  
  depends_on = ["null_resource.icp-boot", "null_resource.create_heketi"]

  connection {
    host = "${var.boot-node}"
    user = "${var.ssh_user}"

    #password = "${var.ssh_password}"
    private_key         = "${var.ssh_key}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${var.bastion_private_key}"
  }

  provisioner "file" {
    content     = "${data.template_file.glusterfs_secret.rendered}"
    destination = "/tmp/glusterfs-secret.yaml"
  }

  provisioner "file" {
    content     = "${data.template_file.storage_class.rendered}"
    destination = "/tmp/storageclass.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl config set-cluster ${var.cluster_name} --server=https://${var.boot-node}:8001 --insecure-skip-tls-verify=true",
      "kubectl config set-context ${var.cluster_name} --cluster=${var.cluster_name}",
      "kubectl config set-credentials ${var.cluster_name} --client-certificate=${var.install_dir}/cfc-certs/kubecfg.crt --client-key=${var.install_dir}/cfc-certs/kubecfg.key",
      "kubectl config set-context ${var.cluster_name} --user=${var.cluster_name}",
      "kubectl config use-context ${var.cluster_name}",
      "kubectl create -f /tmp/glusterfs-secret.yaml",
      "kubectl create -f /tmp/storageclass.yaml",
      "echo completed storage class::",
      "cat /tmp/storageclass.yaml"
    ]
  }
}
