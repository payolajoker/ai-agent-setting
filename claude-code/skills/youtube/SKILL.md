---
name: "youtube"
description: "Use when the user provides a YouTube URL and wants a summary or transcript. Triggers on: YouTube links, requests to summarize a video, '/youtube <URL>'. Extracts captions via youtube-transcript-api and produces a structured Korean summary."
user_invocable: true
---

# YouTube Video Summarizer

## When to use
- User provides a YouTube URL and asks for a summary
- User types `/youtube <URL>`
- User asks to extract or read a YouTube video's content

## Workflow

### 1. Extract video ID from URL
Supported formats:
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://youtube.com/shorts/VIDEO_ID`

### 2. Fetch transcript using Python

```bash
python -c "
import sys, json
from youtube_transcript_api import YouTubeTranscriptApi

video_id = 'VIDEO_ID'
ytt_api = YouTubeTranscriptApi()

# Try Korean first, then English, then any available
try:
    t = ytt_api.fetch(video_id, languages=['ko', 'en'])
except:
    t = ytt_api.fetch(video_id)

snippets = t.snippets
text = ' '.join([s.text for s in snippets])
print(text)
"
```

Replace `VIDEO_ID` with the actual video ID extracted in step 1.

### 3. Summarize the transcript

After fetching, provide a structured summary in Korean:

```
## [Video Title if available]

### 핵심 요약
- 3~5줄 핵심 내용

### 상세 내용
- 주요 토픽별 정리

### 키워드
- 영상에서 다룬 핵심 키워드 나열
```

## Error handling
- If no transcript is available: inform user that the video has no captions
- If video ID is invalid: ask user to check the URL
- If package is missing: run `pip install youtube-transcript-api`

## Notes
- Do NOT download the video itself — only fetch captions/subtitles
- Prefer Korean subtitles if available, fall back to English
- For very long transcripts (>10000 chars), chunk and summarize progressively
