let
  region  = "us-west-1";
  zone    = "${region}c";
in

{
  network.description = "[TEST NIXOPS] network";
  network.enableRollback = true;

  resources.ec2KeyPairs.backendKeyPair = {
    inherit region zone;
  };

  resources.ec2SecurityGroups.backendSecurityGroup = {
    inherit region zone;
    description = "[TEST NIXOPS] ssh security group";
    rules = [ {
      fromPort = 22;
      toPort   = 22;
      sourceIp = "0.0.0.0/0";
    } ];
  };

  stage =
    { resources, ... }@args:
    {
      deployment.targetEnv = "ec2";

      deployment.ec2 = {
        inherit region zone;

        instanceType             = "c4.large";
        keyPair                  = resources.ec2KeyPairs.backendKeyPair;
        associatePublicIpAddress = true;
        ebsInitialRootDiskSize   = 50;
        tags.Name                = "[TEST NIXOPS] stage";

        securityGroups = [
          resources.ec2SecurityGroups.backendSecurityGroup
        ];
      };

      fileSystems."/data" = {
        fsType = "xfs";
        options = [ "noatime" "nodiratime" ];
        device = "/dev/xvdf";
        autoFormat = true;
        ec2.size = 5;
        ec2.volumeType = "gp2";
      };
    };
}
