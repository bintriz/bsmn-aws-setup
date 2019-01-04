# bsmn-aws-setup
## Installing AWS ParallelCluster 

```
$ pip install aws-parallelcluster
```
## Configuring AWS ParallelCluster
### Prerequisites
To configure AWS ParallelCluster, you need AWS security credentials as below. Please see this documentation ([Access Keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys)) for detail.

* AWS Access Key ID
* AWS Secret Access Key

Then, you need to set it up the AWS EC2. Follow this guide ([Setting Up with Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html)) to set up. As a result, you get the below information.
 
* Amazon EC2 Key Pairs
* VPC and subnet

### Configuration file

The default location of the AWS ParallelCluster configuration file is ~/.parallelcluster/config. The below is the configuration template for BSMN. Please update ~/.parallelcluster/config using this template with your own information of the above prerequisites.

<pre>
[global]
update_check = true
sanity_check = true
cluster_template = bsmn

[aws]
aws_access_key_id = <b>#Your AWS Access Key ID</b>
aws_secret_access_key = <b>#Your AWS Secret Access Key</b>
aws_region_name = us-east-1

[cluster bsmn]
key_name = <b>#Your Amazon EC2 Key Pairs</b>
post_install = https://raw.githubusercontent.com/bintriz/bsmn-aws-setup/master/post_install.sh
post_install_args = --timezone America/Chicago
master_instance_type = m5.large
compute_instance_type = m5.12xlarge
initial_queue_size = 0
max_queue_size = 1000
cluster_type = spot
spot_price = 2.0
vpc_settings = public
ebs_settings = bsmn-ebs
efs_settings = bsmn-efs

[vpc public]
master_subnet_id = <b>#Your subnet to use</b>
vpc_id = <b>#Your VPC</b>

[ebs bsmn-ebs]
volume_size = 40

[efs bsmn-efs]
shared_dir = efs

[aliases]
ssh = ssh {CFN_USER}@{MASTER_IP} {ARGS}
</pre>

### Create a cluster and log in

Now you can create your cluster;

```
$ pcluster create bsmn
```

After the cluster finishes creating, log in:

```
$ pcluster ssh bsmn
```

## Documentation
For more information about the AWS ParallelCluster, plase see the following docs.

* [AWS ParallelCluster Project Documentation](https://aws-parallelcluster.readthedocs.io)
* [AWS ParallelCluster Source Repository](https://github.com/aws/aws-parallelcluster)