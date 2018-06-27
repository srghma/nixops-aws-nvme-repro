# Nixops infrastructure

Notes:
- I'm using default security group everywhere, that allows all inbound and outbound traffic. Actual security is handled by firewall
- When volume was resized - https://stackoverflow.com/a/11318985/3574379 + sudo resize2fs /dev/xvda1

To get `EC2_ACCESS_KEY` and `EC2_SECRET_KEY` create non-root prophile in IAM console
don't surround keys with quotation marks!

journalctl -u service-name.service -b


Command to recreate instance: `make nixops_purge && make nixops_create && nixops deploy`
