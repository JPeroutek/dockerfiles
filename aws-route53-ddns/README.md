# aws-route53-ddns
A ddns package for Route53

## Usage
The idea is that you run the container on a device, and it updates the Route53 A-record to match your current public IP.  

You create a local file (such as `example.env`, but with your values placed in it), and run the docker container with the task scheduler of your choosing.

There are plenty of ways to run the docker container.  For example, 
```
docker run --rm -d --env-file example.env aws-route53-ddns:latest
```

## Similar solutions
- [This generic Linux one](https://www.cloudsavvyit.com/3103/how-to-roll-your-own-dynamic-dns-with-aws-route-53/)
- [This Node one](https://hub.docker.com/r/sjmayotte/route53-dynamic-dns/)