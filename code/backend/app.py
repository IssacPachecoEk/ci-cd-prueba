from fastapi import FastAPI
from mangum import Mangum

# app = FastAPI()
app = FastAPI(oot_path="/api")
@app.get("/hola")
async def read_hello():
    return {"message": " hola mundo"}

handler = Mangum(app)