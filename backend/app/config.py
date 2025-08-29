import os

class Config:
    # Change from:
    # SQLALCHEMY_DATABASE_URI = 'postgresql://username:password@localhost/keepers_db'
    
    db_user = os.getenv('DB_USER', 'postgres')
    db_pass = os.getenv('DB_PASS', 'mypass')
    db_host = os.getenv('DB_HOST', 'localhost')
    db_port = os.getenv('DB_PORT', '5431')
    db_name = os.getenv('DB_NAME', 'keepers_db')

    # To (add +psycopg):
    SQLALCHEMY_DATABASE_URI = f'postgresql+psycopg://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}'

    SQLALCHEMY_TRACK_MODIFICATIONS = False

class DevelopmentConfig(Config):
    DEBUG = True
    # Make sure this also uses +psycopg
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg://postgres:mypass@localhost:5431/keepers_db'

class ProductionConfig(Config):
    DEBUG = False

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig
}