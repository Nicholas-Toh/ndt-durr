# Duerr NDT

This is a Laravel app featuring a CI/CD pipeline. Features include registration, authentication and profile settings.
The CI part is handled by Github Actions, while the CD part is handled by AWS Beanstalk.

## Pre-requisites

1. Have a verified AWS account with an IAM user with the following policies:
    - [AdministratorAccess-AWSElasticBeanstalk](https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AdministratorAccess-AWSElasticBeanstalk)
    - [AmazonS3FullAccess](https://us-east-1.console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/AmazonS3FullAccess)
2. Have a Github account.

## Setting Up AWS Beanstalk
AWS Beanstalk is a managed deployment service that helps you automatically provision AWS resources and deploy web applications rapidly. All you need to do is to specify which services you need in the environment such as RDS, VPC, load balancers, CloudWatch etc.

> **Note**
> Currently, there is no official way to pause an environment without terminating it. Please see https://jun711.github.io/aws/how-to-pause-or-stop-elastic-beanstalk-environment-from-running/ for a workaround. You may also manually pause the EC2 instance directly (and de-provision the Elastic IP) if you are using a single instance deployment.

1. Create a Beanstalk Application with a name and tag (optional).
2. Create an Environment in that Application that you just created.
3. **Step 1**: 
    - Select `Web server environment`
    - Enter environment name
    - Enter custom domain (optional)
    - Select `Managed platform`
    - Select `PHP` as your platform
    - Select `PHP 8.1` as the platform branch
    - Select `Sample application`
4. **Step 2**: 
    - If you have an existing AWS Beanstalk service role (usually called *aws-beanstalk-service-role*), use it, otherwise select **Create and use new service role**.
    - Choose an existing **EC2 key pair**. If you don't have one:
        - Search `key pairs`, select the **Key pair feature** under EC2 and click **Create key pair**.
        - Enter key name (e.g. ec2-beanstalk-key)
        - Select `ED25519`
        - Select `.pem`
        - Click **Create key pair**
        - Go back to the Beanstalk page, refresh the key pair list and select the key pair that was created just now (e.g. ec2-beanstalk-key).
    - Choose an existing **EC2 instance profile**. If you don't have one:
        - Go to **IAM console**, click on **Policies**, click on **Create Policy**
        - Click on the **JSON** tab, and paste the following JSON:
            ```
            {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Action": [
                            "s3:Get*",
                            "s3:List*"
                        ],
                        "Resource": [
                            "arn:aws:s3:::elasticbeanstalk-ap-southeast-2-761950595990/*"
                        ]
                    }
                ]
            }
            ```
        - Click on **Next: Tags**, click on **Next: Review**
        - Enter policy name (e.g. Beanstalk-EC2) and description (be descriptive about what it does)
        - Click on **Create policy**
        - Click on **Roles** to go to the IAM Roles console, click **Create Role**
        - Select `AWS service`
        - Select `EC2`
        - Click **Next**
        - Add the name of the policy that you've just created (e.g. Beanstalk-EC2), click **Next**
        - Enter the role name (e.g. Beanstalk-EC2-instance-profile), description (be descriptive about what it does)
        - Scroll to the bottom and click **Create role**
        - Go back to the **Beanstalk** page, refresh the EC2 instance profile list and select the profile that was just created (e.g. Beanstalk-EC2-instance-profile)
5. **Step 3**:
    - Scroll down to the **Database** section, click on **Enable database**
    - Select the `mysql` engine, `8.0.32` engine version, `db.t2.micro` instance class, `5 GB` storage
    - Enter a username and password (Laravel will be reading automatically from these fields)
    - Click on **Next** 3 times
    - Click on **Submit** 

## Usage
1. Store your IAM user's key and secret in the Actions secrets page as `AWS_IAM_USER_ID` and `AWS_IAM_USER_SECRET` respectively.
2. In `.github/workflows/deploy.yml`, fill in your `S3_BUCKET_NAME`, `EBS_APPLICATION_NAME`, `EBS_ENVIRONMENT_NAME` and `AWS_REGION`.
3. Push code into the repo to trigger the CI/CD pipeline which will run the tests and deploy the application for you.
4. Your application should be hosted at your-domain.your-region.elasticbeanstalk.com.