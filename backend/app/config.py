import os

class Config:
    # Change from:
    # SQLALCHEMY_DATABASE_URI = 'postgresql://username:password@localhost/keepers_db'
    
    # To (add +psycopg):
    SQLALCHEMY_DATABASE_URI = 'postgresql+psycopg://postgres:mypass@localhost:5431/keepers_db'
    
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