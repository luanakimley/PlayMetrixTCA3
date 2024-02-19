import requests
import base64

def test_a_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200

def test_add_player():
    url = 'http://127.0.0.1:8000/register_player'
    headers = {'Content-Type': 'application/json'}
    json = {
        "player_email": "testplayer@gmail.com",
        "player_password": "Testpassword123!",
        "player_firstname": "Nigel",
        "player_surname": "Farage",
        "player_height": "1.80m",
        "player_gender": "Male",
        "player_dob": "1999-05-31",
        "player_contact_number": "30888802",
        "player_image" : "001231"
    }
    response = requests.post(url, headers=headers, json=json)
    
    assert response.headers['Content-Type'] == 'application/json'

    try:
        
        response_json = response.json()
        assert response_json.get('detail') == "Player Registered Successfully"
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
        "physio_contact_number": "012345",
        "physio_image": ""
    }
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("detail") == "Physio Registered Successfully"
        assert 'id' in response_json
        assert response_json['id'] == 1
    
    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"




# def test_add_player_physio():
#     url = 'http://127.0.0.1:8000/player_physio'
#     headers = {'Content-Type': 'application/json'}
#     json = {
#         "physio_id": 1,
#         "player_id": 1,
#         "player_injury_reports": None
#     }

    
#     response = requests.post(url, headers=headers, json=json)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'

#     try:
#         response_json = response.json()
#         assert response_json.get("message") == "Physio with ID 1 has been added to player with ID 1"

#     except(ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"

# def test_get_player_physio():
#     url = 'http://127.0.0.1:8000/player_physio/1'
#     headers = {'Content-Type': 'application/json'}
    
#     response = requests.get(url, headers=headers)
#     assert response.status_code == 200
#     assert response.headers['Content-Type'] == 'application/json'

#     try:
#         expected_json = [{
#         "player_id": 1,
#         "physio_id": 1,
#         "player_injury_reports": None
#     }]
#         response_json = response.json()
#         assert response_json == expected_json

#     except(ValueError, AssertionError) as e:
#         assert False, f"Test failed: {e}"


# def test_add_cleanup():
#     url = 'http://127.0.0.1:8000/cleanup_tests'
#     headers = {'Content-Type': 'application/json'}
#     response = requests.delete(url, headers=headers)
#     assert response.status_code == 200





def test_add_player_physio_pdf():
    url = 'http://127.0.0.1:8000/player_physio'
    headers = {'Content-Type': 'application/json'}
    with open("Backend\Sample.pdf", "rb") as pdf_file:
            encoded_string = base64.b64encode(pdf_file.read())
            encoded_string = encoded_string.decode() 
    json = {
        "physio_id": 1,
        "player_id": 1,
        "player_injury_reports": encoded_string
    }

    
    response = requests.post(url, headers=headers, json=json)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        response_json = response.json()
        assert response_json.get("message") == "Physio with ID 1 has been added to player with ID 1"

    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"

def test_get_player_physio():
    url = 'http://127.0.0.1:8000/player_physio/1'
    headers = {'Content-Type': 'application/json'}
    
    response = requests.get(url, headers=headers)
    assert response.status_code == 200
    assert response.headers['Content-Type'] == 'application/json'

    try:
        expected_json = [{
        "player_id": 1,
        "physio_id": 1,
        "player_injury_reports": "JVBERi0xLjcNCiW1tbW1DQoxIDAgb2JqDQo8PC9UeXBlL0NhdGFsb2cvUGFnZXMgMiAwIFIvTGFuZyhlbikgL1N0cnVjdFRyZWVSb290IDE1IDAgUi9NYXJrSW5mbzw8L01hcmtlZCB0cnVlPj4vTWV0YWRhdGEgMjkgMCBSL1ZpZXdlclByZWZlcmVuY2VzIDMwIDAgUj4+DQplbmRvYmoNCjIgMCBvYmoNCjw8L1R5cGUvUGFnZXMvQ291bnQgMS9LaWRzWyAzIDAgUl0gPj4NCmVuZG9iag0KMyAwIG9iag0KPDwvVHlwZS9QYWdlL1BhcmVudCAyIDAgUi9SZXNvdXJjZXM8PC9Gb250PDwvRjEgNSAwIFIvRjIgMTIgMCBSPj4vRXh0R1N0YXRlPDwvR1MxMCAxMCAwIFIvR1MxMSAxMSAwIFI+Pi9Qcm9jU2V0Wy9QREYvVGV4dC9JbWFnZUIvSW1hZ2VDL0ltYWdlSV0gPj4vTWVkaWFCb3hbIDAgMCA1OTUuNCA4NDEuOF0gL0NvbnRlbnRzIDQgMCBSL0dyb3VwPDwvVHlwZS9Hcm91cC9TL1RyYW5zcGFyZW5jeS9DUy9EZXZpY2VSR0I+Pi9UYWJzL1MvU3RydWN0UGFyZW50cyAwPj4NCmVuZG9iag0KNCAwIG9iag0KPDwvRmlsdGVyL0ZsYXRlRGVjb2RlL0xlbmd0aCAyNDU+Pg0Kc3RyZWFtDQp4nLWQO2sDMRCEe4H+w5R24HS7epwkOFTcw8YhLoIPUoQULpyrcuTx/yE6O0WcFHkRVTvLoJ1vUO4e9xPquty2mw5UXu2nEYvDVGz6ZUpouhZPUpCi+YXgNQguOmURLKuA54MUNxeYpGgGKcoVgxnDvRScjQSGdqRCgHdRmYDhIZvWOyaML/lbjCfJb3ItxW2d7zTEXCVXExsmdi4VJs+6mVe0smS6OLuOsu2S/cJoibRORZV3pk93GC6l6HPcayl+BKc/whlrldPv4Y5IJ5AFlmen0G9b4Lxw/nPhnzLp6JWHN5WK/jeR9L9FYvvdll4BaRmFvg0KZW5kc3RyZWFtDQplbmRvYmoNCjUgMCBvYmoNCjw8L1R5cGUvRm9udC9TdWJ0eXBlL1R5cGUwL0Jhc2VGb250L0JDREVFRStBcHRvcy9FbmNvZGluZy9JZGVudGl0eS1IL0Rlc2NlbmRhbnRGb250cyA2IDAgUi9Ub1VuaWNvZGUgMjUgMCBSPj4NCmVuZG9iag0KNiAwIG9iag0KWyA3IDAgUl0gDQplbmRvYmoNCjcgMCBvYmoNCjw8L0Jhc2VGb250L0JDREVFRStBcHRvcy9TdWJ0eXBlL0NJREZvbnRUeXBlMi9UeXBlL0ZvbnQvQ0lEVG9HSURNYXAvSWRlbnRpdHkvRFcgMTAwMC9DSURTeXN0ZW1JbmZvIDggMCBSL0ZvbnREZXNjcmlwdG9yIDkgMCBSL1cgMjcgMCBSPj4NCmVuZG9iag0KOCAwIG9iag0KPDwvT3JkZXJpbmcoSWRlbnRpdHkpIC9SZWdpc3RyeShBZG9iZSkgL1N1cHBsZW1lbnQgMD4+DQplbmRvYmoNCjkgMCBvYmoNCjw8L1R5cGUvRm9udERlc2NyaXB0b3IvRm9udE5hbWUvQkNERUVFK0FwdG9zL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50IDkzOS9EZXNjZW50IC0yODIvQ2FwSGVpZ2h0IDkzOS9BdmdXaWR0aCA1NjEvTWF4V2lkdGggMTY4Mi9Gb250V2VpZ2h0IDQwMC9YSGVpZ2h0IDI1MC9TdGVtViA1Ni9Gb250QkJveFsgLTUwMCAtMjgyIDExODIgOTM5XSAvRm9udEZpbGUyIDI2IDAgUj4+DQplbmRvYmoNCjEwIDAgb2JqDQo8PC9UeXBlL0V4dEdTdGF0ZS9CTS9Ob3JtYWwvY2EgMT4+DQplbmRvYmoNCjExIDAgb2JqDQo8PC9UeXBlL0V4dEdTdGF0ZS9CTS9Ob3JtYWwvQ0EgMT4+DQplbmRvYmoNCjEyIDAgb2JqDQo8PC9UeXBlL0ZvbnQvU3VidHlwZS9UcnVlVHlwZS9OYW1lL0YyL0Jhc2VGb250L0JDREZFRStBcHRvcy9FbmNvZGluZy9XaW5BbnNpRW5jb2RpbmcvRm9udERlc2NyaXB0b3IgMTMgMCBSL0ZpcnN0Q2hhciAzMi9MYXN0Q2hhciAzMi9XaWR0aHMgMjggMCBSPj4NCmVuZG9iag0KMTMgMCBvYmoNCjw8L1R5cGUvRm9udERlc2NyaXB0b3IvRm9udE5hbWUvQkNERkVFK0FwdG9zL0ZsYWdzIDMyL0l0YWxpY0FuZ2xlIDAvQXNjZW50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aWNyb3NvZnTCriBXb3JkIGZvciBNaWNyb3NvZnQgMzY1PC9wZGY6UHJvZHVjZXI+PC9yZGY6RGVzY3JpcHRpb24+CjxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iPgo8ZGM6Y3JlYXRvcj48cmRmOlNlcT48cmRmOmxpPk5hdGhhbiBGaWVsZDwvcmRmOmxpPjwvcmRmOlNlcT48L2RjOmNyZWF0b3I+PC9yZGY6RGVzY3JpcHRpb24+CjxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSIiICB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iPgo8eG1wOkNyZWF0b3JUb29sPk1pY3Jvc29mdMKuIFdvcmQgZm9yIE1pY3Jvc29mdCAzNjU8L3htcDpDcmVhdG9yVG9vbD48eG1wOkNyZWF0ZURhdGU+MjAyNC0wMi0xN1QxODoxNzowOCswMDowMDwveG1wOkNyZWF0ZURhdGU+PHhtcDpNb2RpZnlEYXRlPjIwMjQtMDItMTdUMTg6MTc6MDgrMDA6MDA8L3htcDpNb2RpZnlEYXRlPjwvcmRmOkRlc2NyaXB0aW9uPgo8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiAgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iPgo8eG1wTU06RG9jdW1lbnRJRD51dWlkOjU3MEYzQjgzLTY4MjQtNERDMS1BODQ4LTQ5RjBCRDUwMDk4MDwveG1wTU06RG9jdW1lbnRJRD48eG1wTU06SW5zdGFuY2VJRD51dWlkOjU3MEYzQjgzLTY4MjQtNERDMS1BODQ4LTQ5RjBCRDUwMDk4MDwveG1wTU06SW5zdGFuY2VJRD48L3JkZjpEZXNjcmlwdGlvbj4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCjwvcmRmOlJERj48L3g6eG1wbWV0YT48P3hwYWNrZXQgZW5kPSJ3Ij8+DQplbmRzdHJlYW0NCmVuZG9iag0KMzAgMCBvYmoNCjw8L0Rpc3BsYXlEb2NUaXRsZSB0cnVlPj4NCmVuZG9iag0KMzEgMCBvYmoNCjw8L1R5cGUvWFJlZi9TaXplIDMxL1dbIDEgNCAyXSAvUm9vdCAxIDAgUi9JbmZvIDE0IDAgUi9JRFs8ODMzQjBGNTcyNDY4QzE0REE4NDg0OUYwQkQ1MDA5ODA+PDgzM0IwRjU3MjQ2OEMxNERBODQ4NDlGMEJENTAwOTgwPl0gL0ZpbHRlci9GbGF0ZURlY29kZS9MZW5ndGggMTEzPj4NCnN0cmVhbQ0KeJw1zT0SQEAMBeC3dv0Mo9C4BKXCRZxCw5FwBYXKGcwoFM6hJvLYIt8k2SSAvPs2EjPgZSKnYi7FVmQmm+JawqI/kEMJUsJeOAKe7MzhiE8CEhJLvp+RzEXLnxniSTHudWfCQ8WqlA3plHoHHrqgEKMNCmVuZHN0cmVhbQ0KZW5kb2JqDQp4cmVmDQowIDMyDQowMDAwMDAwMDE1IDY1NTM1IGYNCjAwMDAwMDAwMTcgMDAwMDAgbg0KMDAwMDAwMDE2MyAwMDAwMCBuDQowMDAwMDAwMjE5IDAwMDAwIG4NCjAwMDAwMDA1MDEgMDAwMDAgbg0KMDAwMDAwMDgyMCAwMDAwMCBuDQowMDAwMDAwOTQ4IDAwMDAwIG4NCjAwMDAwMDA5NzYgMDAwMDAgbg0KMDAwMDAwMTEzMSAwMDAwMCBuDQowMDAwMDAxMjA0IDAwMDAwIG4NCjAwMDAwMDE0NDEgMDAwMDAgbg0KMDAwMDAwMTQ5NSAwMDAwMCBuDQowMDAwMDAxNTQ5IDAwMDAwIG4NCjAwMDAwMDE3MTYgMDAwMDAgbg0KMDAwMDAwMTk1NCAwMDAwMCBuDQowMDAwMDAwMDE2IDY1NTM1IGYNCjAwMDAwMDAwMTcgNjU1MzUgZg0KMDAwMDAwMDAxOCA2NTUzNSBmDQowMDAwMDAwMDE5IDY1NTM1IGYNCjAwMDAwMDAwMjAgNjU1MzUgZg0KMDAwMDAwMDAyMSA2NTUzNSBmDQowMDAwMDAwMDIyIDY1NTM1IGYNCjAwMDAwMDAwMjMgNjU1MzUgZg0KMDAwMDAwMDAyNCA2NTUzNSBmDQowMDAwMDAwMDAwIDY1NTM1IGYNCjAwMDAwMDI2NzMgMDAwMDAgbg0KMDAwMDAwMzAzMSAwMDAwMCBuDQowMDAwMDExMTk4IDAwMDAwIG4NCjAwMDAwMTEzNDkgMDAwMDAgbg0KMDAwMDAxMTM3NiAwMDAwMCBuDQowMDAwMDE0NTQ3IDAwMDAwIG4NCjAwMDAwMTQ1OTIgMDAwMDAgbg0KdHJhaWxlcg0KPDwvU2l6ZSAzMi9Sb290IDEgMCBSL0luZm8gMTQgMCBSL0lEWzw4MzNCMEY1NzI0NjhDMTREQTg0ODQ5RjBCRDUwMDk4MD48ODMzQjBGNTcyNDY4QzE0REE4NDg0OUYwQkQ1MDA5ODA+XSA+Pg0Kc3RhcnR4cmVmDQoxNDkwNg0KJSVFT0YNCnhyZWYNCjAgMA0KdHJhaWxlcg0KPDwvU2l6ZSAzMi9Sb290IDEgMCBSL0luZm8gMTQgMCBSL0lEWzw4MzNCMEY1NzI0NjhDMTREQTg0ODQ5RjBCRDUwMDk4MD48ODMzQjBGNTcyNDY4QzE0REE4NDg0OUYwQkQ1MDA5ODA+XSAvUHJldiAxNDkwNi9YUmVmU3RtIDE0NTkyPj4NCnN0YXJ0eHJlZg0KMTU3MDMNCiUlRU9G"
    }]
        response_json = response.json()
        assert response_json == expected_json

    except(ValueError, AssertionError) as e:
        assert False, f"Test failed: {e}"



def test_z_cleanup():
    url = 'http://127.0.0.1:8000/cleanup_tests'
    headers = {'Content-Type': 'application/json'}
    response = requests.delete(url, headers=headers)
    assert response.status_code == 200