# 📱 Chime (Chime-Talk)

### 📝 Description
**Chime-Talk** is a cross-platform mobile application built using Flutter and Dart that connects users randomly via **video call**. Once connected, users can also **exchange text messages** with their partner. The app is designed for real-time social interaction, combining **WebRTC**, **device sensors**, and **secure backend services** to create an intuitive and entertaining experience.

---

### 🚀 Features

- 🔄 **Random Video Calling** via secure WebRTC connections
- 💬 **Text Chat During Call** for richer interaction
- 🎥 **Camera & Microphone Support**
- 🤝 **Real-time Matching Engine** using Sockets

---

### 📡 Sensors & APIs

**Chime Talk leverages multiple device sensors and third-party APIs to enhance performance and user experience:**

- 🎥 **WebRTC**: Enables real-time peer-to-peer video/audio communication by accessing the device's **camera** and **microphone**.
- 📶 **Socket.IO**: Used for real-time signaling and communication between users.
- 📍 **Proximity Sensor**: Automatically mutes the microphone when the phone is held close to the face, minimizing background noise and accidental input.
- 💡 **Light Sensor**: Detects ambient lighting and notifies users to improve visibility if lighting is too low.
- 📳 **Accelerometer**: Detects shake gestures, allowing users to quickly **switch the front/rear camera** during an active call.
- 🔐 **JWT Authentication**: User authentication and session security handled by a custom backend with JSON Web Tokens.

---

### 🧪 Testing

- ✅ Basic unit and widget tests implemented
- 🧪 Manual tests for shake gestures


