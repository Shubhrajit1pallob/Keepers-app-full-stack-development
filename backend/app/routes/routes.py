from flask import Blueprint, request, jsonify
from app import db
from app.models.model import Note

notes_bp = Blueprint('notes', __name__)

@notes_bp.route('/notes', methods=['GET', 'POST'])
def handle_notes():
    
    if request.method == 'GET':
        try:
            notes = Note.query.all()
            jsonData = [note.to_dict() for note in notes]
            return jsonify(jsonData)
        except Exception as e:
            return jsonify({"error": str(e)}), 500
    
    elif request.method == 'POST':
        try:
            data = request.get_json()
            
            if not data or 'title' not in data or 'content' not in data:
                return jsonify({'error': 'Title and content are required'}), 400
            
            note = Note(
                title=data['title'],
                content=data['content']
            )
            db.session.add(note)
            db.session.commit()
            return jsonify(note.to_dict()), 201
            
        except Exception as e:
            db.session.rollback()  # ← Important: rollback on error
            return jsonify({"error": str(e)}), 500

    # Always return a valid response if method is not GET or POST
    return jsonify({"error": "Method not allowed"}), 405


@notes_bp.route('/note/<int:note_id>/delete', methods=['DELETE'])
def delete_note(note_id):
    try:
        note = Note.query.get_or_404(note_id)  # Find note with this ID
        db.session.delete(note)
        db.session.commit()
        return jsonify({"message": "Note deleted successfully"}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 500
