# Maids.cc Test App

[you can view a live demo from here](demo.mp4)<br/>
Welcome to the Maids.cc Test App! This Android mobile application is a demonstration project by Maids.cc, utilizing a fake API (dummyjson) to simulate interactions with a real server. The app functions as a task manager, allowing users to log in, authenticate, and manage tasks. This README provides a comprehensive guide to understanding, using, and exploring the app.

## Table of Contents
1. [Features](#features)
2. [Getting Started](#getting-started)
3. [Usage](#usage)
4. [Design Decisions](#design-decisions)
5. [Challenges Faced](#challenges-faced)
6. [Technical Details](#technical-details)
7. [Best Practices Followed](#best-practices-followed)
8. [Unit Testing](#unit-testing)

## Features

- **User Authentication**: Users can log in using credentials registered with the fake API server. Authentication is managed using access tokens and refresh tokens.
- **Task Management**: Users can view all tasks, add new tasks, edit existing tasks, and delete tasks. Changes are stored in local storage due to the limitations of the fake API.
- **Local Storage**: Tokens and tasks are stored locally, allowing users to view and manage tasks even offline.
- **Pagination**: Tasks are fetched 10 at a time for efficient data handling and improved performance.
- **State Management**: The app utilizes the Provider package for state management.
- **Unit Testing**: Multiple services in the app are covered by unit tests to ensure functionality and reliability.

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or VS Code with Flutter extension
- A device or emulator running Android

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/maidscc/maids.cc_test.git
   ```
2. Navigate to the project directory:
   ```sh
   cd maids.cc_test
   ```
3. Get the dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Usage

1. **Login**: Enter your credentials to log in. The app uses the fake API to authenticate the user.
2. **View Tasks**: Once logged in, you can view a list of tasks. Tasks are fetched in batches of 10.
3. **Manage Tasks**:
    - **Add Task**: Add a new task using the provided form.
    - **Edit Task**: Edit an existing task by selecting it from the list.
    - **Delete Task**: Delete a task by selecting the delete option.
4. **Local Storage**: Tasks and tokens are stored locally. You can view saved tasks even if offline.
5. **Auto Refresh Token**: The app seamlessly refreshes the access token using the refresh token to ensure continuous authentication.

## Design Decisions

The app follows a basic design commonly seen in to-do applications, focusing on simplicity and usability:

- **User Interface**: A clean and straightforward UI design that allows users to focus on task management without distractions.
- **Navigation**: Simple navigation structure with a home screen for tasks, a login screen, a page to view each task and a drawer to view user 
  info, see information about the app, open a page to manage stored tasks and a button to logout.
- **State Management**: Provider is used for efficient state management, ensuring that the app remains responsive and performs well.

## Challenges Faced

While the app was relatively simple to develop, handling CRUD operations with a fake API presented some challenges:

- **Fake API Limitations**: Since the dummyjson API doesn't persist changes, all CRUD operations only affect the local state or local storage. This required additional logic to manage local changes without expecting a real server response.
- **Token Management**: Implementing seamless token refresh to handle the short-lived access tokens was a bit tricky but essential for smooth user experience.

## Technical Details

- **State Management**: Provider package is used to manage the app's state.
- **Local Storage**: Tasks and tokens are stored using Flutter's local storage solutions.
- **API Integration**: The app interacts with the dummyjson API for authentication and task data.
- **Pagination**: Fetching tasks in batches of 10 to optimize performance and reduce load times.
- **Unit Testing**: Comprehensive unit tests are implemented to ensure the app's services function correctly.

## Best Practices Followed

The development of this app adhered to Flutter best practices and coding standards, focusing on:

- **State Management**: Effective use of Provider for state management.
- **Performance**: Optimized for smooth UI interactions and efficient data handling.
- **Local Storage**: Proper handling of data persistence using local storage.
- **Unit Testing**: High coverage and quality of unit tests to validate app functionality.

## Unit Testing

Unit tests are implemented for various services in the app to ensure their validity and reliability. The tests cover:

- Authentication services
- Task management services
- Local storage interactions
- remote server interactions

By following rigorous testing practices, the app aims to maintain a high standard of quality and performance.

---

Thanks for Maids.cc for giving me the opportunity to build this App! If you have any questions or feedback, please feel free to reach out.
