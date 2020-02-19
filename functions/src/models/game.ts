import { DocumentBuilder } from 'firebase-functions/lib/providers/firestore';

export interface Game {
    id: number;
    status: GameStatus;
    teamOne: Map<string, number>;
    teamTwo: Map<string, number>;
    tournament: DocumentBuilder;
    type: GameType;
}

export enum GameStatus {
    NOT_STARTED,
    IN_PROGRESS,
    FINISHED,
}

export enum GameType {
    QUALIFIER,
    SEMI_FINAL,
    FINAL,
}