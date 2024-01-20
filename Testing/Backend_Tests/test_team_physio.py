

import requests


def test_adc_manager():
    url = 'http://127.0.0.1:8000/register_manager'
    headers = {'Content-Type': 'application/json'}
    json = {
        "manager_email": "testmanager@gmail.com",
        "manager_password": "Testpassword123!",
        "manager_firstname": "test",
        "manager_surname": "tester",
        "manager_contact_number": "012345",
        "manager_image": "something"
    
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'
    assert response.status_code == 200

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Manager Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['manager_id'] == 1
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_add_league():
    url = 'http://127.0.0.1:8000/leagues/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "league_name": "Louth GAA"
    }
    response = requests.post(url, headers=headers, json=json)

    # assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "League inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_sport():
    url = 'http://127.0.0.1:8000/sports/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "sport_name": "Gaelic Rugby"
    }
    response = requests.post(url, headers=headers, json=json)

    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Sport inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200  

    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_add_team():
    url = 'http://127.0.0.1:8000/teams/'
    headers = {'Content-Type': 'application/json'}
    json = {
        "team_name": "Louth Under 21s GAA",
        "team_logo": "b'url",
        "manager_id": 1,
        "league_id": 1,
        "sport_id": 1,
        "team_location": "Dundalk, Louth"
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Team inserted successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
        assert response.status_code == 200
    
    except (ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"


def test_add_physio():
    url = 'http://127.0.0.1:8000/register_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "physio_email": "testphysio@gmail.com",
        "physio_password": "Testpassword123!",
        "physio_firstname": "test",
        "physio_surname": "tester",
        "physio_contact_number": "012345"
    }
    response = requests.post(url, headers=headers, json=json)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Physio Registered Successfully"
        assert 'id' in response_json
        assert response_json['id']['physio_id'] == 1
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_add_team_physio():
    url = 'http://127.0.0.1:8000/team_physio'
    headers = {'Content-Type': 'application/json'}
    json = {
        "team_id": 1,
        "physio_id": 1
    }
    response = requests.post(url, headers=headers, json=json)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Physio with ID 1 has been added to team with ID 1"

    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_team_physio():
    url = 'http://127.0.0.1:8000/team_physio/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.get(url, headers=headers)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    expected_data = [{
        "team_id": 1,
        "physio_id": 1
    }]
    try:
        response_json = response.json()
        assert response_json == expected_data
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_delete_team_physio():
    url = 'http://127.0.0.1:8000/team_physio/1'
    headers = {'Content-Type': 'application/json'}

    response = requests.delete(url, headers=headers)
    #assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'
    try:
        response_json = response.json()
        assert response_json.get("message") == "Physio from Team with ID 1 has been deleted"
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200