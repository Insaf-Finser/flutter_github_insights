<br />
<div align="center">
<!--   <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h3 align="center">Flutter GitHub Insights</h3>
</div>

### About The Project

The project is a Flutter application that integrates with Firebase Authentication to allow users to log in using their GitHub accounts. Once authenticated, users can view all their repositories, both private and public, and perform various actions such as creating new repositories and adding files to existing ones.

### Technical Implementation

* **Auth Setup**
  * Enable authentication in your firebase project
  * Enable GitHub provider in Sign-in method
  * It requires clientId and client secret of your github developer OAuth app.
  * For that go to [https://github.com/settings/developers](https://github.com/settings/developers) and create a new OAuth App (or use existing if already exists)
  * Copy clientId and client secret of the OAuth app and paste them in the GitHub provider section of firebase
  * You will see a callback url in the github section of firebase. Use it as Authorization callback URL in GitHub
  * Use flutterfire to connect the flutter project to your firebase project
