#!/bin/bash
# Run this INSIDE the IBM Skills Network lab (Watson NLP is only reachable there):
#   cd /home/project
#   git clone https://github.com/atharva80/oaqjp-final-project-emb-ai.git final_project
#   cd final_project
#   bash submission/generate_outputs.sh
# It writes 2b, 3b, 4b, 5b and 8b into the submission/ folder.

cd "$(dirname "$0")/.." || exit 1
OUT=submission
P="$PWD\$"

python3 -m pip install -q requests flask pylint >/dev/null 2>&1

# ---- Task 2b: raw Watson output (Task 2 version of emotion_detection.py in project root)
cp "$OUT/2a_emotion_detection" emotion_detection.py
{
  echo "$P python3"
  echo ">>> from emotion_detection import emotion_detector"
  echo ">>> print(emotion_detector('I am really mad about this'))"
  python3 -c "from emotion_detection import emotion_detector; print(emotion_detector('I am really mad about this'))" 2>&1
  echo ">>> exit()"
  echo "$P python3 test_emotion_detection.py"
  python3 test_emotion_detection.py 2>&1
} | tee "$OUT/2b_application_creation"

# ---- Task 3b: formatted output (Task 3 version)
cp "$OUT/3a_output_formatting" emotion_detection.py
{
  echo "$P python3"
  echo ">>> from emotion_detection import emotion_detector"
  echo ">>> print(emotion_detector('I love this new technology.'))"
  python3 -c "from emotion_detection import emotion_detector; print(emotion_detector('I love this new technology.'))" 2>&1
  echo ">>> exit()"
} | tee "$OUT/3b_formatted_output_test"
rm -f emotion_detection.py
rm -rf __pycache__

# ---- Task 4b: package check
{
  echo "$P python3 -c \"from EmotionDetection.emotion_detection import emotion_detector; print(emotion_detector('I am very angry'))\""
  python3 -c "from EmotionDetection.emotion_detection import emotion_detector; print(emotion_detector('I am very angry'))" 2>&1
} | tee "$OUT/4b_packaging_test"

# ---- Task 5b: unit tests
{
  echo "$P python3 test_emotion_detection.py"
  python3 test_emotion_detection.py 2>&1
} | tee "$OUT/5b_unit_testing_result"

# ---- Task 8b: static code analysis
{
  echo "$P pylint server.py"
  python3 -m pylint server.py 2>&1
} | tee "$OUT/8b_static_code_analysis"

echo
echo "Done. Now take the two screenshots: run 'python3 server.py', open port 5000 via Skills Network > Launch Application."
