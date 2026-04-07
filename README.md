# Auth App (Flutter)

A simple auth demo app with `login`, `register`, `OTP verification`, and `home/logout` flow.

## Tech Stack

- Flutter
- Clean Architecture (core / data / domain / presentation)
- `flutter_bloc` for state management
- `get_it` for dependency injection
- `dio` for API layer (with interceptor and error mapping)
- Custom lightweight `Either` + `Failure` handling

## Theme

- Primary color palette: `#605C4E`

## Features

- Login flow
- Register flow
- OTP verification flow
- Home screen after successful authentication
- Logout back to login
- Named route configuration via `AppRoutes`

## Project Structure

```text
lib/
  core/
    constants/
    di/
    error/
    network/
    routes/
    theme/
    utils/
  features/
    auth/
      data/
      domain/
      presentation/
```

## Demo Credentials

- Login success:
  - Email: `demo@mail.com`
  - Password: `123456789`
- OTP success: `123456`

## API Behavior

This project currently uses a mocked network layer in `MockAuthInterceptor`:

- `POST /auth/login`
- `POST /auth/register`
- `POST /auth/verify-otp`

The `DioClient` also includes ready methods for:

- `GET`
- `POST`
- `PUT`
- `PATCH`

## Run the App

```bash
flutter pub get
flutter run
```

## Notes

- Register expects a valid email and a password with at least 8 characters.
- Replace mocked interceptor responses with your real backend when ready.
