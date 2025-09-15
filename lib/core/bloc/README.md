# User Store Documentation

This directory contains the BLoC (Business Logic Component) implementations for state management in the Save Tuba app.

## UserBloc

The `UserBloc` manages user data state throughout the application, providing a centralized way to access and update user profile information.

### Features

- **Load User Profile**: Fetch user data from the API
- **Update Profile**: Update user's first name and last name
- **Update Profile Picture**: Upload and update user's avatar
- **Refresh Profile**: Reload user data
- **Clear Data**: Clear user data on logout

### Usage

#### 1. Access User Data in Widgets

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_tuba/core/bloc/bloc.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return CircularProgressIndicator();
        }
        
        if (state is UserLoaded) {
          final user = state.user;
          return Text('Hello ${user.firstName} ${user.lastName}');
        }
        
        if (state is UserError) {
          return Text('Error: ${state.message}');
        }
        
        return Text('No user data');
      },
    );
  }
}
```

#### 2. Dispatch Events

```dart
// Load user profile
context.read<UserBloc>().add(LoadUserProfile());

// Update profile
context.read<UserBloc>().add(UpdateUserProfile(
  firstName: 'John',
  lastName: 'Doe',
));

// Update profile picture
context.read<UserBloc>().add(UpdateProfilePicture('/path/to/image.jpg'));

// Refresh profile
context.read<UserBloc>().add(RefreshUserProfile());

// Clear user data (on logout)
context.read<UserBloc>().add(ClearUserData());
```

#### 3. Access User Data from Anywhere

```dart
import 'package:save_tuba/core/services/services.dart';

class MyService {
  void doSomething(BuildContext context) {
    final userDataService = UserDataService.instance;
    
    // Get current user
    final user = userDataService.getCurrentUser(context);
    
    // Get user's full name
    final fullName = userDataService.getUserFullName(context);
    
    // Get experience points
    final xp = userDataService.getUserExperiencePoints(context);
    
    // Check if user is loading
    final isLoading = userDataService.isLoading(context);
  }
}
```

### States

- **UserInitial**: Initial state, no user data
- **UserLoading**: Loading user data
- **UserLoaded**: User data successfully loaded
- **UserError**: Error occurred while loading/updating user data

### Events

- **LoadUserProfile**: Load user profile from API
- **UpdateUserProfile**: Update user profile information
- **UpdateProfilePicture**: Update user's profile picture
- **RefreshUserProfile**: Refresh user data
- **ClearUserData**: Clear all user data

### Helper Methods

The `UserBloc` provides several helper methods:

- `currentUser`: Get the current user data
- `isLoading`: Check if user data is being loaded
- `isUpdating`: Check if user data is being updated
- `hasUser`: Check if user data is available

### Integration

The `UserBloc` is automatically provided to the widget tree in `main.dart` and can be accessed from any widget using `BlocBuilder` or `context.read<UserBloc>()`.

### Example: Profile Page

```dart
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<UserBloc>()..add(LoadUserProfile()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return CircularProgressIndicator();
          }
          
          if (state is UserError) {
            return ErrorWidget(
              message: state.message,
              onRetry: () => context.read<UserBloc>().add(LoadUserProfile()),
            );
          }
          
          if (state is UserLoaded) {
            return ProfileContent(user: state.user);
          }
          
          return Container();
        },
      ),
    );
  }
}
```

This architecture ensures that user data is consistently available throughout the app and automatically updates when changes occur.
