# Flutter Project

## Overview

This is a Flutter project for managing tasks.

## Prerequisites

Before you begin, ensure you have met the following requirements:

- You have installed Flutter 3.17.0 and Dart 3.3.0
- You have installed an IDE such as Android Studio or Visual Studio Code

## Installation

1. **Clone the repository:**

    ```bash
    git clone https://github.com/pbrandl/oped_flutter.git
    cd oped_flutter
    ```

2. **Get dependencies:**

    ```bash
    flutter pub get
    ```

3. **Run the app:**

    ```bash
    flutter run
    ```

## CORS Troubleshooting

In combination with Flutter you may need to add your port as `localhost:xxxx` in `opeddjango/settings.py` in `CORS_ALLOWED_ORIGINS` to use the API.  
