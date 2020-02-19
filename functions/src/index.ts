import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin'
import { Game, GameStatus } from './models/game';
admin.initializeApp()

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

export const updateScore = functions.firestore.document('games/{gameId}').onUpdate((change, _context) => {
    const newData = <Game>change.after.data();

    if (newData.status !== GameStatus.FINISHED) return null;
    if (newData.teamOne.get('differential') !== undefined && newData.teamOne.get('differential') !== null) return null;

    const teamOneScore: number = newData.teamOne.get('score')!
    const teamTwoScore: number = newData.teamTwo.get('score')!

    return change.after.ref.set({
        teamOne: {
            differential: teamOneScore - teamTwoScore
        },
        teamTwo: {
            differential: teamTwoScore - teamOneScore
        }
    }, {merge: true});
});
