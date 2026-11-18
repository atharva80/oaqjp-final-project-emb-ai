# Final Project Submission – Emotion Detector

**Repository (fork):** https://github.com/atharva80/oaqjp-final-project-emb-ai
**Forked from:** https://github.com/ibm-developer-skills-network/oaqjp-final-project-emb-ai


---

## Q1 – Task 1: README.md URL
https://github.com/atharva80/oaqjp-final-project-emb-ai/blob/main/README.md

## Q2 – Task 2a: `2a_emotion_detection`
```python
import requests


def emotion_detector(text_to_analyze):
    url = 'https://sn-watson-emotion.labs.skills.network/v1/watson.runtime.nlp.v1/NlpService/EmotionPredict'
    headers = {"grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"}
    myobj = {"raw_document": {"text": text_to_analyze}}
    response = requests.post(url, json=myobj, headers=headers)
    return response.text
```

## Q3 – Task 2b: `2b_application_creation`
```
/home/axrva/coursera/emotion-detector-final-project$ python3
Python 3.12.3 (main, Aug 31 2026, 10:18:26) [GCC 13.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from emotion_detection import emotion_detector
>>> print(emotion_detector('I am really mad about this'))
{"emotionPredictions":[{"emotion":{"anger":0.8814331293106079,"disgust":0.01599598303437233,"fear":0.008482464589178562,"joy":0.004144033417105675,"sadness":0.031259890645742416},"emotionMentions":[],"target":""}],"producerId":{"name":"Ensemble Aggregated Emotion Workflow","version":"0.0.1"}}
>>> exit()
/home/axrva/coursera/emotion-detector-final-project$ python3 test_emotion_detection.py
.
----------------------------------------------------------------------
Ran 1 test in 0.068s

OK
```

## Q4 – Task 3a: `3a_output_formatting`
```python
import json
import requests


def emotion_detector(text_to_analyze):
    url = 'https://sn-watson-emotion.labs.skills.network/v1/watson.runtime.nlp.v1/NlpService/EmotionPredict'
    headers = {"grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"}
    myobj = {"raw_document": {"text": text_to_analyze}}
    response = requests.post(url, json=myobj, headers=headers)

    # Convert the response text into a dictionary
    formatted_response = json.loads(response.text)
    emotions = formatted_response['emotionPredictions'][0]['emotion']

    # Extract the required emotions and their scores
    result = {
        'anger': emotions['anger'],
        'disgust': emotions['disgust'],
        'fear': emotions['fear'],
        'joy': emotions['joy'],
        'sadness': emotions['sadness'],
    }

    # Find the dominant emotion (highest score)
    result['dominant_emotion'] = max(result, key=result.get)
    return result
```

## Q5 – Task 3b: `3b_formatted_output_test`
```
/home/axrva/coursera/emotion-detector-final-project$ python3
Python 3.12.3 (main, Aug 31 2026, 10:18:26) [GCC 13.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from emotion_detection import emotion_detector
>>> print(emotion_detector('I love this new technology.'))
{'anger': 0.0017507860902696848, 'disgust': 0.0014690696261823177, 'fear': 0.0004243014263920486, 'joy': 0.9846811294555664, 'sadness': 0.0033064521849155426, 'dominant_emotion': 'joy'}
>>> exit()
```

## Q6 – Task 4a: `__init__.py` URL
https://github.com/atharva80/oaqjp-final-project-emb-ai/blob/main/EmotionDetection/__init__.py

## Q7 – Task 4b: `4b_packaging_test`
```
/home/axrva/coursera/emotion-detector-final-project$ python3 -c "from EmotionDetection.emotion_detection import emotion_detector; print(emotion_detector('I am very angry'))"
{'anger': 0.9898738861083984, 'disgust': 0.0012881929287686944, 'fear': 0.002171236788854003, 'joy': 0.0005127525655552745, 'sadness': 0.002351535251364112, 'dominant_emotion': 'anger'}
```

## Q8 – Task 5a: `5a_unit_testing`
```python
"""Unit tests for the emotion_detector function."""
import unittest

from EmotionDetection.emotion_detection import emotion_detector


class TestEmotionDetector(unittest.TestCase):
    """Check that the dominant emotion is detected correctly."""

    def test_emotion_detector(self):
        """Each statement should return the expected dominant emotion."""
        self.assertEqual(emotion_detector("I am glad this happened")["dominant_emotion"], "joy")
        self.assertEqual(emotion_detector("I am really mad about this")["dominant_emotion"], "anger")
        self.assertEqual(
            emotion_detector("I feel disgusted just hearing about this")["dominant_emotion"],
            "disgust",
        )
        self.assertEqual(emotion_detector("I am so sad about this")["dominant_emotion"], "sadness")
        self.assertEqual(
            emotion_detector("I am really afraid that this will happen")["dominant_emotion"],
            "fear",
        )


if __name__ == "__main__":
    unittest.main()
```

## Q9 – Task 5b: `5b_unit_testing_result`
```
/home/axrva/coursera/emotion-detector-final-project$ python3 test_emotion_detection.py
.
----------------------------------------------------------------------
Ran 1 test in 0.066s

OK
```

## Q10 – Task 6a: `6a_server`
```python
"""Flask web server for the Emotion Detector application."""
from flask import Flask, render_template, request

from EmotionDetection.emotion_detection import emotion_detector

app = Flask("Emotion Detector")


@app.route("/emotionDetector")
def emot_detector():
    """Analyze the submitted text and return the emotion scores."""
    text_to_analyze = request.args.get("textToAnalyze")
    response = emotion_detector(text_to_analyze)

    return (
        f"For the given statement, the system response is "
        f"'anger': {response['anger']}, 'disgust': {response['disgust']}, "
        f"'fear': {response['fear']}, 'joy': {response['joy']} and "
        f"'sadness': {response['sadness']}. "
        f"The dominant emotion is {response['dominant_emotion']}."
    )


@app.route("/")
def render_index_page():
    """Render the main page of the application."""
    return render_template("index.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

## Q11 – Task 6b: `6b_deployment_test.png`
Upload `6b_deployment_test.png` (in this repo).

## Q12 – Task 7a: `7a_error_handling_function`
```python
"""Emotion detection using the Watson NLP EmotionPredict service."""
import json

import requests

URL = (
    "https://sn-watson-emotion.labs.skills.network/v1/"
    "watson.runtime.nlp.v1/NlpService/EmotionPredict"
)
HEADERS = {"grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"}
EMOTIONS = ("anger", "disgust", "fear", "joy", "sadness")


def emotion_detector(text_to_analyze):
    """Return the emotion scores and the dominant emotion for the given text."""
    payload = {"raw_document": {"text": text_to_analyze}}
    response = requests.post(URL, json=payload, headers=HEADERS, timeout=30)

    # Blank input: Watson returns 400, so every value is None
    if response.status_code == 400:
        result = {emotion: None for emotion in EMOTIONS}
        result["dominant_emotion"] = None
        return result

    emotions = json.loads(response.text)["emotionPredictions"][0]["emotion"]
    result = {emotion: emotions[emotion] for emotion in EMOTIONS}
    result["dominant_emotion"] = max(EMOTIONS, key=lambda emotion: result[emotion])
    return result
```

## Q13 – Task 7b: `7b_error_handling_server`
```python
"""Flask web server for the Emotion Detector application."""
from flask import Flask, render_template, request

from EmotionDetection.emotion_detection import emotion_detector

app = Flask("Emotion Detector")


@app.route("/emotionDetector")
def emot_detector():
    """Analyze the submitted text and return the emotion scores."""
    text_to_analyze = request.args.get("textToAnalyze")
    response = emotion_detector(text_to_analyze)

    if response["dominant_emotion"] is None:
        return "Invalid text! Please try again!"

    return (
        f"For the given statement, the system response is "
        f"'anger': {response['anger']}, 'disgust': {response['disgust']}, "
        f"'fear': {response['fear']}, 'joy': {response['joy']} and "
        f"'sadness': {response['sadness']}. "
        f"The dominant emotion is {response['dominant_emotion']}."
    )


@app.route("/")
def render_index_page():
    """Render the main page of the application."""
    return render_template("index.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

## Q14 – Task 7c: `7c_error_handling_interface.png`
Upload `7c_error_handling_interface.png` (in this repo).

## Q15 – Task 8a: `8a_server_modified`
Same code as Q13 (the final `server.py`, with module and function docstrings so pylint scores 10/10).

## Q16 – Task 8b: `8b_static_code_analysis`
```
$ pylint server.py

------------------------------------
Your code has been rated at 10.00/10
```
