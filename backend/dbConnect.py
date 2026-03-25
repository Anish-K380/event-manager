import asyncpg

async def connect():
    return await asyncpg.connect(
        user = 'user',
        host = 'localhost',
        database = 'mydb',
        port = 5433,
        password = 'password')
