import socket

c = socket.socket()
c.connect(("localhost", 5000))

c.send("Hello from Client!".encode())

msg = c.recv(1024).decode()
print("Server says:", msg)

c.close()