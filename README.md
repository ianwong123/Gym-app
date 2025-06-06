# Gym App Cloud Infrastructure
A cloud infrastructure project to deploy a Dockerised Gym App using AWS (Free Tier) built around a standard 3-tier architecture pattern. It features EC2 instances for dockerised application deployment, RDS (MySQL), NAT Gateway, Bastion Host, and SSM. Infrastructure designed and deployed via Terraform.

## Goal 
The goal is to take all the cloud knowledge I have accumulated and apply it into something real.
To make decisions about:
- How should I store secrets? What are the options?
- How can I structure modules properly to ensure clarity and modularity?
- What is the structure of the workflow?
- What does "best practice" mean when you're building something?

I wanted to implement everything I've learned while trying to follow industry standards - from architecture design to security policies to deployment workflows. Plus, to also gain confidence using using the AWS CLI over the AWS UI for retrieving and validating resources.

## Challenges
### IAM Policies 
Understanding IAM policies was a headache. Getting the right permissions took longer than expected. There's a lot to know about IAM Policies and getting it wrong means nothing works. A lot of time was spent in the documentation trying to figure out the principle of least privilege without being too restrictive that services coudn't talk to each other

## Outcome
Success! Even though the architecture is definitely over-engineered for what's essentially a simple app, it achieved what I set out to do, which is to apply and learn the foundational ckoud concepts and understand how things might work in the real world.

## Thoughts
The technical implementation was one thing, but the real learning was about making architectural decisions and understanding the trade-offs. Like, when do you actually need a NAT Gateway? When is a bastion host overkill? How do you balance security with practicality? 

1. The original plan included load balancing with reverse proxies already configured, but I did not implement that part. I also considered using ECS, but decided to stick with Docker on EC2 since I wanted to get more familiar with Docker deployment patterns.

2. Security still feels incomplete. There are gaps, but I'm not entirely sure what I'm missing yet. More research needed.

3. SSM vs Bastion Host. I started with a bastion host in of the public subnets but then experimeted with SSM. Both have their place depending on the use case.

4. NAT Instance alternatives. Initially configured a NAT Instance, but later found that SSM could handle internet access for my use case. Again, depends on the situation.

5. IAM policies are a srouce of headaches and leads to lots of issues if not done correctly.

## Next Steps
What I am tackling next:
1. To design a proper CI/CD Pipeline for automating tests and deployments end-to-end
2. Kubernetes for orchestration
3. Monitoring with Prometheus and Grafana
4. Severless
5. IAM Deep Dive
6. Security Research

