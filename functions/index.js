/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//function
// "use strict";

const { onSchedule } = require("firebase-functions/v2/scheduler");
const { logger } = require("firebase-functions");
const axios = require("axios");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.scheduledRun = onSchedule("0 */5 * * *", async (event) => {

  try {
    const params = {
      key: process.env.WEATHER_KEY,
      q: "Missoula"
    };

    const response = await axios.get("http://api.weatherapi.com/v1/current.json", {params});

    const docRef = db.collection("weather").doc("current");
    await docRef.set({
      current: response.data
    });

    logger.log("✅ Current weather written to Firestore");
  } catch (error) {
    console.error(error);
    logger.error("❌ Error in scheduledRun", { structuredData: true, error });
  }
});

exports.scheduledRun2 = onSchedule("0 */5 * * *", async (event) => {
  try {
    const params = {
      key: process.env.WEATHER_KEY,
      q: "Missoula"
    };

    const response = await axios.get("http://api.weatherapi.com/v1/forecast.json", {params});

    const docRef = db.collection("weather").doc("forecast");
    await docRef.set({
      current: response.data
    });

    logger.log("✅ Forecast weather written to Firestore");
  } catch (error) {
    console.error(error);
    logger.error("❌ Error in scheduledRun2", { structuredData: true, error });
  }
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
