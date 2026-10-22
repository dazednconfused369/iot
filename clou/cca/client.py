import socket
import time

client = socket.socket()
client.connect(("localhost", 5000))

client.send("REQUEST".encode())
reply = client.recv(1024).decode()

if reply == "GRANT":
    print("Permission granted by coordinator")
    print("Process entered Critical Section")

    time.sleep(2)

    print("Process exits Critical Section")
    client.send("RELEASE".encode())
    print(client.recv(1024).decode())

client.close()