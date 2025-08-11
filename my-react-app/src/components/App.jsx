import React, { useEffect, useState } from 'react'
import axios from "axios";
import Header from "./Header";
import Footer from "./Footer";
import Note from "./Note";
import CreateArea from "./CreateArea";

const API_BASE_URL = "http://localhost:8888/api";

function App() {
  const [notes, setNotes] = useState([]);

  useEffect(() => {
    fetchNotes();
  }, []);

  const fetchNotes = async () => {
    try {
      const response = await axios.get(`${API_BASE_URL}/notes`);
      setNotes(response.data);
    } catch (e) {
      console.error("Error fetching notes:", e);
      // Optionally, you can set notes to an empty array if the fetch fails
      setNotes([]);
    }
  }


  // Old code with out the API
  // function addNote(newNote) {
  //   setNotes((prevNotes) => {
  //     return [...prevNotes, newNote];
  //   });
  // }

  const  addNote = async (newNote) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/notes`, newNote);
      setNotes((prevNotes) => {
        return [...prevNotes, response.data];
      });
    } catch (e) {
      console.error("Error adding note:", e);
      // Optionally, you can handle the error by showing a message to the user
      alert("Failed to add note. Please try again.");
      // You might also want to fetch the notes again to ensure the UI is in sync
      fetchNotes();
    }
  }

  // This is the old code without the API
  // function deleteNote(id) {
  //   setNotes((prevNotes) => {
  //     return prevNotes.filter((noteItem, index) => {
  //       return index !== id;
  //     });
  //   });
  // }

const deleteNote = async (noteId) => {
  try {
    await axios.delete(`${API_BASE_URL}/note/${noteId}/delete`);
    setNotes((prevNotes) => {
      return prevNotes.filter((note) => {return note.id !== noteId});
    });
  } catch (error) {
    console.error("Error deleting note:", error);
    alert("Failed to delete note. Please try again.");
    // Optionally, you can fetch the notes again to ensure the UI is in sync
    fetchNotes();
  }
}

  return (
    <div>
      <Header />
      <CreateArea onAdd={addNote} />
      {notes.map((noteItem) => {
        return (
          <Note
            key={noteItem.id}
            id={noteItem.id}
            title={noteItem.title}
            content={noteItem.content}
            onDelete={deleteNote}
          />
        );
      })}
      <Footer />
    </div>
  );
}

export default App
