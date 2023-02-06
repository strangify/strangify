import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as _ from "lodash";
import Razorpay = require("razorpay");

const cors = require('cors')({origin: true});
var request = require("request");
import nodeFetch from "node-fetch";
import { uuidv4 } from "@firebase/util";
var jwt = require("jsonwebtoken");
admin.initializeApp();

var app_access_key = "6363af674208780bf6677c35";
var app_secret =
  "qZx_5DPbXpwaAKoX9kHnxjzRZt7mMaQsoqEyTw6JFXdPIp_NdQOYPOjZwwRaf7a1CQg7LA-VN0uTb-7L7Bu40cew4jYhc2vzkdMksIE5CX8xfuLYMSBdLQ5JfUi5E0G-kQJPYhNt_yeqOTUT39I7IGMXK8wqS7t10A2jn_RTiO4=";

  var key_id = "rzp_test_s5X5ImuVQBVKlA";
  var key_secret = "bVCX8JwYqPKYuaOh5NU3whxx";
  var instance = new Razorpay({
  key_id: key_id,
  key_secret: key_secret
});
  
  const db = admin.firestore();
  const fcm = admin.messaging();
  


  export const createOrder = functions.https.onCall(async (req, res) => {
    try{
        const order = await instance.orders.create({amount: `${req.amount}`, currency: 'INR', receipt: `${req.receipt}`, payment_capture: 1});
        return order;
    }catch(e){
        console.log(e);
        return {error: 'Something went wrong'};
    }
});

  export const capturePayments = functions.https.onCall((req, res) => {
    return cors(req, res, () => {
      request(
        {
          method: "POST",
          url: `https://${key_id}:${key_secret}@api.razorpay.com/v1/payments/${
            req.body.payment_id
          }/capture`,
          form: {
            amount: req.body.amount
          }
        },
        (error: any, response: any, body: any) => {
          // response
          //   ? res.status(200).send({
          //       res: response,
          //       req: req.body,
          //       body: body
          //     })
          //   : res.status(500).send(error);
          return response? {
                  res: response,
                  req: req.body,
                  body: body
                }:error
        }
      );
    });
  });
  
export const notifyNewMessage = functions.firestore
  .document("session/{sessionId}")
  .onCreate(async (snapshot) => {
    const message = snapshot.data();

    const querySnapshot = await db
      .collection("users")
      .doc(message.listenerId)

      .get();
    console.log(querySnapshot.data());
    const token = querySnapshot.data()?.deviceToken;

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `Incoming ${message.type.toUpperCase()} request`,
        body: "Accept Now ! Connect within 2 minutes.",
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    if (message.type == "call") {
      try {
        const token = await jwt.sign(
          {
            access_key: app_access_key,
            type: "management",
            version: 2,
            iat: Math.floor(Date.now() / 1000),
            nbf: Math.floor(Date.now() / 1000),
          },
          app_secret,
          {
            algorithm: "HS256",
            expiresIn: "24h",
            jwtid: uuidv4(),
          }
        );

        console.log("yash " + token);

        const response = await nodeFetch("https://api.100ms.live/v2/rooms", {
          method: "POST",
          body: JSON.stringify({ template_id: "636a779fe61bbea99a48ec53" }),
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + token,
          },
        });
        const data: any = await response.json();

        var speakerAuthPayload = {
          access_key: app_access_key,
          room_id: data["id"],
          user_id: message.speakerId,
          role: "Room-User",
          type: "app",
          version: 2,
          iat: Math.floor(Date.now() / 1000),
          nbf: Math.floor(Date.now() / 1000),
        };

        var listenerAuthPayload = {
          access_key: app_access_key,
          room_id: data["id"],
          user_id: message.listenerId,
          role: "Room-Host",
          type: "app",
          version: 2,
          iat: Math.floor(Date.now() / 1000),
          nbf: Math.floor(Date.now() / 1000),
        };
        const speaker100msToken = await jwt.sign(
          speakerAuthPayload,
          app_secret,
          {
            algorithm: "HS256",
            expiresIn: "24h",
            jwtid: uuidv4(),
          }
        );

        const listener100msToken = await jwt.sign(
          listenerAuthPayload,
          app_secret,
          {
            algorithm: "HS256",
            expiresIn: "24h",
            jwtid: uuidv4(),
          }
        );
        snapshot.ref.update({
          speakerAuthToken: speaker100msToken,
          listenerAuthToken: listener100msToken,
          roomId: data["id"]

        });
      } catch (e) {
        console.log(e);
      }
    }
    return fcm.sendToDevice(token, payload);
  });
/// update call
export const updateMessage = functions.firestore
  .document("session/{sessionId}")
  .onUpdate(async (change, _) => {
    const newValue = change.after.data();

    if (
      newValue.status == "active" ||
      newValue.status == "cancelled" ||
      newValue.status == "rejected"
    ) {
      const querySnapshot = await db
        .collection("users")
        .doc(
          newValue.status == "cancelled"
            ? newValue.listenerId
            : newValue.speakerId
        )

        .get();

      console.log(querySnapshot.data());
      const token = querySnapshot.data()?.deviceToken;

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title:
            newValue.status == "active"
              ? `${newValue.type.toUpperCase()} Request has been accepted!`
              : `Unfortunately ,the ${
                  newValue.status == "cancelled" ? "user" : "listener"
                } had to cancel the request!`,
          body:
            newValue.status == "active"
              ? `Join now!! to avoid extra charges`
              : `${
                  newValue.status == "cancelled"
                    ? `Please wait for a new ${newValue.type} with other user`
                    : `Please request a new ${newValue.type} with other listener`
                } and we’ll get you talking shortly.`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      return fcm.sendToDevice(token, payload);
    }
    return false;
  });

 
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
