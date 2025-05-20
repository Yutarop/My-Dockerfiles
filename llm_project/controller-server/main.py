from fastapi import FastAPI
from pydantic import BaseModel
import requests

app = FastAPI()

class PromptRequest(BaseModel):
    prompt: str

# ALLOWED_IPS = ["192.168.100.235", "192.168.100.238", "192.168.100.239"]

# @app.middleware("http")
# async def allow_only_specific_ips(request: requests, call_next):
#     client_ip = request.client.host
#     if client_ip not in ALLOWED_IPS:
#         raise BaseException(status_code=403, detail="Access denied")
#     response = await call_next(request)
#     return response

@app.get("/")
def read_root():
    return {"message": "Hello from Controller Server!"}

@app.post("/generate")
async def generate_text(request: PromptRequest):
    response = requests.post(
        "http://ollama-server:11434/api/generate",
        json={
            "model": "mistral", 
            "prompt": request.prompt,
            "stream": False,
        }
    )

    return response.json()
