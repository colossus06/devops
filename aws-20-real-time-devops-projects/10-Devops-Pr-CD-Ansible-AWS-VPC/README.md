# Devops-Projects-Ansible-for-AWS-VPC


![image](https://user-images.githubusercontent.com/96833570/219876445-63ff6396-794f-4a56-8a13-7d038f5d5bf2.png)


## modules used:

#### vpc

* amazon.aws.ec2_vpc_net
* amazon.aws.ec2_vpc_subnet
* amazon.aws.ec2_vpc_igw
* amazon.aws.ec2_vpc_route_table
* amazon.aws.ec2_vpc_nat_gateway


#### Bastion

* amazon.aws.ec2_security_group
* amazon.aws.ec2_instance


## Creating the vpc playbook

#### Requirements

* boto

* boto3

* python >= 2.6

ref: https://docs.ansible.com/ansible/2.9/modules/ec2_key_module.html#examples





![image](https://user-images.githubusercontent.com/96833570/219637363-f4153b0d-6523-4699-9327-058ff2beb553.png)

![image](https://user-images.githubusercontent.com/96833570/219638921-8bccabf5-765c-4c6c-b997-7a5414ccbf85.png)

![image](https://user-images.githubusercontent.com/96833570/219643360-4462f52f-e4bf-4a9a-bdc7-b56fcda26215.png)


I will be deleting this key pair, no worries.

Since we added `when: keyout.changed` line we won't get an error in future playbook runs.

![image](https://user-images.githubusercontent.com/96833570/219644766-12ec76ac-dcb3-45ae-8c55-be8af460aa57.png)

## Creating VPC Play

```
- hosts: localhost
  connection: local
  gather_facts: False
  tasks:
    - name: Import vpc variables
      include_vars: vars/vpc_setup
    - name: create vpc
      ec2_vpc_net:
        name: "{{ vpc_name }}"
        cidr_block: "{{ vpcCidr }}"
        region: "{{ region }}"
        dns_hostnames: yes
        dns_support: yes
        tenancy: default
        state: "{{ state }}"
      register: vpcout
      when: vpcout.changed
    
        
```

![image](https://user-images.githubusercontent.com/96833570/219666502-3809bf70-b866-42a8-9507-1b460ab5eced.png)


## Creating Subnets and other vpc components play



![image](https://user-images.githubusercontent.com/96833570/219719816-a0e803a2-27b9-4778-8b8a-02088c4002c0.png)


![image](https://user-images.githubusercontent.com/96833570/219750701-a651a1e4-07c2-49fe-a0e5-e87fc4841e36.png)

![image](https://user-images.githubusercontent.com/96833570/219871607-af9932e9-a243-43fc-a484-f326ec9284c1.png)

![image](https://user-images.githubusercontent.com/96833570/219871760-562af667-a18d-446e-b636-8b073441820e.png)





#### Debugging errors

`AuthorizeSecurityGroupIngress operation: CIDR block 12.12.123.1234 is malformed` . 

I forgot to add 1 host block /32. Relace the ip such as the following: `your-public-ip/32`

### Final Validation

![image](https://user-images.githubusercontent.com/96833570/219873732-4fb7075e-da08-4b19-86fd-2efe69c1d323.png)

![image](https://user-images.githubusercontent.com/96833570/219873843-963d41e6-a16e-4d0a-bb20-dbb242ddad0c.png)


![image](https://user-images.githubusercontent.com/96833570/219873770-29127130-fbd4-4d26-a53e-b748bd55ce8b.png)


![image](https://user-images.githubusercontent.com/96833570/219874920-72f74379-deec-498e-a5e8-561d29786e38.png)


![image](https://user-images.githubusercontent.com/96833570/219874995-3ffe748c-dd5f-4481-94a3-bde996a9f014.png)




![ansible-vpc-bastion-devops](https://user-images.githubusercontent.com/96833570/219875554-f2e0502a-17fe-4197-8513-0596495bdc9e.gif)

