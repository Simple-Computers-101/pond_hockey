import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { Game, GameStatus } from './models/game';
import { Tournament } from './models/tournament';
admin.initializeApp()

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const calculateFinalScore = functions.firestore.document('games/{gameId}').onUpdate((change, _context) => {
    const newData = <Game>change.after.data();

    if (newData.status !== GameStatus.FINISHED) return null;
    const oneDifferential:number = newData.team_one.get('differential')
    const twoDifferential:number = newData.team_two.get('differential')
    // if ((oneDifferential !== undefined && oneDifferential !== null) || (twoDifferential !== undefined && twoDifferential !== null)) return null;
    if (oneDifferential !== 0 && twoDifferential !== 0) return null;

    const teamOneScore: number = newData.team_one.get('score')
    const teamTwoScore: number = newData.team_two.get('score')

    return change.after.ref.update({
        teamOne: {
            differential: teamOneScore - teamTwoScore
        },
        teamTwo: {
            differential: teamTwoScore - teamOneScore
        }
    });
});

export const addScore = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.')
    }
    const uid = context.auth.uid;
    const tournamentID = data.id as string || null;
    const gameID = data.gameID as string || null;
    const teamID = data.teamID as string || null;

    if (tournamentID === null || gameID === null) {
        throw new functions.https.HttpsError('invalid-argument', 'The function must be called with three arguments, "id", "teamID" and "gameID".');
    }

    const tournamentDoc = <Tournament>(await admin.firestore().doc(`tournaments/${tournamentID}`).get()).data()
    const scorers = tournamentDoc.scorers;
    if (scorers.includes(uid)) {
        const gameDoc = admin.firestore().doc(`games/${gameID}`)
        const gameDocData = <Game>(await gameDoc.get()).data()
        let currentTeamOneScore = gameDocData.team_one.get('score') as number
        let currentTeamTwoScore = gameDocData.team_two.get('score') as number
        if (gameDocData.team_one.get('id') === teamID) {
            gameDoc.update({
                team_one: {
                    score: currentTeamOneScore++
                }
            }).catch((reason) => {
                throw new functions.https.HttpsError('permission-denied', `Permission denied: ${reason}`)
            })
        } else if (gameDocData.team_two.get('id') === teamID) {
            gameDoc.update({
                team_two: {
                    score: currentTeamTwoScore++
                }
            }).catch((reason) => {
                throw new functions.https.HttpsError('permission-denied', `Permission denied: ${reason}`)
            })
        }
    }
});

// async function grantOwnerRole(email: string): Promise<void> {
//     const user = await admin.auth().getUserByEmail(email);
//     if (user.customClaims && (user.customClaims as any).owner === true) {
//         return;
//     }
//     return admin.auth().setCustomUserClaims(user.uid, {
//         owner: true,
//         scorer: true,
//     });
// }

// async function grandScorerRole(email: string): Promise<void> {

// }
