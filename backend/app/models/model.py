from app import db
from datetime import datetime

class Note(db.Model):
    __tablename__ = 'notes'
    
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(500), nullable=False)
    content = db.Column(db.Text, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now)
    updated_at = db.Column(db.DateTime, default=datetime.now, onupdate=datetime.now)
    
    def to_dict (self):
        return {
            'id': self.id,
            'title': self.title,
            'content': self.content
        }
    
    def __repr__(self):
        return f"<Note {self.title}>"