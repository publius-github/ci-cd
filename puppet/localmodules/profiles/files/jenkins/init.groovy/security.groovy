import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def env = System.getenv()

admin_pwd = env['SIMPLE_ADMIN_PWD']
if (!admin_pwd) {
    admin_pwd = "password1"
    println("== basic-security.groovy -> default admin password set.")
}

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", admin_pwd)
instance.setSecurityRealm(hudsonRealm)
println("== basic-security.groovy -> adminge account added.")

def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "admin")
instance.setAuthorizationStrategy(strategy)
println("== basic-security.groovy -> admin rights configured.")


instance.save()