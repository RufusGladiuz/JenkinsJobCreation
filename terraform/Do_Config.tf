resource "digitalocean_droplet" "web1" {
  image = "ubuntu-18-04-x64"
  name = "DevOpsSoSe2020"
  region = "FRA1"
  size = "2GB"
  private_networking = false
  ssh_keys = [
    var.ssh_fingerprint
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
    agent = false
  }

   provisioner "file" {
    source      = "./jenkins"
    destination = "./jenkins"
  }

provisioner "remote-exec" {

    inline =[

      //Install basics
        "sudo apt-get update",
        "sudo apt install php-fpm -y",
        "sudo apt-get update",
        "sudo apt-get install  php7.2-soap",
        
        "sudo apt-get update",
        "sudo apt install npm -y",
               
        "sudo curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh",
        "sudo bash nodesource_setup.sh",
        "sudo apt install nodejs -y",


        "sudo apt-get update",
        "sudo apt install git -y",

        "sudo apt update",
        "sudo apt install nano -y",

        "sudo apt update",
        "sudo apt install openjdk-8-jdk -y",

        //Install relevant python packages
        "sudo apt-get install python3-pip -y",
        "sudo python3 -m pip install python-jenkins",
        "sudo python3 -m pip install PyGithub",
        "sudo python3 -m pip install kasserver",
        "sudo python3 -m pip install netifaces",

        //Install Docker
        "sudo apt-get update",
        "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
        "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable\"",
        "sudo apt-get update",
        "sudo apt-cache policy docker-ce",
        "sudo apt install docker-ce -y",

        //Install Docker Compose
        "sudo curl -L \"https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
        "sudo chmod +x /usr/local/bin/docker-compose",

        //Install Jenkins
        "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
        "sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
        "sudo apt update",
        "sudo apt install jenkins -y",
        "sudo systemctl start jenkins",

        //Wait for Jenkins to initilise
        "sudo sleep 30",

        //Get Jenkis JDK
        "sudo wget http://`ip route get 1.2.3.4 | awk '{print $7}'`:8080/jnlpJars/jenkins-cli.jar",

        //Create jenkins user
        "sudo echo 'jenkins.model.Jenkins.instance.securityRealm.createAccount(\"devops\", \"admin123\")' | java -jar jenkins-cli.jar -auth admin:`cat /var/lib/jenkins/secrets/initialAdminPassword` -s http://localhost:8080/ groovy =",

        // Installing jenkins basic plugins
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin cloudbees-folder",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin timestamper",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin workflow-aggregator",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin antisamy-markup-formatter",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin build-timeout",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin credentials-binding",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin ws-cleanup",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin ant",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin gradle",      
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin github-branch-source",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin pipeline-github-lib",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin pipeline-stage-view",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin git",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin subversion",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin ssh-slaves",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin matrix-auth",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin pam-auth",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin ldap",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin email-ext",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin mailer",
        "sudo java -jar jenkins-cli.jar -auth devops:admin123 -s http://localhost:8080/ install-plugin configuration-as-code",
        "sudo ufw allow 8080",

        // Give jenkis rights to use docker
        "sudo usermod -aG docker jenkins",
        "sudo systemctl restart jenkins",
        "sudo sleep 30",

    ]
}

//Setup Jenkins Job
provisioner "remote-exec" {

    inline =[

        "sudo git clone https://github.com/RufusGladiuz/TODO_InfrastructureAsCode.git",
        "cd TODO_InfrastructureAsCode/jenkins",
        
        // Configure jenkins settings
        "sudo python3 jenkinsConfig.py devops admin123 Todo-App ${var.githubRepo}",

        // Set Github webhook
        "sudo python3 webhookAutomation.py ${var.githubRepo} ${var.githubAccessToken}",
        "cd ",
        "rm -R TODO_InfrastructureAsCode",
    ]
}

// Setup Monitoring
provisioner "remote-exec" {

    inline =[
      "sudo git clone https://github.com/RufusGladiuz/TODO_InfrastructureAsCode.git",
      "sudo apt-get install monit -y",
      "monit",

      // Configure Monit
      "cd TODO_InfrastructureAsCode/monit",
      "python3 monitsetup.py ${var.domain_name}",
      "rm -R /etc/monit/monitrc",
      "cp monitrc /etc/monit/",
      "chmod 0700 /etc/monit/monitrc",

      "monit reload",
      "cd ",
      "rm -R TODO_InfrastructureAsCode",
    ]
}

//Install webserver
provisioner "remote-exec" {

    inline =[

      "sudo apt-get update",
      "sudo apt install nginx -y",
      "rm -r  /etc/default/jenkins",
      "cp jenkins /etc/default/",
      "rm -r /etc/nginx/sites-available/default",

      "sudo git clone https://github.com/RufusGladiuz/TODO_InfrastructureAsCode.git",
      "cd TODO_InfrastructureAsCode/nginx",
      "python nginxutils.py ${var.domain_name}",
      "cp default /etc/nginx/sites-available/",
      "sudo service nginx restart",
      "cd ..",
      "php -f kas_auth.php ${var.kas_username} ${var.kas_password} ${var.domain_name} ${digitalocean_droplet.web1.ipv4_address}",
      "cd ",
      "rm -R TODO_InfrastructureAsCode",

      // Wait for domain to be ready
      "sudo sleep 23",

      //HTTPS
      "sudo apt update",
      "sudo apt install snapd -y",
      "sudo snap install --classic certbot",
      //source: https://hodovi.ch/blog/securing-a-site-with-letsencrypt-aws-and-terraform/
      "sudo certbot --nginx --email onur-ozkan@hotmail.de --agree-tos -d ${var.domain_name} -n",
    ]
}

// Run App
provisioner "remote-exec" {

    inline =[
        "sudo git clone ${var.githubRepo}",
        "cd lecture-devops-app",
        "sudo docker build -t todo .",
        "sudo docker image prune -f",
        "cd app",
        "sudo docker-compose build",
        "sudo docker-compose up -d",
        "cd ",
        "rm -R lecture-devops-app",
    ] 
}


                

}