from dbConnect import connect

async def checkUsername(username):
    conn = await connect()

    return await conn.fetchval('select exists (select 1 from users where username = $1)', username)
