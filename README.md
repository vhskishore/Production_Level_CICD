### Create a Virtual Machine with 2CPU and 4GB Memory with IAM Access
### Make Sure to open ports 
- Type            Protocol            Port Range          Source
- Custom TCP      TCP                 1000-11000          0.0.0.0/0
- HTTP            TCP                 80                  0.0.0.0/0
- Custom TCP      TCP                 500-1000            0.0.0.0/0
- HTTPS           TCP                 443                 0.0.0.0/0
- SSH             TCP                 22                  0.0.0.0/0

### Prerequsites:
- aws cli
- # Production_Level_CICD