import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { GameStatus } from "./models/game";
// import { Tournament } from "./models/tournament";
admin.initializeApp();
const db = admin.firestore();

// export const calculateFinalScore = functions.firestore
//   .document("games/{gameId}")
//   .onUpdate((change, _context) => {
//     const newData = <Game>change.after.data();

//     if (newData.status !== GameStatus.FINISHED) return null;
//     const oneDifferential: number = newData.teamOne.get("differential");
//     const twoDifferential: number = newData.teamTwo.get("differential");
//     // if ((oneDifferential !== undefined && oneDifferential !== null) || (twoDifferential !== undefined && twoDifferential !== null)) return null;
//     if (oneDifferential !== 0 && twoDifferential !== 0) return null;

//     const teamOneScore: number = newData.teamOne.get("score");
//     const teamTwoScore: number = newData.teamTwo.get("score");

//     return change.after.ref.update({
//       teamOne: {
//         differential: teamOneScore - teamTwoScore
//       },
//       teamTwo: {
//         differential: teamTwoScore - teamOneScore
//       }
//     });
//   });

// export const addScore = functions.https.onCall(async (data, context) => {
//   if (!context.auth) {
//     throw new functions.https.HttpsError(
//       "failed-precondition",
//       "The function must be called while authenticated."
//     );
//   }
//   const uid = context.auth.uid;
//   const tournamentID = (data.id as string) || null;
//   const gameID = (data.gameID as string) || null;
//   const teamID = (data.teamID as string) || null;

//   if (tournamentID === null || gameID === null) {
//     throw new functions.https.HttpsError(
//       "invalid-argument",
//       'The function must be called with three arguments, "id", "teamID" and "gameID".'
//     );
//   }

//   const tournamentDoc = <Tournament>(
//     (await db.doc(`tournaments/${tournamentID}`).get()).data()
//   );
//   const scorers = tournamentDoc.scorers;
//   if (scorers.includes(uid)) {
//     const gameDoc = db.doc(`games/${gameID}`);
//     const gameDocData = <Game>(await gameDoc.get()).data();
//     let currentTeamOneScore = gameDocData.teamOne.get("score") as number;
//     let currentTeamTwoScore = gameDocData.teamTwo.get("score") as number;
//     if (gameDocData.teamOne.get("id") === teamID) {
//       gameDoc
//         .update({
//           teamOne: {
//             score: currentTeamOneScore++
//           }
//         })
//         .catch(reason => {
//           throw new functions.https.HttpsError(
//             "permission-denied",
//             `Permission denied: ${reason}`
//           );
//         });
//     } else if (gameDocData.teamTwo.get("id") === teamID) {
//       gameDoc
//         .update({
//           teamTwo: {
//             score: currentTeamTwoScore++
//           }
//         })
//         .catch(reason => {
//           throw new functions.https.HttpsError(
//             "permission-denied",
//             `Permission denied: ${reason}`
//           );
//         });
//     }
//   }
// });

export const updateTournaments = functions.pubsub
  .schedule("*/10 * * * *")
  .onRun(async context => {
    const now = admin.firestore.Timestamp.now()

    const startJobs = db
      .collection("tournaments")
      .where("startDate", "<=", now)
      .where("status", "==", GameStatus.NOT_STARTED)

    const endJobs = db
      .collection("tournaments")
      .where("endDate", ">=", now)
      .where("status", "==", GameStatus.IN_PROGRESS)

    const startTasks = await startJobs.get()

    const endTasks = await endJobs.get()

    const jobs: Promise<any>[] = []

    startTasks.forEach(snapshot => {
        const job = snapshot.ref.update({status: GameStatus.IN_PROGRESS})

        jobs.push(job)
    })

    endTasks.forEach(snapshot => {
        const job = snapshot.ref.update({status: GameStatus.FINISHED})

        jobs.push(job)
    })

    return await Promise.all(jobs)
  });
