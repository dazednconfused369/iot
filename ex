# CLOUD AND DISTRIBUTED COMPUTING — EXPERIMENTS 1–4
# Copy this entire file into Notepad. Save as Cloud_Lab_Experiments_1_to_4.txt
# Explanations, task titles, outputs and instructions are comments.
# To run a program, copy its code section into a separate .py file.
# For socket experiments, start the server first, then run the client.
#
# ============================================================
# EXPERIMENT 1: INTER-PROCESS COMMUNICATION
# ============================================================
#
# TASK 1: CLIENT-SERVER COMMUNICATION AND SUM OF NUMBERS
# Save server code as server1.py
#
# Sample input in client: 10 20 30
# Expected response: Sum of numbers = 60
#
# -------------------- server1.py --------------------
import socket

def start_server():
    host = "127.0.0.1"
    port = 5000

    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((host, port))
    server.listen(5)

    print("Server started. Waiting for client...")

    try:
        while True:
            conn, address = server.accept()
            print("Connected to:", address)

            with conn:
                data = conn.recv(4096).decode().strip()
                print("Received numbers:", data)

                try:
                    numbers = [int(x) for x in data.split()]
                    result = sum(numbers)
                    response = f"Sum of numbers = {result}"
                except ValueError:
                    response = "Error: Enter valid integers separated by spaces."

                conn.sendall(response.encode())
                print("Response sent:", response)
    except KeyboardInterrupt:
        print("\nServer stopped.")
    finally:
        server.close()

if __name__ == "__main__":
    start_server()

# -------------------- client1.py --------------------
# Copy the following code into client1.py separately.
# Sample input: 10 20 30
# Expected output: Sum of numbers = 60
#
# import socket
#
# def start_client():
#     host = "127.0.0.1"
#     port = 5000
#     numbers = input("Enter integers separated by spaces: ")
#     client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     try:
#         client.connect((host, port))
#         client.sendall(numbers.encode())
#         response = client.recv(4096).decode()
#         print("Server response:", response)
#     except ConnectionRefusedError:
#         print("Error: Start the server before running the client.")
#     finally:
#         client.close()
#
# if __name__ == "__main__":
#     start_client()
#
# TASK 2: OBJECT SERIALIZATION USING PICKLE
# Save server code as server2.py and client code as client2.py.
# Sample input: object name Student; values 10 20 30
# Expected result: Sum of values: 60
#
# -------------------- server2.py --------------------
# import socket
# import pickle
#
# class DataObject:
#     def __init__(self, name, values):
#         self.name = name
#         self.values = values
#
# def start_server():
#     host = "127.0.0.1"
#     port = 5001
#     server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
#     server.bind((host, port))
#     server.listen(5)
#     print("Serialization server started.")
#     try:
#         while True:
#             conn, address = server.accept()
#             print("Connected to:", address)
#             with conn:
#                 received_data = bytearray()
#                 while True:
#                     chunk = conn.recv(4096)
#                     if not chunk:
#                         break
#                     received_data.extend(chunk)
#                 try:
#                     obj = pickle.loads(received_data)
#                     if not isinstance(obj, DataObject):
#                         raise ValueError("Invalid object received.")
#                     print("Object name:", obj.name)
#                     print("Values:", obj.values)
#                     response = {"name": obj.name, "sum": sum(obj.values)}
#                     conn.sendall(pickle.dumps(response))
#                     print("Sum sent:", response["sum"])
#                 except Exception as error:
#                     print("Error:", error)
#     except KeyboardInterrupt:
#         print("\nServer stopped.")
#     finally:
#         server.close()
#
# if __name__ == "__main__":
#     start_server()
#
# -------------------- client2.py --------------------
# import socket
# import pickle
#
# class DataObject:
#     def __init__(self, name, values):
#         self.name = name
#         self.values = values
#
# def start_client():
#     host = "127.0.0.1"
#     port = 5001
#     name = input("Enter object name: ")
#     values = list(map(int, input("Enter integers separated by spaces: ").split()))
#     obj = DataObject(name, values)
#     client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     try:
#         client.connect((host, port))
#         client.sendall(pickle.dumps(obj))
#         client.shutdown(socket.SHUT_WR)
#         received_data = bytearray()
#         while True:
#             chunk = client.recv(4096)
#             if not chunk:
#                 break
#             received_data.extend(chunk)
#         response = pickle.loads(received_data)
#         print("Object name:", response["name"])
#         print("Sum of values:", response["sum"])
#     except ConnectionRefusedError:
#         print("Error: Start the server first.")
#     finally:
#         client.close()
#
# if __name__ == "__main__":
#     start_client()
#
# NOTE: Pickle should only be used with trusted data; never unpickle untrusted client input.
#
# ============================================================
# EXPERIMENT 2: REMOTE METHOD INVOCATION (RMI) AND GOOGLE CLOUD
# ============================================================
#
# TASK 1: RMI USING PYRO4
# Install dependency: pip install Pyro4
# Run rmi_server.py first. Copy its URI into rmi_client.py.
#
# -------------------- rmi_server.py --------------------
# import Pyro4
#
# @Pyro4.expose
# class Calculator:
#     def add_numbers(self, a, b):
#         return a + b
#
#     def multiply(self, a, b):
#         return a * b
#
# def main():
#     daemon = Pyro4.Daemon()
#     uri = daemon.register(Calculator())
#     print("Calculator server is running.")
#     print("Server URI:", uri)
#     print("Waiting for remote requests...")
#     try:
#         daemon.requestLoop()
#     except KeyboardInterrupt:
#         print("\nServer shutting down.")
#     finally:
#         daemon.close()
#
# if __name__ == "__main__":
#     main()
#
# -------------------- rmi_client.py --------------------
# import Pyro4
#
# def main():
#     uri = input("Enter the server URI: ")
#     try:
#         with Pyro4.Proxy(uri) as calculator:
#             a = float(input("Enter first number: "))
#             b = float(input("Enter second number: "))
#             print("Addition result:", calculator.add_numbers(a, b))
#             print("Multiplication result:", calculator.multiply(a, b))
#     except Exception as error:
#         print("Remote invocation failed:", error)
#
# if __name__ == "__main__":
#     main()
#
# Sample: inputs 10 and 5; addition 15.0, multiplication 50.0.
#
# TASK 2: GOOGLE CLOUD CONSOLE BASICS
# These are terminal commands, not Python code. Install Google Cloud CLI and authenticate.
#
# Task 2.1 — Access and authenticate:
# gcloud auth login
# gcloud config list
# gcloud projects list
#
# Task 2.2 — View/select project:
# gcloud projects list
# gcloud config set project YOUR_PROJECT_ID
# gcloud config get-value project
#
# Task 2.3 — Review IAM roles:
# gcloud projects get-iam-policy YOUR_PROJECT_ID
# Example role binding (only if authorized):
# gcloud projects add-iam-policy-binding YOUR_PROJECT_ID --member="user:USER_EMAIL" --role="roles/viewer"
#
# Task 2.4 — List and enable APIs:
# gcloud services list --enabled --project=YOUR_PROJECT_ID
# gcloud services list --available --project=YOUR_PROJECT_ID
# gcloud services enable compute.googleapis.com --project=YOUR_PROJECT_ID
# gcloud services list --enabled --project=YOUR_PROJECT_ID
#
# Replace YOUR_PROJECT_ID and USER_EMAIL with actual values. API enablement may require billing
# and sufficient permissions.
#
# ============================================================
# EXPERIMENT 3: MESSAGE PASSING AND DISTRIBUTED MUTUAL EXCLUSION
# ============================================================
#
# TASK 1: MESSAGE PASSING SYSTEM WITH MULTIPLE CLIENTS
# Save server as message_server.py; clients as message_client.py.
#
# -------------------- message_server.py --------------------
# import socket
# import threading
#
# HOST = "127.0.0.1"
# PORT = 6000
#
# def handle_client(conn, address):
#     print("Client connected:", address)
#     try:
#         with conn:
#             while True:
#                 data = conn.recv(1024)
#                 if not data:
#                     break
#                 message = data.decode().strip()
#                 print(f"Message from {address}: {message}")
#                 response = f"Server received: {message}"
#                 conn.sendall(response.encode())
#     except ConnectionResetError:
#         print("Client disconnected unexpectedly:", address)
#     finally:
#         print("Connection closed:", address)
#
# def start_server():
#     server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
#     server.bind((HOST, PORT))
#     server.listen(10)
#     print(f"Message server listening on {HOST}:{PORT}")
#     try:
#         while True:
#             conn, address = server.accept()
#             thread = threading.Thread(
#                 target=handle_client,
#                 args=(conn, address),
#                 daemon=True
#             )
#             thread.start()
#     except KeyboardInterrupt:
#         print("\nServer stopped.")
#     finally:
#         server.close()
#
# if __name__ == "__main__":
#     start_server()
#
# -------------------- message_client.py --------------------
# import socket
#
# HOST = "127.0.0.1"
# PORT = 6000
#
# def start_client():
#     client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#     try:
#         client.connect((HOST, PORT))
#         print("Connected to message server.")
#         print("Type 'exit' to disconnect.")
#         while True:
#             message = input("Enter message: ")
#             if message.lower() == "exit":
#                 break
#             client.sendall(message.encode())
#             response = client.recv(1024).decode()
#             print("Server response:", response)
#     except ConnectionRefusedError:
#         print("Start the server before connecting.")
#     finally:
#         client.close()
#
# if __name__ == "__main__":
#     start_client()
#
# TASK 2A: RICART-AGRAWALA ALGORITHM (SIMULATION)
# Run as ricart_agrawala.py. This demonstrates timestamps, requests, replies and deferred replies.
#
# -------------------- ricart_agrawala.py --------------------
# class Process:
#     def __init__(self, process_id, total_processes):
#         self.pid = process_id
#         self.total = total_processes
#         self.clock = 0
#         self.request_timestamp = None
#         self.replies = set()
#         self.deferred_replies = set()
#         self.requesting = False
#         self.in_cs = False
#
#     def request_critical_section(self, processes):
#         self.clock += 1
#         self.request_timestamp = self.clock
#         self.requesting = True
#         self.replies = set()
#         print(f"\nP{self.pid} requests CS at timestamp {self.request_timestamp}")
#         for other in processes:
#             if other.pid != self.pid:
#                 other.receive_request(self.pid, self.request_timestamp, processes)
#         if len(self.replies) == self.total - 1:
#             self.enter_critical_section(processes)
#         else:
#             print(f"P{self.pid} waits for replies.")
#
#     def receive_request(self, sender_id, timestamp, processes):
#         self.clock = max(self.clock, timestamp) + 1
#         print(f"P{self.pid} receives REQUEST from P{sender_id}")
#         my_priority = (self.request_timestamp, self.pid) if self.requesting else None
#         sender_priority = (timestamp, sender_id)
#         if self.in_cs or (self.requesting and my_priority < sender_priority):
#             self.deferred_replies.add(sender_id)
#             print(f"P{self.pid} defers REPLY to P{sender_id}")
#         else:
#             self.send_reply(sender_id, processes)
#
#     def send_reply(self, receiver_id, processes):
#         receiver = processes[receiver_id]
#         receiver.replies.add(self.pid)
#         print(f"P{self.pid} sends REPLY to P{receiver_id}")
#
#     def enter_critical_section(self, processes):
#         if len(self.replies) != self.total - 1:
#             return
#         self.in_cs = True
#         print(f"*** P{self.pid} ENTERS critical section ***")
#         print(f"P{self.pid} is executing its task.")
#         self.release_critical_section(processes)
#
#     def release_critical_section(self, processes):
#         print(f"P{self.pid} RELEASES critical section.")
#         self.in_cs = False
#         self.requesting = False
#         self.request_timestamp = None
#         deferred = list(self.deferred_replies)
#         self.deferred_replies.clear()
#         for receiver_id in deferred:
#             self.send_reply(receiver_id, processes)
#
# def main():
#     total = 3
#     processes = [Process(i, total) for i in range(total)]
#     processes[0].request_critical_section(processes)
#     processes[1].request_critical_section(processes)
#
# if __name__ == "__main__":
#     main()
#
# TASK 2B: TOKEN RING ALGORITHM (SIMULATION)
# Run as token_ring.py. The token holder alone may enter the critical section.
#
# -------------------- token_ring.py --------------------
# class TokenRing:
#     def __init__(self, number_of_processes):
#         self.n = number_of_processes
#         self.token_holder = 0
#
#     def request_critical_section(self, process_id):
#         print(f"\nP{process_id} requests the critical section.")
#         if self.token_holder == process_id:
#             self.enter_critical_section(process_id)
#         else:
#             print(f"P{process_id} waits for the token.")
#             self.pass_token_until(process_id)
#
#     def pass_token_until(self, target_id):
#         while self.token_holder != target_id:
#             next_process = (self.token_holder + 1) % self.n
#             print(f"Token passed from P{self.token_holder} to P{next_process}")
#             self.token_holder = next_process
#         self.enter_critical_section(target_id)
#
#     def enter_critical_section(self, process_id):
#         print(f"P{process_id} ENTERS critical section.")
#         print(f"P{process_id} executes its task.")
#         print(f"P{process_id} LEAVES critical section.")
#         next_process = (process_id + 1) % self.n
#         self.token_holder = next_process
#         print(f"Token passed to P{next_process}.")
#
# def main():
#     ring = TokenRing(4)
#     ring.request_critical_section(2)
#     ring.request_critical_section(3)
#     ring.request_critical_section(1)
#
# if __name__ == "__main__":
#     main()
#
# TASK 2C: CENTRALIZED COORDINATOR ALGORITHM (SIMULATION)
# Run as centralized_coordinator.py. The coordinator grants one process access at a time.
#
# -------------------- centralized_coordinator.py --------------------
# from collections import deque
#
# class Coordinator:
#     def __init__(self):
#         self.cs_occupied = False
#         self.current_process = None
#         self.waiting_queue = deque()
#
#     def request(self, process_id):
#         print(f"\nP{process_id} sends REQUEST.")
#         if not self.cs_occupied:
#             self.grant_access(process_id)
#         elif process_id not in self.waiting_queue:
#             self.waiting_queue.append(process_id)
#             print(f"P{process_id} waits in the queue.")
#
#     def grant_access(self, process_id):
#         self.cs_occupied = True
#         self.current_process = process_id
#         print(f"Coordinator sends GRANT to P{process_id}.")
#         print(f"P{process_id} ENTERS critical section.")
#         print(f"P{process_id} executes its task.")
#
#     def release(self, process_id):
#         if self.current_process != process_id:
#             print(f"P{process_id} cannot release the CS.")
#             return
#         print(f"P{process_id} sends RELEASE.")
#         self.cs_occupied = False
#         self.current_process = None
#         if self.waiting_queue:
#             next_process = self.waiting_queue.popleft()
#             self.grant_access(next_process)
#
# def main():
#     coordinator = Coordinator()
#     coordinator.request(1)
#     coordinator.request(2)
#     coordinator.request(3)
#     coordinator.release(1)
#     coordinator.release(2)
#     coordinator.release(3)
#
# if __name__ == "__main__":
#     main()
#
# NOTE: Experiment 3 mutual-exclusion programs are algorithm simulations, not complete networked
# distributed implementations. A real implementation needs message transport and failure handling.
#
# ============================================================
# EXPERIMENT 4: CLOCK AND TIME SYNCHRONIZATION
# ============================================================
#
# TASK 1: LAMPORT LOGICAL CLOCK
# Run as lamport_clock.py.
#
# -------------------- lamport_clock.py --------------------
# class LamportClock:
#     def __init__(self, process_name):
#         self.process_name = process_name
#         self.clock = 0
#
#     def internal_event(self):
#         self.clock += 1
#         print(f"{self.process_name}: Internal event, clock = {self.clock}")
#
#     def send_message(self):
#         self.clock += 1
#         timestamp = self.clock
#         print(f"{self.process_name}: Sending message, timestamp = {timestamp}")
#         return timestamp
#
#     def receive_message(self, received_timestamp):
#         self.clock = max(self.clock, received_timestamp) + 1
#         print(
#             f"{self.process_name}: Received message with timestamp "
#             f"{received_timestamp}, updated clock = {self.clock}"
#         )
#
# def main():
#     p1 = LamportClock("P1")
#     p2 = LamportClock("P2")
#     print("INITIAL EVENTS")
#     p1.internal_event()
#     p2.internal_event()
#     print("\nMESSAGE TRANSMISSION: P1 -> P2")
#     timestamp = p1.send_message()
#     p2.receive_message(timestamp)
#     print("\nMORE EVENTS")
#     p2.internal_event()
#     print("\nMESSAGE TRANSMISSION: P2 -> P1")
#     timestamp = p2.send_message()
#     p1.receive_message(timestamp)
#     print("\nFINAL CLOCK VALUES")
#     print("P1 clock:", p1.clock)
#     print("P2 clock:", p2.clock)
#
# if __name__ == "__main__":
#     main()
#
# Expected final values: P1 clock = 6; P2 clock = 5.
#
# TASK 2: VECTOR CLOCK
# Run as vector_clock.py.
#
# -------------------- vector_clock.py --------------------
# class VectorClock:
#     def __init__(self, process_id, total_processes):
#         self.process_id = process_id
#         self.total_processes = total_processes
#         self.clock = [0] * total_processes
#
#     def internal_event(self):
#         self.clock[self.process_id] += 1
#         print(f"P{self.process_id}: Internal event, vector = {self.clock}")
#
#     def send_message(self):
#         self.clock[self.process_id] += 1
#         message_timestamp = self.clock.copy()
#         print(f"P{self.process_id}: Sending message, vector = {message_timestamp}")
#         return message_timestamp
#
#     def receive_message(self, received_vector):
#         for i in range(self.total_processes):
#             self.clock[i] = max(self.clock[i], received_vector[i])
#         self.clock[self.process_id] += 1
#         print(f"P{self.process_id}: Received message, vector = {self.clock}")
#
# def main():
#     p1 = VectorClock(0, 2)
#     p2 = VectorClock(1, 2)
#     print("INITIAL EVENTS")
#     p1.internal_event()
#     p2.internal_event()
#     print("\nMESSAGE TRANSMISSION: P1 -> P2")
#     message = p1.send_message()
#     p2.receive_message(message)
#     print("\nMORE EVENTS")
#     p2.internal_event()
#     print("\nMESSAGE TRANSMISSION: P2 -> P1")
#     message = p2.send_message()
#     p1.receive_message(message)
#     print("\nFINAL VECTOR CLOCKS")
#     print("P1:", p1.clock)
#     print("P2:", p2.clock)
#
# if __name__ == "__main__":
#     main()
#
# Expected final vectors: P1 = [3, 4]; P2 = [2, 4].
#
# ============================================================
# QUICK EXECUTION GUIDE
# ============================================================
# Experiment 1 Task 1: server1.py, then client1.py
# Experiment 1 Task 2: server2.py, then client2.py
# Experiment 2 Task 1: rmi_server.py, then rmi_client.py
# Experiment 2 Task 2: Use the gcloud commands above or the Google Cloud Console.
# Experiment 3 Task 1: message_server.py, then one or more message_client.py instances
# Experiment 3 Task 2: ricart_agrawala.py, token_ring.py, centralized_coordinator.py
# Experiment 4 Task 1: lamport_clock.py
# Experiment 4 Task 2: vector_clock.py
#
# IMPORTANT: In this combined reference, all code sections after the first program are commented
# so they do not accidentally run as one giant Python program. Remove the leading "# " from the
# chosen program section and save it in its own .py file before execution.
