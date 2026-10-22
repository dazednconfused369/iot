# Lamport Digital Clock
clock = 0

print("Initial clock:", clock)

for i in range(3):
    clock += 1
    print("Event", i + 1, "Clock:", clock)




#Vector Clock 

class Process:
    def __init__(self, name, pid):
        self.name = name
        self.pid = pid
        self.clock = [0, 0, 0]

    def event(self):
        self.clock[self.pid] += 1
        print(self.name, self.clock)

P1 = Process("P1", 0)
P2 = Process("P2", 1)
P3 = Process("P3", 2)

P1.event()
P2.event()
P3.event()
