# Flutter GitHub Insights

## Screenshots

Below are some screenshots of the app. Please ensure new screenshots are added to the `screenshots/` folder and referenced here with clear captions.

| Home Screen                        | Repository Details                  | Collaborators View                  |
|:-----------------------------------:|:-----------------------------------:|:-----------------------------------:|
| ![Home Screen](screenshots/feature-home.png) | ![Repository Details](screenshots/feature-repo-details.png) | ![Collaborators View](screenshots/feature-collaborators.png) |

*Home screen showing list of repositories*  
*Repository details with commit history*  
*Collaborators and their contributions*

---

## Project Description

Flutter GitHub Insights is a cross-platform mobile app that provides analytics and insights into GitHub repositories. It allows users to view repository statistics, collaborators, commit history, and more, leveraging the GitHub API and Firebase for authentication and data storage.

---

## Features

- GitHub OAuth authentication
- List and search repositories
- View repository details and statistics
- See collaborators and their contributions
- Commit history and stats visualization
- Offline data caching with Hive
- Light and dark themes

---

## Project Overview for New Contributors

This project is structured to separate concerns and make contributions straightforward. Here’s a high-level overview:

### Major Folders

- **lib/**: Main Dart source code for the Flutter app.
  - **data/models/**: Data models for repositories, commits, collaborators, etc.
  - **riverpod/**: State management using Riverpod (providers for auth, routing, etc.).
  - **firebase_options.dart**: Firebase configuration.
  - **main.dart**: App entry point, initializes Firebase, Hive, and sets up providers.
- **screenshots/**: Contains screenshots referenced in the README and PRs.
- **android/**, **ios/**, **web/**: Platform-specific configuration for Flutter.
- **test/**: Unit and widget tests.

### Important Files

- `lib/main.dart`: App initialization, dependency setup, and root widget.
- `lib/riverpod/auth_provider.dart`: Handles authentication state.
- `lib/riverpod/router.dart`: App routing configuration.
- `lib/data/models/`: Contains all data models used throughout the app.

### Architecture & Component Interaction

- **Frontend**: Built with Flutter, using Riverpod for state management.
- **Backend**: Interacts with GitHub’s REST API for data and Firebase for authentication.
- **Database**: Uses Hive (local NoSQL) for offline caching of repositories, commits, and collaborators.
- **Authentication**: Managed via Firebase Auth (OAuth with GitHub).
- **Routing**: Declarative navigation using Flutter’s Router API and Riverpod.

---

## Getting Started

Follow these steps to set up your development environment and run the project locally:

1. **Clone the repository**
   ```sh
   git clone https://github.com/yourusername/flutter_github_insights.git
   cd flutter_github_insights
   ```

2. **Install Flutter**
   - Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) for your OS.

3. **Install dependencies**
   ```sh
   flutter pub get
   ```

4. **Set up Firebase**
   - Follow the instructions in `lib/firebase_options.dart` or use the FlutterFire CLI to configure Firebase for your platform.

5. **Run the app**
   ```sh
   flutter run
   ```

6. **(Optional) Running tests**
   ```sh
   flutter test
   ```

---

## Roadmap

- [ ] Add more detailed repository analytics
- [ ] Improve UI/UX for mobile and tablet
- [ ] Add support for organization insights
- [ ] Implement notifications for repo changes
- [ ] Localization and accessibility improvements

---

## Contributing Guidelines

We welcome contributions! Please follow these guidelines:

- Fork the repository and create your branch from `main`.
- Every pull request (PR) **must include relevant app screenshots** showing the changes made.
  - Add screenshots to the `screenshots/` folder.
  - Update the **Screenshots** section in the README to include new screenshots with captions/context.
  - Ensure screenshots are clearly labeled (e.g., `feature-login.png`, `fix-navbar-bug.png`) and correspond to the PR functionality.
- Write clear commit messages and PR descriptions.
- Ensure your code passes all tests and lints.
- For major changes, please open an issue first to discuss what you would like to change.

---

Happy coding! 🚀
### About The Project

The project is a Flutter application that integrates with Firebase Authentication to allow users to log in using their GitHub accounts. Once authenticated, users can view all their repositories, both private and public, and perform various actions such as creating new repositories and adding files to existing ones.

### Technical Implementation

**Build steps**
https://developers.google.com/android/guides/client-auth ```keytool -list -v \
-alias androiddebugkey -keystore ~/.android/debug.keystore```![image](https://github.com/user-attachments/assets/aac7528a-fb52-4131-8d0f-64782b5d6af9)

**Auth Setup - Optional**
  * Enable authentication in your firebase project
  * Enable GitHub provider in Sign-in method
  * It requires clientId and client secret of your github developer OAuth app.
  * For that go to [https://github.com/settings/developers](https://github.com/settings/developers) and create a new OAuth App (or use existing if already exists)
  * Copy clientId and client secret of the OAuth app and paste them in the GitHub provider section of firebase
  * You will see a callback url in the github section of firebase. Use it as Authorization callback URL in GitHub
  * Use flutterfire to connect the flutter project to your firebase project ```flutterfire configure```

**Trouble Shooting**
SHA error - send your SHA key in whatsapp to repo author. ![image](https://github.com/user-attachments/assets/787091fe-f850-4db4-b77c-778921923595)
