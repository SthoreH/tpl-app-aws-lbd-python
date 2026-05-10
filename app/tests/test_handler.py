import json

from lambda_function import lambda_handler


# TODO: substitua estes testes pelos casos reais do seu Lambda.
# Mantenha o padrão test_should_<expected>_when_<condition>.

def test_should_return_status_200_when_event_is_valid():
    response = lambda_handler({"example_id": "abc-123"}, None)

    assert response["statusCode"] == 200


def test_should_return_event_in_body_when_event_is_valid():
    event = {"example_id": "abc-123", "name": "example value"}

    response = lambda_handler(event, None)

    assert json.loads(response["body"]) == event
