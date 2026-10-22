import Pyro4

ns = Pyro4.locateNS()
uri = ns.lookup("calculator")

calc = Pyro4.Proxy(uri)

a = 10
b = 2

print("Addition:", calc.add(a, b))
print("Subtraction:", calc.sub(a, b))
print("Multiplication:", calc.mul(a, b))
print("Division:", calc.div(a, b))