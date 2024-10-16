import pytest
from app import app, notes

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_index(client):
    response = client.get('/')
    assert response.status_code == 200
    assert b'Notes' in response.data

def test_add_note(client):
    response = client.post('/add', data={'note': 'Test Note'}, follow_redirects=True)
    assert response.status_code == 200
    assert b'Test Note' in response.data

def test_delete_note(client):
    notes.append('Note to be deleted')
    note_id = len(notes) - 1
    response = client.get(f'/delete/{note_id}', follow_redirects=True)
    assert response.status_code == 200
    assert b'Note to be deleted' not in response.data
