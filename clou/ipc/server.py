import socket

s = socket.socket()
s.bind(("localhost", 5000))
s.listen(1)

print("Server waiting for client...")
conn, addr = s.accept()

msg = conn.recv(1024).decode()
print("Client says:", msg)

conn.send("Hello from Server!".encode())

conn.close()
s.close()