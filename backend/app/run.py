from app import create_app, db
from app.config import config

app = create_app(config['development']) # Use 'development' config for local testing

if __name__ == "__main__":
    with app.app_context():
        db.create_all()
    
    app.run(debug=False, port=8888, host='0.0.0.0')