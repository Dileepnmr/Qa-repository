import requests

# Define the base URL of the API
BASE_URL = "http://127.0.0.1:60454/"  # Replace with your backend URL

def test_get_message():
    # Define the endpoint URL
    url = f"{BASE_URL}"  # Replace with your endpoint

    # Make a GET request to the API
    response = requests.get(url)

    # Verify that the request was successful (status code 200)
    assert response.status_code == 200, f"Expected status code 200, but got {response.status_code}"

    response_text = response.text
    print("Response body as text:")
    print(response_text)

    # Define the expected message
    expected_message = "<h1>Hello from the Backend!</h1>"

    # Verify that the response matches the expected message
    assert response_text == expected_message, "test failed"

if __name__ == "__main__":
    import pytest
    pytest.main(["-v", __file__])

