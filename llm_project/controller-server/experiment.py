import requests

response = requests.post(
    "http://localhost:8000/generate",
    json={
        "model": "mistral", 
        "prompt": "Heyo!, tell me about Japan",
        "stream": False,
        }
)

print("Status Code:", response.status_code)
print("Response Text:", response.text)