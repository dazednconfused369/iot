import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(("localhost", 5000))

print("Connected to server. Type 'exit' to quit.")

while True:
    msg = input("Enter message: ")

    if msg.lower() == "exit":
        break

    client.send(msg.encode())

    reply = client.recv(1024).decode()
    print(reply)

client.close()