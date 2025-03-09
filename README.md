# Food Nutrition App Mobile UI

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Registration Page

The registration page displays required input fields for users to register an account to use the application.
The page includes a button to switch to the login page if the user already has an account.

### Login Page

The login page displays input fields for:

- Username
- Password

Users are required to enter these details to log in.
Users can also log in using Google without the need to register an account beforehand.
The page includes a button to switch to the registration page for users who do not have an account and want to register manually.

### Settings Page

Displays the user’s avatar and account name. Includes a “Change Password” button to navigate to the password change page.

### Change Password Page

The change password page displays a field for the current password, requiring users to enter it for system verification.
Once verified, fields for the new password and password confirmation appear. Users must enter a new password (at least 8 characters long) and confirm it by entering it again.

### Forgot Password Page

The forgot password page displays input fields for:

- Username
- Email

Users need to fill in these details to verify the account's existence and receive an OTP code.
Once verified, an OTP input field appears for users to enter the received OTP code for validation.
After OTP verification, fields for the new password and confirmation password appear. Users must enter a new password (at least 8 characters long) and confirm it.

### Home Page

Upon login, the home page displays:

- User’s BMI check chart
- Suggested plans based on goals (if available)
- “Create New Plan” button to navigate to the goal-based plan creation page
- Navigation options to access various sections:
  - Food categories
  - Nutrients
  - Nutrition articles
  - BMI check page
  - User account page
- User’s avatar and a logout button in the sidebar

### Goal-Based Plan Creation Page

Displays input fields for:

- **Goal:** Options include weight loss, weight gain, and weight maintenance.
- **Activity Level:** Options include sedentary, light, moderate, active, and very active.
- A “Create Plan” button to generate a new suggested plan based on the user’s goal.

### User Account Page

Displays personal user information such as:

- Username
- Full name
- Avatar
- Date of birth
- Phone number
- Email
- Address
- Height
- Weight
- Gender

Users can update their personal account information.

### Food List Page

Users can:

- View a list of all available food items
- Search for foods by name
- View detailed information about each food item
- Post comments

### Nutrient List Page

Users can:

- View a list of all nutrients
- Search for nutrients by name
- View detailed information about each nutrient
- Post comments

### Nutrition Articles List Page

Users can:

- View a list of all nutrition articles
- Search for articles by title
- View detailed information about each article
- Post comments

### BMI Check Page

Displays input fields for users to enter:

- Height
- Weight

After calculation, the system provides the BMI result and body condition status.
If the user’s age is between 18-60 years old, the application will suggest nutritional foods along with relevant health notes.

### Suggested Foods Based on User's BMI

Displays a list of food recommendations based on the user's BMI results.


