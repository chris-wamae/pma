# Unit Testing Plan: Auth & Owner Functionalities

## Overview
This document outlines the strategy for unit testing the authentication and owner property management modules of the PMA application. The goal is to ensure business logic correctness, robust error handling, and state management consistency.

## Testing Strategy
We will employ a bottom-up testing approach:
1.  **Repository Layer:** Verify data access and API interactions using mocks.
2.  **Service Layer:** Validate business rules and orchestration.
3.  **ViewModel Layer:** Test state transitions and UI logic in response to repository/service outputs.

---

## 1. Authentication Module

### `AuthRepository` & `AuthService`
- **Sign In:**
    - Success: Valid credentials return a user object.
    - Failure: Invalid credentials throw an `FirebaseAuthException`.
- **Sign Up:**
    - Success: New user account is created.
    - Failure: Email already in use or weak password.
- **OTP Verification:**
    - Success: Valid OTP verifies the account.
    - Failure: Expired or incorrect OTP.
- **Password Reset:**
    - Success: Reset email is sent.

### `AuthViewModel`
- **Sign In Flow:**
    - Verify `isLoading` is `true` during the call and `false` after completion.
    - Verify `error` message is set upon failure.
    - Verify correct navigation triggers based on user role (Owner, Manager, Tenant).
- **User Role Retrieval:**
    - Verify `getUserRole` returns the correct role from the database.

---

## 2. Owner Module

### `PropertyRepository`
- **Fetch Properties:**
    - Success: Returns a list of `PropertyModel` objects.
    - Empty state: Returns an empty list when no properties exist.
- **Add Property:**
    - Success: Property is successfully persisted to the database.
    - Failure: Handles network errors or validation failures.
- **Update Property:**
    - Success: Existing property details are updated.
- **Delete Property:**
    - Success: Property is removed from the database.

### `OwnerPropertyViewModel`
- **Load Properties:**
    - Verify `isLoading` state management.
    - Verify `properties` list is updated upon successful fetch.
- **Add Property Logic:**
    - Verify that calling `addProperty` triggers the repository and updates the local list.
- **Error Handling:**
    - Verify that repository errors are captured and surfaced as user-friendly messages.

---

## Implementation Roadmap
1.  **Environment Setup:** Add `test`, `mockito`, and `mocktail` to `pubspec.yaml`.
2.  **Mock Creation:** Create mock classes for `FirebaseAuth`, `FirebaseFirestore`, and other dependencies.
3.  **Auth Tests:** Implement `AuthRepository` $ightarrow$ `AuthService` $ightarrow$ `AuthViewModel` tests.
4.  **Owner Tests:** Implement `PropertyRepository` $ightarrow$ `OwnerPropertyViewModel` tests.
5.  **CI Integration:** Configure tests to run on every pull request.
