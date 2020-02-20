import { GameStatus } from "./game";

export interface Tournament {
    id: string
    name: string
    details: string
    status: GameStatus
    year: number
    location: string
    start: Date
    end: Date
    owner: string
    scorers: Array<string>
}