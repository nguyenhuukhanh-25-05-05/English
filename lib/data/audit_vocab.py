import sys
sys.stdout.reconfigure(encoding='utf-8')

import re
import os

repo_path = r'd:\DEMO\english\lib\data'
topic_files = ['topics_1_5.dart', 'topics_6_10.dart', 'topics_11_15.dart', 'topics_16_20.dart']

all_words = []
word_to_topic = {}

def extract_words(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Simple regex to find words in VocabWord(word: '...', ...)
    # This might miss some if formatting is different, but let's try.
    matches = re.finditer(r"VocabWord\(\s*word:\s*'([^']+)'", content)
    words_in_file = []
    
    # Also find topic names to know where we are
    topic_matches = list(re.finditer(r"VocabTopic\(\s*name:\s*'([^']+)'", content))
    
    for match in matches:
        word = match.group(1)
        # Find which topic this word belongs to
        current_topic = "Unknown"
        for i in range(len(topic_matches)):
            if match.start() > topic_matches[i].start():
                current_topic = topic_matches[i].group(1)
        
        words_in_file.append((word, current_topic))
    
    return words_in_file

for tf in topic_files:
    path = os.path.join(repo_path, tf)
    if os.path.exists(path):
        words = extract_words(path)
        all_words.extend(words)

# Check for duplicates
seen = {}
duplicates = []
for word, topic in all_words:
    word_lower = word.lower().strip()
    if word_lower in seen:
        duplicates.append((word, topic, seen[word_lower]))
    else:
        seen[word_lower] = topic

print(f"Total words found: {len(all_words)}")
if duplicates:
    print("Duplicates found:")
    for word, topic, original_topic in duplicates:
        print(f"- '{word}' in '{topic}' (Original in '{original_topic}')")
else:
    print("No duplicates found.")

# Topic counts
topic_counts = {}
for word, topic in all_words:
    topic_counts[topic] = topic_counts.get(topic, 0) + 1

print("\nTopic counts:")
for topic, count in topic_counts.items():
    print(f"- {topic}: {count}")
