import asyncio
import asyncpg
from dbConnect import connect
from hashing import encrypt

async def insertUser(username: str, password: str):
    conn = await connect()

    result = await conn.fetchval('insert into users (username, password_hash) values ($1, $2) on conflict (username) do nothing returning id', username, await asyncio.to_thread(encrypt, password))

    print(result)
