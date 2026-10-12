============================================================
PART 1 — TASK SCHEDULING
TASK 1: IMPLEMENT TASK SCHEDULING WITH CLOUD SERVICES
============================================================

STEP 1: INSTALL PYTHON AND CRON
Run in Ubuntu terminal:
    sudo apt update
    sudo apt install python3 cron -y
    sudo systemctl enable --now cron

STEP 2: CREATE THE PYTHON TASK
    nano task.py

Paste this code into task.py:

    from datetime import datetime
    import os

    def scheduled_task():
        current_time = datetime.now()
        message = f"Task executed at: {current_time}\n"
        log_file = os.path.expanduser("~/task_log.txt")

        with open(log_file, "a") as file:
            file.write(message)

        print(message)

    if __name__ == "__main__":
        scheduled_task()

Save with Ctrl+O, Enter, then Ctrl+X.

STEP 3: TEST MANUALLY
    python3 task.py
    cat ~/task_log.txt

STEP 4: CONFIGURE CRON
Find the full path:
    realpath task.py

Open the Cron editor:
    crontab -e

Add this line, replacing YOUR_USERNAME and the script path with your actual values:
    * * * * * /usr/bin/python3 /home/YOUR_USERNAME/task.py

Save and exit. This runs the task every minute.

STEP 5: VERIFY
Wait one or two minutes, then run:
    crontab -l
    cat ~/task_log.txt

EXPECTED RESULT:
The log file contains a new timestamp for each scheduled execution.

NOTE: This demonstrates scheduling on Ubuntu using Cron. A managed cloud scheduler requires a cloud provider's scheduling service.
