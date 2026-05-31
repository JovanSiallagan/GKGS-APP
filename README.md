# GKGS APP

<p align="center">
  <img src="gkgs_app/assets/images/logo_gkgs.jpg" alt="GKGS Logo" width="200"/>
</p>

<p align="center">
  <b>A Digital Church Platform for Worship, Fellowship, and Spiritual Growth</b>
</p>

---

## Overview

**GKGS App** is a mobile application developed for **Gereja Kristus Gading Serpong (GKGS)** to support church services and congregation engagement through a modern digital platform.

The application integrates essential church activities into a single mobile experience, enabling congregation members to access church information, participate in spiritual growth programs, interact with the church community, record worship attendance, and access digital giving services.

The system consists of a **Flutter-based mobile application** and a **NestJS backend server** connected to a **PostgreSQL database** through **Prisma ORM**.

---

## Main Features

### Smart QR Attendance

Digital worship attendance system using QR Codes.

**Features**

* QR Code scanning for worship attendance
* Automatic attendance recording
* Digital attendance history

**Benefits**

* Faster attendance process
* Reduced manual administration
* Accurate attendance tracking

---

### Warta Jemaat (Church News)

Digital church bulletin and announcement platform.

**Features**

* Weekly church announcements
* Sermon information
* Ministry schedules
* Important church updates

**Benefits**

* Easy access to church information
* Environmentally friendly alternative to printed bulletins
* Real-time updates for congregation members

---

### Family Altar

Daily devotional feature designed to support spiritual growth.

**Features**

* Daily devotion content
* Scripture references
* Reflection materials
* Family worship resources

**Benefits**

* Encourages consistent devotional habits
* Supports family worship activities
* Accessible anytime through mobile devices

---

### Interaction Board

A community platform where congregation members can share prayer requests and testimonies.

**Post Types**

* **Prayer Request**
* **Testimony**

**Benefits**

* Strengthens church fellowship
* Encourages spiritual support among members
* Creates a sense of community engagement

---

### Digital Bible

Built-in Bible reader integrated directly into the application.

**Features**

* Read books and chapters of the Bible
* Accessible within the app
* Supports worship and devotional activities

---

### Digital Offering

Digital giving feature to facilitate church offerings.

**Features**

* QRIS support
* Offering information
* Cashless giving support

**Benefits**

* Convenient contribution process
* Supports hybrid and online worship
* Modern donation experience

---

# System Architecture

```text
Flutter Mobile Application
            │
            ▼
        REST API
            │
            ▼
      NestJS Backend
            │
            ▼
       Prisma ORM
            │
            ▼
       PostgreSQL
```

---

# Technology Stack

## Frontend

* Flutter
* Dart
* Go Router
* Shared Preferences
* HTTP Package
* Mobile Scanner

## Backend

* NestJS
* TypeScript
* Prisma ORM
* PostgreSQL
* JWT Authentication

---

# Project Structure

```text
GKGS-APP
│
├── gkgs_app/          # Flutter Frontend
├── gkgs-backend/      # NestJS Backend
├── data_awal_gkgs.sql # Sample Database
└── README.md
```

---

# Frontend Structure

The frontend application is built using Flutter and follows a feature-based structure to separate UI components, business logic, models, and services.

```text
gkgs_app/
│
├── assets/
│   ├── images/
│   └── icons/
│
├── lib/
│   │
│   ├── models/
│   │   ├── attendance_model.dart
│   │   ├── bible_model.dart
│   │   ├── family_altar_model.dart
│   │   ├── user_model.dart
│   │   └── ...
│   │
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── attendance_service.dart
│   │   ├── bible_service.dart
│   │   └── ...
│   │
│   ├── screens/
│   │   ├── auth/
│   │   ├── attendance/
│   │   ├── family_altar/
│   │   ├── bible/
│   │   ├── community/
│   │   ├── offering/
│   │   ├── profile/
│   │   └── home/
│   │
│   ├── widgets/
│   │   ├── common/
│   │   ├── cards/
│   │   └── components/
│   │
│   ├── routes/
│   │   └── app_router.dart
│   │
│   ├── constants/
│   ├── utils/
│   ├── theme/
│   └── main.dart
│
├── pubspec.yaml
└── README.md
```

### Main Screens

| Screen                   | Description                              |
| ------------------------ | ---------------------------------------- |
| Login Screen             | User authentication page                 |
| Register Screen          | New congregation member registration     |
| Home Screen              | Main dashboard of the application        |
| QR Attendance Screen     | Worship attendance via QR Code scanning  |
| Warta Jemaat Screen      | Church announcements and weekly bulletin |
| Family Altar Screen      | Daily devotion and family altar content  |
| Interaction Board Screen | Prayer requests and testimonies          |
| Bible Reader Screen      | Integrated digital Bible reader          |
| Offering Screen          | Digital offering and QRIS information    |
| Profile Screen           | User profile and account information     |

### Core Components

| Component | Responsibility                              |
| --------- | ------------------------------------------- |
| Models    | Represent application data structures       |
| Services  | Handle API communication and business logic |
| Screens   | Main user interface pages                   |
| Widgets   | Reusable UI components                      |
| Routes    | Navigation management using Go Router       |
| Utils     | Helper functions and utilities              |
| Theme     | Application styling and theme configuration |


---

# Backend Structure

The backend follows a modular architecture provided by NestJS.

```text
gkgs-backend/
│
├── prisma/
│   ├── schema.prisma
│   └── migrations/
│
├── src/
│   ├── auth/
│   ├── users/
│   ├── attendance/
│   ├── family-altar/
│   ├── warta/
│   ├── community-post/
│   ├── offering/
│   └── main.ts
│
├── package.json
└── .env
```

---

# Database Schema

The application uses several core entities to support church services and congregation engagement.

| Model             | Description                                                              |
| ----------------- | ------------------------------------------------------------------------ |
| **User**          | Stores congregation account and profile information.                     |
| **FamilyAltar**   | Stores devotional and family altar content.                              |
| **CommunityPost** | Stores interaction board posts created by congregation members.          |
| **Attendance**    | Stores worship attendance records generated through QR scanning.         |
| **Warta**         | Stores church announcements, sermon information, and ministry schedules. |

### Community Post Types

| Type          | Description                                        |
| ------------- | -------------------------------------------------- |
| **PRAYER**    | Prayer requests submitted by congregation members. |
| **TESTIMONY** | Testimonies shared by congregation members.        |

---

# Installation Guide

## Prerequisites

### Frontend

* Flutter SDK
* Android Studio
* Android SDK

### Backend

* Node.js (v18+ recommended)
* npm
* PostgreSQL

---

## 1. Clone Repository

```bash
git clone https://github.com/JovanSiallagan/GKGS-APP.git
cd GKGS-APP
```

---

## 2️. Backend Setup

Navigate to backend folder:

```bash
cd gkgs-backend
```

Install dependencies:

```bash
npm install
```

---

### Configure Environment Variables

Create a `.env` file:

```env
DATABASE_URL="postgresql://username:password@localhost:5432/gkgs_db"
JWT_SECRET="your-secret-key"
```

---

### Generate Prisma Client

```bash
npx prisma generate
```

---

### Run Database Migration

```bash
npx prisma migrate dev
```

---

### Import Sample Data

This repository includes sample data to simplify testing and demonstration.

```bash
psql -U postgres -d gkgs_db -f ../data_awal_gkgs.sql
```

Alternatively, import the SQL file using pgAdmin.

The sample database includes:

* User accounts
* Family Altar content
* Church News (Warta)
* Prayer Requests
* Testimonies
* Attendance records

---

### Run Backend Server

Development mode:

```bash
npm run start:dev
```

Production mode:

```bash
npm run start:prod
```

Backend URL:

```text
http://localhost:3000
```

---

## 3️. Frontend Setup

Navigate to Flutter project:

```bash
cd ../gkgs_app
```

Install dependencies:

```bash
flutter pub get
```

Run application:

```bash
flutter run
```

Build APK:

```bash
flutter build apk
```

Generated APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

# Authentication

GKGS App uses JWT-based authentication.

```text
User Login
    │
    ▼
Credential Validation
    │
    ▼
JWT Token Generation
    │
    ▼
Token Storage
    │
    ▼
Authorized API Access
```

---

# Application Flow

```text
Login / Register
        │
        ▼
      Home
        │
 ┌──────┼──────┐
 ▼      ▼      ▼
QR   Warta   Family Altar
 │      │          │
 ▼      ▼          ▼
Bible Interaction Offering
```

---

# Future Development

Potential future enhancements:

* Push notifications
* Live worship streaming
* Attendance analytics dashboard
* Event management
* Ministry scheduling
* Admin web dashboard
* Community moderation tools

---

# License

This project is intended for educational, research, and church ministry purposes.
