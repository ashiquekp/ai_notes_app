# AI-Powered Notes (Flutter)

A clean Flutter notes app with local JSON storage and optional AI summarization (OpenAI style API).
Uses Riverpod for state, file-based storage (no DB setup), and Material 3 UI.

## Features
- Create, edit, delete notes (title, body, tags).
- File-based local persistence using `path_provider` and `dart:io`.
- Optional AI Summarize button using a pluggable HTTP service (OpenAI compatible example included).
- Search & tag filtering, dark mode, responsive layout.

## Tech
- Flutter, Material 3
- Riverpod (flutter_riverpod)
- path_provider for storage
- http for AI API calls

## Setup
1. `flutter pub get`
2. Create a `.env` or add an env variable at runtime for your AI key (or paste into code for quick demo).
3. Run: `flutter run`

> Set `AIService.baseUrl` and `AIService.apiKey` in `lib/services/ai_service.dart`.

## Screenshots
(Add after running)
