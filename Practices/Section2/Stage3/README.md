Tasks
===
### Stage3
Configure environment like on schema for Stage3 using configs from Stage2 and Stage1.

    Please try to: provide DB IP (docker --net DNS not working outside of the same host) and Secrets into docker WebApp config by ENV variable on docker run.

[Stage3 Schema](https://github.com/ask4ua/DKN/blob/master/Practices/Lection2/Stage3/DevOpsTrainig2-Stage3.png)

Instructions to run desired infrastructure:
Prereqirements:
terraform installed
terraform.tfvars files with secrets must be provided:
access_key = "YOUR AWS ACCESS_KEY"
secret_key = "YOUR AWS SECRET_KEY"
POSTGRES_USER = "DBUSER" 
POSTGRES_DB = "DBNAME" 
POSTGRES_PASSWORD = "DBPASS"

Clone the repo and cd to ./DKN/Practices/Section2/Stage3
Run following commands:
terrafom init
terraform plan
terraform apply

Output will show Public IPs of 2 proxies which serve our webapp.