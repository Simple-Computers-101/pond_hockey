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

    return change.after.ref.update({
        teamOne: {
            differential: teamOneScore - teamTwoScore
        },
        teamTwo: {
            differential: teamTwoScore - teamOneScore
        }
    });
});

async function grantOwnerRole(email: string): Promise<void> {
    const user = await admin.auth().getUserByEmail(email);
    if (user.customClaims && (user.customClaims as any).owner === true) {
        return;
    }
    return admin.auth().setCustomUserClaims(user.uid, {
        owner: true,
        scorer: true,
    });
}

async function grandScorerRole(email: string): Promise<void> {

}
