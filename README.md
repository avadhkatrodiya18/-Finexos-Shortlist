

Flutter sdk version:3.29.3


===>>> To run App:

flutter upgrade
flutter config --enable-web
flutter run -d chrome

===>>> Run tests
command- 
flutter test

===>>> To see code coverage:

command-
flutter test --coverage


Folder Structure Overview


Copy
lib/
├── data/
│   ├── models/              # Sensor data model definitions
│   └── services/            # Mock data service (no backend)
│
├── domain/
│   └── repo/                # Abstract repository interface
│
├── presentation/
│   ├── viewmodels/          # Dashboard logic 
│   ├── views/               # Dashboard, Detail, and Settings screens
│   └── widgets/             # Reusable UI components (charts, etc.)
│
├── routes/
│   └── app_pages.dart       # All navigation definitions
│
└── main.dart                # Entry point with GetMaterialApp

==>Implementation Notes

Architecture: Follows MVVM with domain-driven layering for better testability and modularity.

State Management: Uses Getx for reactive variables and routing.

Charts: Built using fl_chart, with dynamic bubble rendering and tooltips.

Testing: Unit tests validate core logic, and widget tests cover UI functionality.

===>>>Features 

Toggle between Humidity and Pressure for bubble sizing

Simulate offline sensors and anomalies from the Settings screen

Clickable sensor bubbles with detailed tooltips

Clean UI with responsive layout for web

Mocked sensor data without external APIs

Built using Flutter 3.19+, Getx, and fl_chart. """


