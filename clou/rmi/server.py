import Pyro4
from calc import Calculator

daemon = Pyro4.Daemon()
uri = daemon.register(Calculator())

ns = Pyro4.locateNS()
ns.register("calculator", uri)

print("Server is ready")
daemon.requestLoop()