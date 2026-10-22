import socket
import threading

lock = threading.Lock()

def handle_client(conn, addr):
    print("Connected:", addr)

    while True:
        msg = conn.recv(1024).decode()

        if not msg:
            break

        if msg == "REQUEST":
            lock.acquire()
            conn.send("GRANT".encode())
            print(addr, "entered Critical Section")

        elif msg == "RELEASE":
            print(addr, "released Critical Section")
            lock.release()
            conn.send("RELEASED".encode())

    conn.close()

server = socket.socket()
server.bind(("localhost", 5000))
server.listen()

print("Coordinator is running...")

while True:
    conn, addr = server.accept()
    threading.Thread(
        target=handle_client,
        args=(conn, addr)
    ).start()