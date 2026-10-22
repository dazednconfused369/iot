import socket
import threading

def handle_client(client, addr):
    print("Connected:", addr)

    while True:
        try:
            msg = client.recv(1024).decode()

            if not msg:
                break

            print(addr, ":", msg)
            client.send(("Server received: " + msg).encode())

        except:
            break

    client.close()

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(("localhost", 5000))
server.listen()

print("Server is waiting for clients...")

while True:
    client, addr = server.accept()
    threading.Thread(
        target=handle_client,
        args=(client, addr)
    ).start()