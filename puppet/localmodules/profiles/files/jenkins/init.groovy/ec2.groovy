#!groovy
import com.amazonaws.services.ec2.model.InstanceType
import com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.domains.Domain
import hudson.model.*
import hudson.plugins.ec2.AmazonEC2Cloud
import hudson.plugins.ec2.AMITypeData
import hudson.plugins.ec2.EC2Tag
import hudson.plugins.ec2.SlaveTemplate
import hudson.plugins.ec2.SpotConfiguration
import hudson.plugins.ec2.UnixData
import jenkins.model.Jenkins
 
// parameters
def SlaveTemplateUsEast1Parameters = [
  ami:                      'ami-035be7bafff33b6b6',
  associatePublicIp:        false,
  connectBySSHProcess:      true,
  connectUsingPublicIp:     false,
  customDeviceMapping:      '',
  deleteRootOnTermination:  true,
  description:              'Jenkins slave EC2 US East 1',
  ebsOptimized:             false,
  iamInstanceProfile:       '',
  idleTerminationMinutes:   '5',
  initScript:               '',
  instanceCapStr:           '2',
  jvmopts:                  '',
  labelString:              'aws.ec2.us.east.jenkins.slave',
  launchTimeoutStr:         '',
  numExecutors:             '1',
  remoteAdmin:              'ec2-user',
  remoteFS:                 '',
  securityGroups:           'default',
  stopOnTerminate:          false,
  subnetId:                 'subnet-04a3034e',
  tags:                     new EC2Tag('Name', 'jenkins-slave'),
  tmpDir:                   '',
  type:                     't2.medium',
  useDedicatedTenancy:      false,
  useEphemeralDevices:      true,
  usePrivateDnsName:        true,
  userData:                 '',
  zone:                     'us-east-1a,us-east-1b'
]
 
def AmazonEC2CloudParameters = [
  cloudName:      'MyCompany',
  credentialsId:  'jenkins-ssh',
  instanceCapStr: '2',
  privateKey:     '''-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA+UYtZ4pzJL6dm14eXs3UhXMAEvS9puoBZzn10NUkvfR6o0WM6LMTYOEUKoxw
MyaBW/IHILjkXslkC19q4sRna+ee9MujcCaZ5erfwT7ZcHHwxcQhOmiVJ7PKETNBhcgH9e6XFpqe
XHh/9JTuZUEbyiWXYyYTzNASkesmdy8zXD8XAe604q50YJU2eGIPahF7nQzClRCiJLUw4Zy0eoyT
MLXgvAhBRgyHF9WgH2hCmy14Z7yhZl4TI0QiLeWlDS0ZDoP7Knulpwm0l7wDBU2+2Qlb6TG1+YN+
9Kxh3JJ6135ncYnq0mqzI2/WFLEiuer8cjNXJstrXbQTt5Tp329lHwIDAQABAoIBAQCtQJdiNZod
2dZVHC9jmQ+yyOEuS6hdEJt1EZXGVb45wGhUfoyXV4+KcCXCBOYexw51x1wo5BjlwHemZ+U0Q2nW
V5/laHvqAQpKANsPxwz92FOOQOkPXYz9kTpKhiNuRj8yMWgVr9WNU7srVS/0dDJKZ6I2qUptudiO
Tq/neojp/Rhn6mlguVK/5gMUdM25TdcDHeqtC7C5GM29MQRUz/XQfea4cwPMgxfuynDselVHKC87
APyOrjwycV9SADwbioV4HIRP47NLnYXh8tnK2Ec2wm6Nax9UQo7u7mPBTRqbNqvzW/43HTaHhJN/
0POFKmOuAYYwHdNR0+FZ2qPmP3thAoGBAP7TR3T1FplY6F5W7xJyni6GAC2DgyxSuo7B0wUgCVf+
xp2joAZuzaR0u2FUpgV0SGHP8nBhb/D5MExOgGNH21cxGePgcRbqWmfJ2tZj68A+6s83R6eCwA3o
unzUz6W1AWxgrrteojntXfmsSWR6dx6v9jNC6ECu/eI1FgP/Zvy5AoGBAPpsWOWa6ogaS9WK8OEr
ItzzUmuHp0IcKDVZ1DhL157fUb5d5ZHx/iY8zTSJHne6ftrMcEgy5iL4SPKYajl85NrK4+xZP9pV
IjahQEfg+wVc5/hYV2Yb1yxKwpGYN8FzdPLTkul5fxZCBfliJE30pfW+V8diPZZvUgMqxpRPUPSX
AoGBAJANb/+17SiTEgkCq/OJx9IU/lS8W5La0YuSFnB3Q9DyveSvcu8wBCBLvQGwkInUynZAz5So
AFgBBkScvAdjv6LypugjIMsLgD/b5FH9+m+bIbIyVddkGp3CSmn3A8txH3Tc0uoo/RwyC0XxFywt
7tjyMAOadyDZy7vstp1b7CRBAoGAbfieoVYCoHpLyx8U4Qz8ZmNEUoxj2xhaX/NuyrojmlUfpKW/
ZvQKU+hnhSaiBpoTkyosNMiFX94Ayug73bsHFT38EZKwA8VXHP57KBWYpqZCCEFjQCgBuiWqhB2A
fqehN/HJllYQhUnBLd73anSBXQWVrq1ptmJ0dYeXZRHfz0kCgYANgX8YLtqfjrlqQXvWBcGjESYX
d3phDfNtmonMGurAyyitxBaeLbm17Qrq6LhBgG2DzmmT9pbJLEZi52+oMbOSQNy695FGeR5YCzql
AhLALhIcMmaa9MNJctMrMmW+RDbmbEi4rX4ZRdLHP1tB+gQd7sBIb1r7y0ZPLZgbV0oWEg==
-----END RSA PRIVATE KEY-----''',
  region: 'us-east-1',
  useInstanceProfileForCredentials: false
]
 
def AWSCredentialsImplParameters = [
  id:           'jenkins-ssh',
  description:  'Jenkins AWS IAM key',
  accessKey:    'AKIAIUFNP45USSEHR32A',
  secretKey:    '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'
]
 
// https://github.com/jenkinsci/aws-credentials-plugin/blob/aws-credentials-1.23/src/main/java/com/cloudbees/jenkins/plugins/awscredentials/AWSCredentialsImpl.java
AWSCredentialsImpl aWSCredentialsImpl = new AWSCredentialsImpl(
  CredentialsScope.GLOBAL,
  AWSCredentialsImplParameters.id,
  AWSCredentialsImplParameters.accessKey,
  AWSCredentialsImplParameters.secretKey,
  AWSCredentialsImplParameters.description
)
 
// https://github.com/jenkinsci/ec2-plugin/blob/ec2-1.38/src/main/java/hudson/plugins/ec2/SlaveTemplate.java
SlaveTemplate slaveTemplateUsEast1 = new SlaveTemplate(
  SlaveTemplateUsEast1Parameters.ami,
  SlaveTemplateUsEast1Parameters.zone,
  null,
  SlaveTemplateUsEast1Parameters.securityGroups,
  SlaveTemplateUsEast1Parameters.remoteFS,
  InstanceType.fromValue(SlaveTemplateUsEast1Parameters.type),
  SlaveTemplateUsEast1Parameters.ebsOptimized,
  SlaveTemplateUsEast1Parameters.labelString,
  Node.Mode.NORMAL,
  SlaveTemplateUsEast1Parameters.description,
  SlaveTemplateUsEast1Parameters.initScript,
  SlaveTemplateUsEast1Parameters.tmpDir,
  SlaveTemplateUsEast1Parameters.userData,
  SlaveTemplateUsEast1Parameters.numExecutors,
  SlaveTemplateUsEast1Parameters.remoteAdmin,
  new UnixData(null, null, null),
  SlaveTemplateUsEast1Parameters.jvmopts,
  SlaveTemplateUsEast1Parameters.stopOnTerminate,
  SlaveTemplateUsEast1Parameters.subnetId,
  [SlaveTemplateUsEast1Parameters.tags],
  SlaveTemplateUsEast1Parameters.idleTerminationMinutes,
  SlaveTemplateUsEast1Parameters.usePrivateDnsName,
  SlaveTemplateUsEast1Parameters.instanceCapStr,
  SlaveTemplateUsEast1Parameters.iamInstanceProfile,
  SlaveTemplateUsEast1Parameters.deleteRootOnTermination,
  SlaveTemplateUsEast1Parameters.useEphemeralDevices,
  SlaveTemplateUsEast1Parameters.useDedicatedTenancy,
  SlaveTemplateUsEast1Parameters.launchTimeoutStr,
  SlaveTemplateUsEast1Parameters.associatePublicIp,
  SlaveTemplateUsEast1Parameters.customDeviceMapping,
  SlaveTemplateUsEast1Parameters.connectBySSHProcess,
  SlaveTemplateUsEast1Parameters.connectUsingPublicIp
)
 
// https://github.com/jenkinsci/ec2-plugin/blob/ec2-1.38/src/main/java/hudson/plugins/ec2/AmazonEC2Cloud.java
AmazonEC2Cloud amazonEC2Cloud = new AmazonEC2Cloud(
  AmazonEC2CloudParameters.cloudName,
  AmazonEC2CloudParameters.useInstanceProfileForCredentials,
  AmazonEC2CloudParameters.credentialsId,
  AmazonEC2CloudParameters.region,
  AmazonEC2CloudParameters.privateKey,
  AmazonEC2CloudParameters.instanceCapStr,
  [slaveTemplateUsEast1]
)
 
// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()
 
// get credentials domain
def domain = Domain.global()
 
// get credentials store
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()
 
// add credential to store
store.addCredentials(domain, aWSCredentialsImpl)
 
// add cloud configuration to Jenkins
jenkins.clouds.add(amazonEC2Cloud)
 
// save current Jenkins state to disk
jenkins.save()