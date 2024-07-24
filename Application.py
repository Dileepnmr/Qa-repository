import requests

def check_application_status(url):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            print(f"The application at {url} is UP and functioning correctly.")
        else:
            print(f"The application at {url} is DOWN. HTTP Status Code: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"The application at {url} is DOWN. Error: {e}")

# Example usage
if __name__ == "__main__":
    app_url = "http://example.com"  # Replace with the actual URL of the application
    check_application_status(app_url)
