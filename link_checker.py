import os
import requests
from datetime import datetime
import smtplib
from email.mime.text import MIMEText

urls = [
    "https://swimmersweb.com/",
    "https://swimmersweb.com/register",
    "https://swimmersweb.com/login",
    "https://swimmersweb.com/favorites",
    "https://swimmersweb.com/profile",
    "https://swimmersweb.com/privacy-policy",
    "https://swimmersweb.com/terms-conditions",
    "https://swimmersweb.com/contact",
    "https://swimmersweb.com/services",
    "https://swimmersweb.com/swimmer-search",
    "https://swimmersweb.com/swimmer-report",
    "https://swimmersweb.com/team-search",
    "https://swimmersweb.com/team-member-search",
    "https://swimmersweb.com/meet-search",
    "https://swimmersweb.com/meet-detail",
    "https://swimmersweb.com/motivational-time",
    "https://swimmersweb.com/swim-compare",
    "https://swimmersweb.com/tools",
    "https://swimmersweb.com/upcoming-meet",
    "https://swimmersweb.com/lap-timer"
]

def check_links(urls):
    broken = []
    full_report = []

    for url in urls:
        try:
            response = requests.get(url, timeout=10)
            status_code = response.status_code
            response_time = response.elapsed.total_seconds()

            if status_code != 200:
                broken.append(f"{url} - {status_code} ERROR - {response_time}s")

            full_report.append((url, status_code, response_time))

        except Exception as e:
            broken.append(f"{url} - Error: {str(e)}")
            full_report.append((url, f"Error: {str(e)}", "-"))

    return full_report, broken

def generate_report(broken_links):
    lines = [
        "🚨 SwimmersWeb - Broken Link Alert",
        f"🕒 Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        "",
        "❌ The following links are broken:"
    ]
    lines.extend(broken_links)
    return "\n".join(lines)

def send_email(report_text):
    msg = MIMEText(report_text)
    msg["Subject"] = "🚨 SwimmersWeb - Broken Link Detected"
    msg["From"] = os.environ["SMTP_USER"]
    msg["To"] = os.environ["EMAIL_TO"]

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(os.environ["SMTP_USER"], os.environ["SMTP_PASS"])
        server.send_message(msg)

if __name__ == "__main__":
    full_report, broken_links = check_links(urls)

    if broken_links:
        report_text = generate_report(broken_links)
        send_email(report_text)
        print("🚨 Email sent for broken links.")
    else:
        print("✅ All links are healthy. No email sent.")
