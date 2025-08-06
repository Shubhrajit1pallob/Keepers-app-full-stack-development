from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

db = SQLAlchemy()
migrate = Migrate()     # Helps in managing database migrations

def create_app(config_class):
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    db.init_app(app)
    migrate.init_app(app, db)
    CORS(app)
    
    from app.routes.routes import notes_bp
    app.register_blueprint(notes_bp, url_prefix='/api')
    
    return app