import 'dart:io';
import 'dart:math';

bool isFinished = false;
bool puttingFlags = false;

var numLetter = ["A", "B", "C", "D", "E", "F"];

var board = 
	[
		[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
		[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
		[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
		[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
		[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
		[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],
	];

var revisedPos = [];
var flags = [];

void main(List<String> arguments) {

	putBombs();

	while(!isFinished){
		printBoard();
		if(puttingFlags){
			stdout.write("\nWrite the position you want to put a flag on (write 'play' to attack) ");
		}else{
			stdout.write("\nWhat position do you want to try? (write 'flag' to put flags) ");
		}
		
		String? input = stdin.readLineSync();

		if(input != null) {
			if(input.toLowerCase() == "flag") {
				puttingFlags = true;
			}
			else if(input.toLowerCase() == "play") {
				puttingFlags = false;
			}
			else if(input.toLowerCase() == "cheat") {
				printCheatBoard();
			}
			else if(input.toLowerCase().length == 2 && numLetter.contains(input[0].toUpperCase())){
				if(puttingFlags) {
					putFlag(input);
				}else{
					play(input);
				}
				
			}
			
		}
	}

}

void printBoard() {
	print("\n    0   1   2   3   4   5   6   7   8   9 ");
	for(int i = 0; i < board.length; i++) {
		print("  +---+---+---+---+---+---+---+---+---+---+");
		stdout.write("${numLetter[i]} ");
		for(int j = 0; j < board[i].length; j++) {
			if(flags.contains("$i,$j")) {
				stdout.write("|");
				stdout.write('\x1B[41m # \x1B[0m');
			}else if(board[i][j] == 0){
				stdout.write("|   ");
			}else {
				stdout.write("| ${board[i][j]<0 ? "·" : board[i][j]} ");
			}
		}
		print("|");
	} 
	print("  +---+---+---+---+---+---+---+---+---+---+");
}

void printCheatBoard() {
	print("\n    0   1   2   3   4   5   6   7   8   9 ");
	for(int i = 0; i < board.length; i++) {
		print("  +---+---+---+---+---+---+---+---+---+---+");
		stdout.write("${numLetter[i]} ");
		for(int j = 0; j < board[i].length; j++) {
			if(board[i][j]==-2) {
				stdout.write("| B ");
			}else {
				stdout.write("| · ");
			}
		}
		print("|");
	} 
	print("  +---+---+---+---+---+---+---+---+---+---+");
}


void putBombs() {
	int numBombs = 8;
	var random = Random();

	int firstQuadr = 0;
	int secondQuadr = 0;
	int thirdQuadr = 0;
	int forthQuadr = 0;

	while(numBombs > 0) {
		int row = random.nextInt(6);
		int col = random.nextInt(10);

		if(board[row][col] == -1) {
			if(row < 3 && col < 5) {
				if(firstQuadr < 2) {
					board[row][col] = -2;
					numBombs--;
					firstQuadr++;
				}
			}
			else if(row < 3) {
				if(secondQuadr < 2) {
					board[row][col] = -2;
					numBombs--;
					secondQuadr++;
				}
			}
			else if(col < 5) {
				if(thirdQuadr < 2) {
					board[row][col] = -2;
					numBombs--;
					thirdQuadr++;
				}
			}
			else {
				if(forthQuadr < 2) {
					board[row][col] = -2;
					numBombs--;
					forthQuadr ++;
				}
			}
			
		}
	}
}

void play(String value) {

	int col = int.parse(value[1]);

	String rowStr = value[0].toUpperCase();
	int row = -1;
	switch(rowStr){
		case "A":
			row = 0;
		case "B":
			row = 1;
		case "C":
			row = 2;
		case "D":
			row = 3;
		case "E":
			row = 4;
		case "F":
			row = 5;
		case "G":
			row = 6;
		case "H":
			row = 7;
		break;
	}

	checkPos(row,col);

}

void checkPos(row,col){
	if(!revisedPos.contains("$row,$col")){
		revisedPos.add("$row,$col");
		try{
			if(board[row][col] == -1) {
				int nearBombs = calculateNearBombs(row,col);
				if(nearBombs == 0) {
					checkPos(row-1, col);
					checkPos(row-1, col-1);
					checkPos(row-1, col+1);
					checkPos(row, col-1);
					checkPos(row, col+1);
					checkPos(row+1, col-1);
					checkPos(row+1, col);
					checkPos(row+1, col+1);
				}
			}else if(board[row][col] == -2){
				isFinished = true;
				print("Game lost :(");
			}
		}catch(e){
			e.toString();
		}
	}
	
}

int calculateNearBombs(row,col) {
	int numBombs = 0;

	try {
	if (board[row - 1][col] == -2) {
		numBombs++;
	}
	} catch (e) {}

	try {
	if (board[row - 1][col - 1] == -2) {
		numBombs++;
	}
	} catch (e) {}

	try {
	if (board[row - 1][col + 1] == -2) {
		numBombs++;
	}
	} catch (e) {}

// Repite lo mismo para las demás verificaciones
	try {
	if (board[row][col - 1] == -2) {
		numBombs++;
	}
	} catch (e) {}

	try {
	if (board[row][col + 1] == -2) {
		numBombs++;
	}
	} catch (e) {}

	try {
	if (board[row + 1][col - 1] == -2) {
		numBombs++;
	}
	} catch (e) {}

	try {
	if (board[row + 1][col] == -2) {
		numBombs++;
	}
	} catch (e) {}

	try {
	if (board[row + 1][col + 1] == -2) {
		numBombs++;
	}
	} catch (e) {}

	board[row][col] = numBombs;
	return numBombs;
}

void putFlag(String value) {

	int col = int.parse(value[1]);

	String rowStr = value[0];
	int row = -1;
	switch(rowStr.toUpperCase()){
		case "A":
			row = 0;
		case "B":
			row = 1;
		case "C":
			row = 2;
		case "D":
			row = 3;
		case "E":
			row = 4;
		case "F":
			row = 5;
		case "G":
			row = 6;
		case "H":
			row = 7;
		break;
	}

	if(flags.contains("$row,$col")){
		flags.remove("$row,$col");
	}

	else if(board[row][col] == -1 || board[row][col] == -2) {
		flags.add("$row,$col");
	}
	

}