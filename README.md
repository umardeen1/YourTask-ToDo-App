# YourTask

YourTask is a simple and clean Todo application built with Flutter. It is designed to help users manage their daily tasks efficiently with a smooth user interface and offline capabilities.

## Features
* **Add Todo:** Create tasks with a title, description, and pick a color.
* **View List:** See all your tasks in a clear, organized list.
* **Edit Todo:** Update your existing tasks whenever you need.
* **Delete Todo:** Remove tasks with a confirmation dialog to prevent accidental deletes.
* **Offline Support:** All your data is saved locally, so you can use the app without internet.

## Tech Stack
* **Flutter:** For building the cross-platform UI.
* **Drift:** Local database for persistent data storage.
* **GetX:** For simple and powerful state management.
* **MVC Architecture:** To keep the code clean and organized.

## Project Structure
A simple look at how the code is organized:

```text
lib/
├── controller/  # Business logic and state handling
├── data/        # Database setup and local storage
├── model/       # Database table definitions
└── view/        # UI screens and custom widgets
```



## Installation Steps
Follow these steps to run the project locally:

1. **Clone the repo:**
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

## How it Works
* The app uses **Drift** to create a local SQLite database on your device. This ensures your tasks are always available even when you are offline.
* **GetX** handles the communication between the UI and the data. When you add or delete a task, the screen updates automatically.
* The code follows the **MVC (Model-View-Controller)** pattern, making it easy to read and maintain.



## Author
* **Umar** - [GitHub Profile](https://github.com/umardeen1)
