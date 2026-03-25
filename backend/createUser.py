import asyncio
import asyncpg
from dbConnect import connect
from hashing import encrypt
from passwordStrength import passwordStrength

async def insertUser(username: str, password: str):
    if len(password) < 8:return 1
    if await asyncio.to_thread(passwordStrength, password) < 2:return 2
    conn = await connect()

    result = await conn.fetchval('insert into users (username, password_hash) values ($1, $2) on conflict (username) do nothing returning id', username, await asyncio.to_thread(encrypt, password))

    if result is None:return 3
    return 0
