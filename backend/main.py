import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

from createUser import insertUser
from userExists import checkUsername

load_dotenv()
origins = os.getenv('FRONTEND_ORIGINS').split(',')

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins = origins,
    allow_credentials = True,
    allow_methods = ['*'],
    allow_headers = ['*'])

@app.post('/login')
async def login(data: dict):
    print('Received', data)
    return {'message': 'got it'}

@app.post('/signup')
async def signup(data: dict):
    print('Received', data)
    return {'message': await insertUser(data['username'], data['password'])}

@app.post('/checkusername')
async def checkusername(data: dict):
    print('Reieved', data)
    return await checkUsername(data['username'])
