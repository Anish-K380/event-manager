from zxcvbn import zxcvbn

def passwordStrength(password):
    return zxcvbn(password)['score']
